Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA364FE98F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiDLUnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiDLUnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:43:07 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D837CAD132
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:37:48 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id l7so34155701ejn.2
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=I4z0Q+kVty7sI3xvt4Jn5yaTWEV4dzQy0QtiMftM0TI=;
        b=muFNfA7VGu7lj90zfUkJJI6aCC/++MupaW9xL5VaRc0P85f/O7nY35HMLQRYpZLPKc
         +gFaEVIomhuaGTOCVU5SIbplMOIVZ3Qyqcfm/zyNq57Y+V2S1l40DZn1KEmEmXJinhcR
         nOzBiIzcpjGAlOXKw+tbqK3s8VjccGbcE4cr2frbSMlPhP9HHgMaH6e8V7RkaA6CQWaz
         f6xlHETtWKkZz8pN8mCC2ZYzH0xx6bEXnZTQ1lBzb614/zePwVuepITHcEvatDG2Xcwz
         iIHbvaDwodRgtsTKIQEUtE8SpsdRvngcIbkKfU1CipXRar3b5xaWGKiSHgap3Y6xqw7t
         07jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=I4z0Q+kVty7sI3xvt4Jn5yaTWEV4dzQy0QtiMftM0TI=;
        b=bY0c+Gedkp33khfd32EFoHX3i0sjWSoyeGbRYngIkDIAi5AyrXMrx1H7e9SMoWnQRL
         NauXS9hq+CRRKhAQfyl6gcSwYPw2VjdTX0UJiwVC+pIAAvTPsmmqRT/WddYhmcZ2Y8wa
         YoIJ1tZh+iILQ0U5brTaFNF5yDlH/Hc2EkxCwHE1s9FRbs6yZZdlbIR2NCONAqfZ3pay
         +Jwx3CWmoCkw3t/2NkrQ1t4M3Hu20wB5JY79xAZIBiV1b4QsXA0PLHTl/3O7FjolXN36
         zn49DK8etq8BQPRNkO3Jh96+BBYJ/MwK4Ap3q93LMULrT7U03jRLkS1QQY/CgV/VO4jF
         BAjA==
X-Gm-Message-State: AOAM531FrOZbb/wFQ+Yq4J1tSLdMzp64w8uzgjEk6cguuTYQLV7o7Awm
        x/7SXh9gyv4+6tnRveJXTEUN0w==
X-Google-Smtp-Source: ABdhPJzl4+FUrxcLtZ+9xO04KNrGjQoPqbQ1Ho2BWcT6p64Cpj9j0w58p3TJpqiwiuiOWLZwvXKvUg==
X-Received: by 2002:a17:907:728c:b0:6e8:a052:4f03 with SMTP id dt12-20020a170907728c00b006e8a0524f03mr7099399ejc.344.1649795390855;
        Tue, 12 Apr 2022 13:29:50 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r19-20020a17090638d300b006d6e4fc047bsm13692182ejd.11.2022.04.12.13.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 13:29:50 -0700 (PDT)
Message-ID: <d88e8591-14fd-de90-ced7-b372c8fe81e5@blackwall.org>
Date:   Tue, 12 Apr 2022 23:29:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 01/13] net: bridge: add control of bum
 flooding to bridge itself
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-2-troglobit@gmail.com>
 <99b0790a-9746-ea08-b57e-52c53436666d@blackwall.org>
In-Reply-To: <99b0790a-9746-ea08-b57e-52c53436666d@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2022 21:27, Nikolay Aleksandrov wrote:
> On 11/04/2022 16:38, Joachim Wiberg wrote:
>> The bridge itself is also a port, but unfortunately it does not (yet)
>> have a 'struct net_bridge_port'.  However, in many cases we want to
>> treat it as a proper port so concessions have been made, e.g., NULL
>> port or host_joined attributes.
>>
>> This patch is an attempt to more of the same by adding support for
>> controlling flooding of unknown broadcast/unicast/multicast to the
>> bridge.  Something we often also want to control in an offloaded
>> switching fabric.
>>
>> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
>> ---
>>  net/bridge/br_device.c  |  4 ++++
>>  net/bridge/br_input.c   | 11 ++++++++---
>>  net/bridge/br_private.h |  3 +++
>>  3 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
>> index 8d6bab244c4a..0aa7d21ac82c 100644
>> --- a/net/bridge/br_device.c
>> +++ b/net/bridge/br_device.c
>> @@ -526,6 +526,10 @@ void br_dev_setup(struct net_device *dev)
>>  	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
>>  	dev->max_mtu = ETH_MAX_MTU;
>>  
>> +	br_opt_toggle(br, BROPT_UNICAST_FLOOD, 1);
> 
> This one must be false by default. It changes current default behaviour.
> Unknown unicast is not currently passed up to the bridge if the port is

s/port/bridge/ in promisc mode

> not in promisc mode, this will change it. You'll have to make it consistent
> with promisc (e.g. one way would be for promisc always to enable unicast flood
> and it won't be possible to be disabled while promisc).
> 
>> +	br_opt_toggle(br, BROPT_MCAST_FLOOD, 1);
>> +	br_opt_toggle(br, BROPT_BCAST_FLOOD, 1);
> 
> s/1/true/ for consistency
> 
>> +
>>  	br_netfilter_rtable_init(br);
>>  	br_stp_timer_init(br);
>>  	br_multicast_init(br);
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index 196417859c4a..d439b876bdf5 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -118,7 +118,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  		/* by definition the broadcast is also a multicast address */
>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>>  			pkt_type = BR_PKT_BROADCAST;
>> -			local_rcv = true;
>> +			if (br_opt_get(br, BROPT_BCAST_FLOOD))
>> +				local_rcv = true;
>>  		} else {
>>  			pkt_type = BR_PKT_MULTICAST;
>>  			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>> @@ -161,12 +162,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  			}
>>  			mcast_hit = true;
>>  		} else {
>> -			local_rcv = true;
>> -			br->dev->stats.multicast++;
>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD)) {
>> +				local_rcv = true;
>> +				br->dev->stats.multicast++;
>> +			}
>>  		}
>>  		break;
>>  	case BR_PKT_UNICAST:
>>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
>> +		if (!dst && br_opt_get(br, BROPT_UNICAST_FLOOD))
>> +			local_rcv = true;
>>  		break;
> 
> This adds new tests for all fast paths for host traffic,
> especially the port - port communication which is the most critical one.
> Please at least move the unicast test to the "else" block of "if (dst)" later.
> 
> The other tests can be moved to host only code too, but would require bigger changes.
> Please try to keep the impact on the fast-path at minimum.
> 
>>  	default:
>>  		break;
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index 18ccc3d5d296..683bd0ee4c64 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -449,6 +449,9 @@ enum net_bridge_opts {
>>  	BROPT_VLAN_BRIDGE_BINDING,
>>  	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
>>  	BROPT_MST_ENABLED,
>> +	BROPT_UNICAST_FLOOD,
>> +	BROPT_MCAST_FLOOD,
>> +	BROPT_BCAST_FLOOD,
>>  };
>>  
>>  struct net_bridge {
> 

