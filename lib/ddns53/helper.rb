require 'aws-sdk'

module Ddns53
module Helper
  def zones
    AWS::Route53.new.client.list_hosted_zones[:hosted_zones]
  end

  def a_records
    a_records = []
    zones.each do |zone|
      rrsets = AWS::Route53::HostedZone.new(zone[:id]).rrsets
      rrsets.each do |rr|
        if(rr.type == "A" and rr.resource_records.size == 1)
          fqdn = rr.name.chomp(".")
          next unless is_valid_fqdn?(fqdn)
          a_records.push({
            fqdn:       fqdn,
            ip:         rr.resource_records.first[:value],
            ttl:        rr.ttl,
            update_url: "/#{fqdn}",
          })
        end
      end
    end
    a_records
  end

  def is_valid_fqdn?(fqdn)
    fqdn_list.include?(fqdn)
  end

  def fqdn_list
    env = ENV["DDNS53_FQDN"] || ""
    env.split(",")
  end

  def ttl
     ENV.has_key? 'DDNS53_TTL' ? ENV['DDNS53_TTL'].to_i : 300
  end

  def update_a_record(fqdn)
    return false unless is_valid_fqdn?(fqdn)
    zones.each do |zone|
      rrsets = AWS::Route53::HostedZone.new(zone[:id]).rrsets
      rrsets.each do |rr|
        if(rr.type == "A" and rr.resource_records.size == 1 and rr.name.chomp(".") == fqdn)
          rr.resource_records = [{
            value: request.ip
          }]
          rr.ttl = ttl
          rr.update
          return true
        end
      end
    end
    return false
  end
end
end
