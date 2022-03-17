Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6A4DC4E9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiCQLkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiCQLkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:40:32 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1CD1D2072
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:39:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p6so1316916lfh.1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CspD6izgTH6A2XQ9nASG0MR1MpbAkozl4tcRY/MSX4w=;
        b=nUM0kw07vR7VwjlxVnvygwf4OTDgc69v01U6eZPYh0aA/Hm2/yJNgtP8f/dThKPpb1
         NJE+wzg6XSDa0tlt6YRBiuv2yW1/8CH/kni4IoINkTgjgdgpnOblofjiIjYNMY0Lhmjp
         77NxT8aYCtwkA2/z0/rzsAqifqmfgY78Zk8boPbCdGQInqN8JOgA1wS8kgiPM+ko6fqm
         T4l33iu8WgPCaxh9KJFwdkcioC8qg/tLvfLJ5Etvn/oD1u0gpWQAUMIuep2TfPgZfNUo
         6TBH8jypuibmUDNg00mphk8Ix/sld09Wfx6948w55kgpAqKg7wxmv93JyRc1w7cnAVGv
         Pvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CspD6izgTH6A2XQ9nASG0MR1MpbAkozl4tcRY/MSX4w=;
        b=Coz6EHDY3f6MHuKmxE6Bk8Y8rAeP5gwTLRA/qLFhIvaqPYBGp5j5WNKYM8QVsrh7Cr
         wzLGylFgiBRhDcF2Ac0QA6lu/uMdXqVCi7VLwZbxToD/csrjnRvUTqefJyJMEBijZkrf
         TVTx/4YX7kS+MeQmTY6Ue/2hE8oSc6leq0gtSd+ATnvXqcPTXuckJyk0Ruzu/NyexdQY
         6F/vKKMUhBCi9HG7w8KsSsqi3wbO7Wsx3vNFxne+uP+TxInc7OfSRpvri4ancaxNgK6M
         LhelbfyULkMzjOo7qKxzDs67SOsQup4/MbL0JvK8JrcXCXLM+lXuUtJvTTSjyHCZkpIF
         OTFA==
X-Gm-Message-State: AOAM5306dZ0hiKIPxNBjq6EBGljpOkZKTsHFQ4aeoTndL4lV/iSR0Pr2
        DjzGVmtxGU8dTh09M2U5An4=
X-Google-Smtp-Source: ABdhPJymCmCi5aX5IOClH9dR5q3/FS7Gp8no6f6P36Ef3J0/05KVvs8MKJgOLTwGr2znkOAaTRv41Q==
X-Received: by 2002:ac2:4e0b:0:b0:448:7bb1:a5a4 with SMTP id e11-20020ac24e0b000000b004487bb1a5a4mr2516305lfr.405.1647517154100;
        Thu, 17 Mar 2022 04:39:14 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id q26-20020ac24a7a000000b004437f641a32sm427699lfp.15.2022.03.17.04.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 04:39:13 -0700 (PDT)
Message-ID: <50f4e8b0-4eea-d202-383b-bf2c2824322d@gmail.com>
Date:   Thu, 17 Mar 2022 12:39:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <87r1717xrz.fsf@gmail.com>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <87r1717xrz.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-17 10:07, Joachim Wiberg wrote:
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
> 
>> [snip]
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

The original flag was name was local_receive to separate it from being
mistaken for the flood unknown flags. However the comment I've got was
to align it with the existing (port) flags. These flags have nothing to do with
the port flood unknown flags. Imagine the setup below:

           vlan1
             |
            br0             br1
           /   \           /   \
         swp1 swp2       swp3 swp4

We want to have swp1/2 as member of a normal vlan filtering bridge br0 /w learning on. 
On br1 we want to just forward packets between swp3/4 and disable learning. 
Additional we don't want this traffic to impact the CPU. 
If we disable learning on swp3/4 all traffic will be unknown and if we also 
have flood unknown on the CPU-port because of requirements for br0 it will
impact the traffic to br1. Thus we want to restrict traffic between swp3/4<->CPU port
with the help of the PVT.

/Mattias
