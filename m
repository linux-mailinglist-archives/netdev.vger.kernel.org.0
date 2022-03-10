Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E294D4DD7
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbiCJP6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238682AbiCJP6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:58:31 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F42A26F8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 07:57:26 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id r7so10221068lfc.4
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 07:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/3Y7SdvtHwEXMZpktqa2soQUFfSCdXW3oRVPXSTvSbE=;
        b=tSpqQw0bwEGHuAanvQKc5+pflShk4r3gq7B+rHffAcSv/JOK4oV94jG4z+j5vImUgu
         yGXSE5E7P2FCs8jftQW0PEl2V2K72yXlkTF8p0lbN64Yc3tRXaLgDrNk4hXU6o81WvQf
         zMDojsPuHf78Ga6Ig5LITEb/idNmhedGptxc1RCTYU1iF80MEPx+Qg5uGOm1om98zTBN
         Ok2FIx/yuBhdiAElx+giJpDl8y279vJKucDKO/IWivpKqLFcVMZgIH0s5aPMA4vIoPj3
         vgEVuu3wMmmTuPOIB6uKw9sKZIPQku4cjeig+ngjdj1OWDQ2ztornt5QRvnc+mI5u7VC
         Cqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/3Y7SdvtHwEXMZpktqa2soQUFfSCdXW3oRVPXSTvSbE=;
        b=tYDIoTTD4ugCUgEZt4tANuvFHQjRE7UBmK7M3U3dpK+OGr8BMspK1Yx0aFOWeGU9UK
         82wa1g9g4+khG8u/4Y5UfQpgGxt4559n0MtibyMu06zNvIieZVtqCw+qoiu2X+RWjWGg
         WRH+bEDhHddeCuGIshHNaQltzIYXCDSYBRl3NIIaAigCIirYbtmuFe2d9CztRGvFw1tZ
         YSqvH5yMj76h91jPLkXzxwmFPIU4yjVFJvStR6kPkOa0D/ifWLMKzWhtzUz2cvsuUEW2
         TFDul8PVfVfGtm3JeFH1Z7fzRV3glHVBNRjuHpX4d4a8uKGH7UMB+X/jonr00mCKB03o
         1rhg==
X-Gm-Message-State: AOAM533taXOresW1klP0CWpO/s/P/kUqrcr4hIUwrjQvN3Y7q4CMTI+r
        tnCLWcCZoiWdF53hl4yWQ2CCuTvL1Ee2qa0QujI=
X-Google-Smtp-Source: ABdhPJyrGGFnP3gPCYapzqVJIAt8GXYaRjaqbFCFALzg7lkzWXuKdQPtl/3y98MZd1iij4I13Alkaw==
X-Received: by 2002:a05:6512:2608:b0:448:35c4:bc9f with SMTP id bt8-20020a056512260800b0044835c4bc9fmr3310862lfb.666.1646927844389;
        Thu, 10 Mar 2022 07:57:24 -0800 (PST)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id j18-20020a2e8512000000b0024801df115asm1097416lji.109.2022.03.10.07.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:57:24 -0800 (PST)
Message-ID: <e3f57a64-4823-7cf3-0345-3777c44c2fe4@blackwall.org>
Date:   Thu, 10 Mar 2022 17:57:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 1/3] net: bridge: add fdb flag to extent locked
 port feature
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
 <0eeaf59f-e7eb-7439-3c0a-17e7ac6741f0@blackwall.org>
 <86v8wles1g.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <86v8wles1g.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 17:38, Hans Schultz wrote:
> On tor, mar 10, 2022 at 16:42, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 10/03/2022 16:23, Hans Schultz wrote:
>>> Add an intermediate state for clients behind a locked port to allow for
>>> possible opening of the port for said clients. This feature corresponds
>>> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
>>> latter defined by Cisco.
>>>
>>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>>> ---
>>>    include/uapi/linux/neighbour.h |  1 +
>>>    net/bridge/br_fdb.c            |  6 ++++++
>>>    net/bridge/br_input.c          | 11 ++++++++++-
>>>    net/bridge/br_private.h        |  3 ++-
>>>    4 files changed, 19 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
>>> index db05fb55055e..83115a592d58 100644
>>> --- a/include/uapi/linux/neighbour.h
>>> +++ b/include/uapi/linux/neighbour.h
>>> @@ -208,6 +208,7 @@ enum {
>>>    	NFEA_UNSPEC,
>>>    	NFEA_ACTIVITY_NOTIFY,
>>>    	NFEA_DONT_REFRESH,
>>> +	NFEA_LOCKED,
>>>    	__NFEA_MAX
>>>    };
>>
>> Hmm, can you use NDA_FLAGS_EXT instead ?
>> That should simplify things and reduce the nl size.
>>
> 
> I am using NDA_FDB_EXT_ATTRS. NFEA_LOCKED is just the
> flag as the other flags section is full wrt the normal flags, but maybe it
> doesn't fit in that section?
> 

Actually wait a second, this is completely wrong use of NDA_FDB_EXT_ATTRS.
That is a nested attribute, so the code below is wrong. More below..

> I will just note that iproute2 support for parsing nested attributes
> does not work, thus the BR_FDB_NOTIFY section (lines 150-165) are
> obsolete with respect to iproute2 as it is now. I cannot rule out that
> someone has some other tool that can handle this BR_FDB_NOTIFY, but I
> could not make iproute2 as it stands handle nested attributes. And of
> course there is no handling of NDA_FDB_EXT_ATTRS in iproute2 now.
> >>>    #define NFEA_MAX (__NFEA_MAX - 1)
>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>> index 6ccda68bd473..396dcf3084cf 100644
>>> --- a/net/bridge/br_fdb.c
>>> +++ b/net/bridge/br_fdb.c
>>> @@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>>>    	struct nda_cacheinfo ci;
>>>    	struct nlmsghdr *nlh;
>>>    	struct ndmsg *ndm;
>>> +	u8 ext_flags = 0;
>>>    
>>>    	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>>>    	if (nlh == NULL)
>>> @@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>>>    		ndm->ndm_flags |= NTF_EXT_LEARNED;
>>>    	if (test_bit(BR_FDB_STICKY, &fdb->flags))
>>>    		ndm->ndm_flags |= NTF_STICKY;
>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
>>> +		ext_flags |= 1 << NFEA_LOCKED;
>>>    
>>>    	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
>>>    		goto nla_put_failure;
>>>    	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
>>>    		goto nla_put_failure;
>>> +	if (nla_put_u8(skb, NDA_FDB_EXT_ATTRS, ext_flags))
>>> +		goto nla_put_failure;
>>> +

This is wrong. NDA_FDB_EXT_ATTRS is a nested attribute, you can't use it as a u8.
You need to have this structure:
  [ NDA_FDB_EXT_ATTRS ]
   ` [ NFEA_LOCKED ]

But that's why I asked if you could use the NDA_FLAGS_EXT attribute. You can see
the logic from the neigh code.

Also note that you need to account for the new attribute's size in fdb_nlmsg_size().


>>>    	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
>>>    	ci.ndm_confirmed = 0;
>>>    	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>> index e0c13fcc50ed..897908484b18 100644
>>> --- a/net/bridge/br_input.c
>>> +++ b/net/bridge/br_input.c
>>> @@ -75,6 +75,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>    	struct net_bridge_mcast *brmctx;
>>>    	struct net_bridge_vlan *vlan;
>>>    	struct net_bridge *br;
>>> +	unsigned long flags = 0;
>>
>> Please move this below...
>>
>>>    	u16 vid = 0;
>>>    	u8 state;
>>>    
>>> @@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>    			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>>>    
>>>    		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
>>> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
>>> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
>>> +			if (!fdb_src) {
>>
>> ... here where it's only used.
>>
> 
> Forgot that one. Shall do!
> 
>>> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
>>> +				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
>>> +			}
>>>    			goto drop;
>>> +		} else {
>>> +			if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags))
>>> +				goto drop;
>>> +		}
>>>    	}
>>>    
>>>    	nbp_switchdev_frame_mark(p, skb);
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index 48bc61ebc211..f5a0b68c4857 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -248,7 +248,8 @@ enum {
>>>    	BR_FDB_ADDED_BY_EXT_LEARN,
>>>    	BR_FDB_OFFLOADED,
>>>    	BR_FDB_NOTIFY,
>>> -	BR_FDB_NOTIFY_INACTIVE
>>> +	BR_FDB_NOTIFY_INACTIVE,
>>> +	BR_FDB_ENTRY_LOCKED,
>>>    };
>>>    
>>>    struct net_bridge_fdb_key {

