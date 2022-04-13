Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABBC4FF44A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiDMKA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiDMKA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:00:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE06056C3F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:58:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t25so1695128edt.9
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7IlJEeqz67e4BgaK1q7oc6ERKaCnmeI8P/BcvgrokkI=;
        b=ooT+CjoXZdgPcESE7Jc1b3YBjdsswHkx5Tmi51Oqd7+FsDR9lB8JGaoAajQOrr7p3o
         8QsRPgqj3qKsq+V9lvOnFIY+I3Euthc3c1cEtZwRADsu/59u92jSrOkqjKM3WPHfW0q5
         S3hPDStLD7yNkz0IY8PQ6T5auZ1Ee5mKxfObOBLeFekoEKIZk9qLsPq1rVLKShaGdXYX
         9+QNYbqavn+rYqNDM3eEbO9cQs5oPCJmA4czcEUHY45BClAshGKxntc0eYxImCOXj482
         m7+3swsSWxyYAGp4vyu6Lz40LGAmZ8NyLJXynD9CCmbesGz1b3YlSmvnkozfIrDYCJAK
         y51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7IlJEeqz67e4BgaK1q7oc6ERKaCnmeI8P/BcvgrokkI=;
        b=I/wt7Z2Q21cXedoIfiL1vaYbs7FVOWkwC5dQi42Qvu3iCLnz9LSTXLwQv+fvD/225Z
         DraacFDPZ7nAeoHx8XyQr1Us1PfxkZUIGmB9Ij/nc0033d4JC4yB2kZLoq10fTM2M9Jf
         L3YiUza7Jrerf21zx0yIWz8aovGK/S1W/cjr81SBxB2EvjzcRHJJXfZzhWDnKS3mnGgv
         cOlcD8YZZ4WaEg0jlVhDGX5Q42Rq7ptvqHOXIhhnnPtifClVjpNWxCiIANc3up0YFSrc
         RhrokB0xLv7Hah3ImffBhaLrVk35JbcUgPlGEtYPOMTYwaW1VGvVZ/ma1MKNqiSQjoyo
         QKLQ==
X-Gm-Message-State: AOAM532lLCL/0BUzmFjwz2lBAeXOY6txMttziQHEo22191t7GBQYBS0J
        ynJpumh4JBwV0gQcAgwIZ1FrkeCHT88FbmTk
X-Google-Smtp-Source: ABdhPJz2sM15Uy3RQWZZs4xFXBskoTPb/mywuXK3acvxqYbWRTuHEQekKbTxQ0dI66v0i/hyJwuABQ==
X-Received: by 2002:aa7:dacd:0:b0:41d:75df:62f with SMTP id x13-20020aa7dacd000000b0041d75df062fmr17725067eds.256.1649843913210;
        Wed, 13 Apr 2022 02:58:33 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id w6-20020a170906184600b006e8914a0a9fsm3481812eje.88.2022.04.13.02.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 02:58:32 -0700 (PDT)
Message-ID: <2cf8c40c-c122-24c0-1c01-b61da9830e9d@blackwall.org>
Date:   Wed, 13 Apr 2022 12:58:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 01/13] net: bridge: add control of bum
 flooding to bridge itself
Content-Language: en-US
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
 <87k0bt9uq9.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <87k0bt9uq9.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2022 12:51, Joachim Wiberg wrote:
> On Tue, Apr 12, 2022 at 21:27, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 11/04/2022 16:38, Joachim Wiberg wrote:
>>> @@ -526,6 +526,10 @@ void br_dev_setup(struct net_device *dev)
>>>  	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
>>>  	dev->max_mtu = ETH_MAX_MTU;
>>> +	br_opt_toggle(br, BROPT_UNICAST_FLOOD, 1);
>> This one must be false by default. It changes current default behaviour.
>> Unknown unicast is not currently passed up to the bridge if the port is
>> not in promisc mode, this will change it. You'll have to make it consistent
>> with promisc (e.g. one way would be for promisc always to enable unicast flood
>> and it won't be possible to be disabled while promisc).
> 
> Ouch, my bad!  Will look into how to let this have as little impact as
> possible.  I like your semantics there, promisc should always win.
> 
>>> +	br_opt_toggle(br, BROPT_MCAST_FLOOD, 1);
>>> +	br_opt_toggle(br, BROPT_BCAST_FLOOD, 1);
>>
>> s/1/true/ for consistency
> 
> Of course, thanks!
> 
>>> @@ -118,7 +118,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  		/* by definition the broadcast is also a multicast address */
>>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>>>  			pkt_type = BR_PKT_BROADCAST;
>>> -			local_rcv = true;
>>> +			if (br_opt_get(br, BROPT_BCAST_FLOOD))
>>> +				local_rcv = true;
>>>  		} else {
>>>  			pkt_type = BR_PKT_MULTICAST;
>>>  			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>>> @@ -161,12 +162,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  			}
>>>  			mcast_hit = true;
>>>  		} else {
>>> -			local_rcv = true;
>>> -			br->dev->stats.multicast++;
>>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD)) {
>>> +				local_rcv = true;
>>> +				br->dev->stats.multicast++;
>>> +			}
>>>  		}
>>>  		break;
>>>  	case BR_PKT_UNICAST:
>>>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
>>> +		if (!dst && br_opt_get(br, BROPT_UNICAST_FLOOD))
>>> +			local_rcv = true;
>>>  		break;
>>
>> This adds new tests for all fast paths for host traffic, especially
>> the port - port communication which is the most critical one.  Please
>> at least move the unicast test to the "else" block of "if (dst)"
>> later.
> 
> OK, will fix!
> 
>> The other tests can be moved to host only code too, but would require
>> bigger changes.  Please try to keep the impact on the fast-path at
>> minimum.
> 
> Interesting, you mean by speculatively setting local_rcv = true and
> postpone the decsion to br_pass_frame_up(), right?  Yeah that would
> indeed be a bit more work.

Yes, I was thinking maybe local_rcv can become an enum with an exact reason for the
local_rcv, so if it's > 0 do the local_rcv and br_pass_frame_up() then
can make a proper decision without passing all of the vars. I haven't tried it,
so not sure if it's feasible. :)
