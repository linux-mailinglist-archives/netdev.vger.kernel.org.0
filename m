Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EC14DC3F8
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiCQKcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiCQKcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:32:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364E81DE6FA
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:30:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id r13so9720543ejd.5
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GESVSF/vUl6xT+Qib5pebfeun/MqJ+wylwr9AmWECwY=;
        b=B5XE250IMRWtWCX7eNyCiDiuRXXqLIulRNScZZ+j5lWskcqW6pXT8HU9EnMmQ+DNLE
         sIIA80g14GzshUwr0dPERlKI9DNmNczvtdwidDTtIyP+k5yGnI2hyW2phYyKX+0LVDBC
         ooq52cfG4NwzSOeCTzVeuYRlFcAA2rCI5trVqlXqNuZsJQCGnvenW7D7tm2tfVdyvo3Y
         QwXxPBYb82W2y1ctWavIThCfAnD0SsbB0V9mdupHnJlKVuhhcGICR73WD+tzFCLqcQMc
         CfJAEmiADlMWA3YxBU3lM2MARENIKAY0kLxGMtSXK7zCcm22I6iFs6kC+rY3f8BAQvA/
         oXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GESVSF/vUl6xT+Qib5pebfeun/MqJ+wylwr9AmWECwY=;
        b=f4oiSWfI7uInCYlMWGtUeOf74nW4paVZdOMtn6PRbAJJErB2hIUTWz6B5xfZ7OOlT1
         oiN/dhqZxE//tsGIWTZ/4b7SHa6s+WJCyn0vR5XAu5hcfeRS8EeDuvo/4by+ZjQgbeJY
         s+rObEN5bhpI+TvI9IcCvbvJlmlRYP6qRGipFp1PrrNPt0MLVIRne8cg/tltw9U4wUn4
         JK2tO/EWw1J4DmxDeIuOqEiIuiNwnHJxkTWIL3IpBWOr6L9uLsN7SpM+KSRPZL28a6dG
         HvGefjLSgBCB+M+LrjGA8ZJphMFb9Xm73ECzidCYd0rIdrrEOIayWsvP4RrAvQuxWpKG
         4SFA==
X-Gm-Message-State: AOAM530eg3HQOuwdz5mK+YEb5iq1zoazWRTYHUKot516hxkkmWfxYvhC
        kZDO52HaSv+gwaa8bO76QdHldmg6yfj/XW6N5QPjMQ==
X-Google-Smtp-Source: ABdhPJwPC15e4W7aDqe2A0162z2EcEAk3DfXDISyzWQtLz8tVkE6xNrUBrvHUgi/nqxnDM2m+elrcQ==
X-Received: by 2002:a17:906:3e90:b0:6b6:829b:577c with SMTP id a16-20020a1709063e9000b006b6829b577cmr3720298ejj.711.1647513053604;
        Thu, 17 Mar 2022 03:30:53 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id i25-20020a50fd19000000b0041614eca4d1sm2437853eds.12.2022.03.17.03.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 03:30:53 -0700 (PDT)
Message-ID: <810a0399-4505-bafc-a99a-07d7943df8bb@blackwall.org>
Date:   Thu, 17 Mar 2022 12:30:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <87r1717xrz.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <87r1717xrz.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 11:07, Joachim Wiberg wrote:
> On Thu, Mar 17, 2022 at 07:50, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
>> This patch implements the bridge flood flags. There are three different
>> flags matching unicast, multicast and broadcast. When the corresponding
>> flag is cleared packets received on bridge ports will not be flooded
>> towards the bridge.
> 
> If I've not completely misunderstood things, I believe the flood and
> mcast_flood flags operate on unknown unicast and multicast.  With that
> in mind I think the hot path in br_input.c needs a bit more eyes.  I'll
> add my own comments below.
> 
> Happy incident I saw this patch set, I have a very similar one for these
> flags to the bridge itself, with the intent to improve handling of all
> classes of multicast to/from the bridge itself.

+1

I'll add my comments below, yours are pretty spot on. I have one more
that's for the snipped part, I'll send that separately. :)

First please split this into 3 separate patches - one for each flag.
That would make reviewing much easier.

> >> [snip]
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index e0c13fcc50ed..fcb0757bfdcc 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  		/* by definition the broadcast is also a multicast address */
>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>>  			pkt_type = BR_PKT_BROADCAST;
>> -			local_rcv = true;
>> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
> 
> Minor comment, I believe the preferred style is more like this:
> 
> 	if (br_opt_get(br, BROPT_BCAST_FLOOD))
>         	local_rcv = true;
> 

ack

>>  		} else {
>>  			pkt_type = BR_PKT_MULTICAST;
>> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> -				goto drop;
>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
>> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> +					goto drop;
> 
> Since the BROPT_MCAST_FLOOD flag should only control uknown multicast,
> we cannot bypass the call to br_multicast_rcv(), which helps with the
> classifcation.  E.g., we want IGMP/MLD reports to be forwarded to all
> router ports, while the mdb lookup (below) is what an tell us if we
> have uknown multicast and there we can check the BROPT_MCAST_FLOOD
> flag for the bridge itself.
> 

+1

>>  		}
>>  	}
>>  
>> @@ -155,9 +156,13 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  			local_rcv = true;
>>  			br->dev->stats.multicast++;
>>  		}
>> +		if (!br_opt_get(br, BROPT_MCAST_FLOOD))
>> +			local_rcv = false;
> 
> We should never set local_rcv to false, only ever use constructs that
> set it to true.  Here the PROMISC flag (above) condition would be
> negated, which would be a regression.
> 
> Instead, for multicast I believe we should ensure that we reach the
> else statement for unknown IP multicast, preventing mcast_hit from
> being set, and instead flood unknown multicast using br_flood().
> 
> This is a bigger change that involves:
> 
>   1) dropping the mrouters_only skb flag for unknown multicast,
>      keeping it only for IGMP/MLD reports
>   2) extending br_flood() slightly to flood unknown multicast
>      also to mcast_router ports
> 
> As I mentioned above, I have some patches, including selftests, for
> forwarding known/unknown multicast using the mdb and mcast_flood +
> mcast_router flags.  Maybe we should combine efforts here somehow?
> 

Ack, sounds good! Please coordinate that between yourselves, if the mcast
flood flag will be dropped from this set or if Joachim's will be integrated.

>>  		break;
>>  	case BR_PKT_UNICAST:
>>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
>> +		if (!br_opt_get(br, BROPT_FLOOD))
>> +			local_rcv = false;
> 
> Again, never set it to false, invert the check instead, like this:
> 
> 		if (!dst && br_opt_get(br, BROPT_FLOOD))
> 			local_rcv = true;
> 
>>  		break;
>>  	default:
>>  		break;
>> @@ -166,7 +171,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  	if (dst) {
>>  		unsigned long now = jiffies;
>>  
>> -		if (test_bit(BR_FDB_LOCAL, &dst->flags))
>> +		if (test_bit(BR_FDB_LOCAL, &dst->flags) && local_rcv)
>>  			return br_pass_frame_up(skb);
> 
> I believe this would break both the flooding of unknown multicast and
> the PROMISC case.  Down here we are broadcast or known/unknown multicast
> land, so the local_rcv flag should be sufficient.
> 
>>  		if (now != dst->used)
>> @@ -190,6 +195,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  }
>>  EXPORT_SYMBOL_GPL(br_handle_frame_finish);
>>  
>> +bool br_flood_enabled(const struct net_device *dev)
>> +{
>> +	struct net_bridge *br = netdev_priv(dev);

const

>> +
>> +	return !!(br_opt_get(br, BROPT_FLOOD) ||
>> +		   br_opt_get(br, BROPT_MCAST_FLOOD) ||
>> +		   br_opt_get(br, BROPT_BCAST_FLOOD));
> 
> Minor nit, don't know what the rest of the list feels about this, but
> maybe the BROPT_FLOOD option should be renamed to BR_UCAST_FLOOD or
> BR_UNICAST_FLOOD?
> 

Exactly, very good suggestion. Unfortunately we already have BR_FLOOD and can't
do anything about it, but we shouldn't follow that bad example.

> Best regards
>  /Joachim

Cheers,
 Nik
