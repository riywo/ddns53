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
          a_records.push({
            name:       rr.name,
            ip:         rr.resource_records.first[:value],
            ttl:        rr.ttl,
            update_url: "/#{rr.name}",
          })
        end
      end
    end
    a_records
  end

  def update_a_record(name)
    zones.each do |zone|
      rrsets = AWS::Route53::HostedZone.new(zone[:id]).rrsets
      rrsets.each do |rr|
        if(rr.type == "A" and rr.resource_records.size == 1 and rr.name == name)
          rr.resource_records = [{
            value: request.ip
          }]
          rr.ttl = ENV['DDNS53_TTL'].to_i if ENV.has_key? 'DDNS53_TTL'
          rr.update
          return true
        end
      end
    end
    return false
  end
end
end
