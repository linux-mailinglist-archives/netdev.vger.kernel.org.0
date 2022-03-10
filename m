Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CCC4D4E6D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiCJQPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241066AbiCJQPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:15:07 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCD81903C2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:14:05 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id 25so8420801ljv.10
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fjY0FTO8qXUt2RMKc1hm3MNTHQeOrTba2M9H2IVVHik=;
        b=Oy3ccJoMPxQacrScaiK5fjgNyTCksoNYehSN8a7xTkU4LrdocSYlSjj+qQec4GbJq2
         2gnjo5J3ep0KULECDMqgiiGz6BW8yy7Ae53z+AKZI0VW27wxBvObFjXYvCXJOTgwb6Y0
         7oMPy7D47EOU/K1KqgD0wZWyVLkW8n+9UP96pczOnIDyVx0zBcc6SQMYR9ii1kd3vtoi
         wkHgltU8G0C50AmhYNn07Oqt/wF7rbWbZ+kYnwQHSSmQtZdfL5EuwgQi5y7F0pOGlP9K
         yQZNTU4E/K7ejs2geW0sxErlcVDtXi6JYTKQiPWX51r9boP86/hCq92CaRMVOlgoDYIY
         mfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fjY0FTO8qXUt2RMKc1hm3MNTHQeOrTba2M9H2IVVHik=;
        b=XFR706cQNsH1Thf90vHAHWTA78WRe4c8dvoIWMWKsu4ycNetxjO9tLOCRYaFjnHnK5
         PdUbU7y+Y+3QCEgfAuU14b4dQM9n5Sh8bGJSJ0r+MJg0Ez1jSXr/a9yc7w5a37Q+ruoC
         n9TVlrAW9ZBxMQ/It4alpas8QGUQTr17Yt4Z0pF/m+Hq9UW0L7zPFwI2qD9jcrIn/Bmk
         xltd6hmLhQSPw0M/CwmCqJRHZYdZQ9lXEvIN1AlURCwDEWRYdbJikJ285hFUxedNykSr
         Pir5tFgWanMznHkcL/avhI7fR3Qg62Poh2iN2NwOYg2hKOJDh5KvwaAejLnHcEn143xh
         yjnw==
X-Gm-Message-State: AOAM530CoZB8PYiwnqdG+CMR/yWOdo5RUpUvoR8fjyeMGzM4VDqsDqhX
        6bl9SiQiXFKYvjMu+uNb880C2g==
X-Google-Smtp-Source: ABdhPJxN53SGZK0v5U0SWyuDAcWgAXOXIqu2WNeZ9jnUL2HHsw4HNbhNJsR1vUlQ4A0+6xVh+GoizA==
X-Received: by 2002:a2e:93cf:0:b0:247:e451:7175 with SMTP id p15-20020a2e93cf000000b00247e4517175mr3506629ljh.441.1646928843584;
        Thu, 10 Mar 2022 08:14:03 -0800 (PST)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id m22-20020a2e7116000000b0024805a43db1sm870556ljc.63.2022.03.10.08.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:14:03 -0800 (PST)
Message-ID: <dc47275b-27f8-5de0-ae6e-e82013a03d1f@blackwall.org>
Date:   Thu, 10 Mar 2022 18:14:01 +0200
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
 <e3f57a64-4823-7cf3-0345-3777c44c2fe4@blackwall.org>
 <8635jp23ez.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <8635jp23ez.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 18:11, Hans Schultz wrote:
> On tor, mar 10, 2022 at 17:57, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 10/03/2022 17:38, Hans Schultz wrote:
>>> On tor, mar 10, 2022 at 16:42, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>>> On 10/03/2022 16:23, Hans Schultz wrote:
>>>>> Add an intermediate state for clients behind a locked port to allow for
>>>>> possible opening of the port for said clients. This feature corresponds
>>>>> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
>>>>> latter defined by Cisco.
>>>>>
>>>>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>>>>> ---
>>>>>     include/uapi/linux/neighbour.h |  1 +
>>>>>     net/bridge/br_fdb.c            |  6 ++++++
>>>>>     net/bridge/br_input.c          | 11 ++++++++++-
>>>>>     net/bridge/br_private.h        |  3 ++-
>>>>>     4 files changed, 19 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
>>>>> index db05fb55055e..83115a592d58 100644
>>>>> --- a/include/uapi/linux/neighbour.h
>>>>> +++ b/include/uapi/linux/neighbour.h
>>>>> @@ -208,6 +208,7 @@ enum {
>>>>>     	NFEA_UNSPEC,
>>>>>     	NFEA_ACTIVITY_NOTIFY,
>>>>>     	NFEA_DONT_REFRESH,
>>>>> +	NFEA_LOCKED,
>>>>>     	__NFEA_MAX
>>>>>     };
>>>>
>>>> Hmm, can you use NDA_FLAGS_EXT instead ?
>>>> That should simplify things and reduce the nl size.
>>>>
>>>
>>> I am using NDA_FDB_EXT_ATTRS. NFEA_LOCKED is just the
>>> flag as the other flags section is full wrt the normal flags, but maybe it
>>> doesn't fit in that section?
>>>
>>
>> Actually wait a second, this is completely wrong use of NDA_FDB_EXT_ATTRS.
>> That is a nested attribute, so the code below is wrong. More below..
>>
>>> I will just note that iproute2 support for parsing nested attributes
>>> does not work, thus the BR_FDB_NOTIFY section (lines 150-165) are
>>> obsolete with respect to iproute2 as it is now. I cannot rule out that
>>> someone has some other tool that can handle this BR_FDB_NOTIFY, but I
>>> could not make iproute2 as it stands handle nested attributes. And of
>>> course there is no handling of NDA_FDB_EXT_ATTRS in iproute2 now.
>>>>>>     #define NFEA_MAX (__NFEA_MAX - 1)
>>>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>>>> index 6ccda68bd473..396dcf3084cf 100644
>>>>> --- a/net/bridge/br_fdb.c
>>>>> +++ b/net/bridge/br_fdb.c
>>>>> @@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>>>>>     	struct nda_cacheinfo ci;
>>>>>     	struct nlmsghdr *nlh;
>>>>>     	struct ndmsg *ndm;
>>>>> +	u8 ext_flags = 0;
>>>>>     
>>>>>     	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>>>>>     	if (nlh == NULL)
>>>>> @@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>>>>>     		ndm->ndm_flags |= NTF_EXT_LEARNED;
>>>>>     	if (test_bit(BR_FDB_STICKY, &fdb->flags))
>>>>>     		ndm->ndm_flags |= NTF_STICKY;
>>>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
>>>>> +		ext_flags |= 1 << NFEA_LOCKED;
>>>>>     
>>>>>     	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
>>>>>     		goto nla_put_failure;
>>>>>     	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
>>>>>     		goto nla_put_failure;
>>>>> +	if (nla_put_u8(skb, NDA_FDB_EXT_ATTRS, ext_flags))
>>>>> +		goto nla_put_failure;
>>>>> +
>>
>> This is wrong. NDA_FDB_EXT_ATTRS is a nested attribute, you can't use it as a u8.
>> You need to have this structure:
>>    [ NDA_FDB_EXT_ATTRS ]
>>     ` [ NFEA_LOCKED ]
>>
>> But that's why I asked if you could use the NDA_FLAGS_EXT attribute. You can see
>> the logic from the neigh code.
> 
> Ahh yes, NDA_FLAGS_EXT was not there in the 5.15.x kernel I have
> originally being making the patches in.
> 
> I hope that the handling of nested attributes has been fixed in
> iproute2. ;-)
> 

It hasn't been broken, I'm guessing you're having issues with the nested bit being set.
Check NLA_F_NESTED and NLA_TYPE_MASK.

>>
>> Also note that you need to account for the new attribute's size in fdb_nlmsg_size().
>>
>>
>>>>>     	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
>>>>>     	ci.ndm_confirmed = 0;
>>>>>     	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
>>>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>>>> index e0c13fcc50ed..897908484b18 100644
>>>>> --- a/net/bridge/br_input.c
>>>>> +++ b/net/bridge/br_input.c
>>>>> @@ -75,6 +75,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>>>     	struct net_bridge_mcast *brmctx;
>>>>>     	struct net_bridge_vlan *vlan;
>>>>>     	struct net_bridge *br;
>>>>> +	unsigned long flags = 0;
>>>>
>>>> Please move this below...
>>>>
>>>>>     	u16 vid = 0;
>>>>>     	u8 state;
>>>>>     
>>>>> @@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>>>     			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>>>>>     
>>>>>     		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
>>>>> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
>>>>> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
>>>>> +			if (!fdb_src) {
>>>>
>>>> ... here where it's only used.
>>>>
>>>
>>> Forgot that one. Shall do!
>>>
>>>>> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
>>>>> +				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
>>>>> +			}
>>>>>     			goto drop;
>>>>> +		} else {
>>>>> +			if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags))
>>>>> +				goto drop;
>>>>> +		}
>>>>>     	}
>>>>>     
>>>>>     	nbp_switchdev_frame_mark(p, skb);
>>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>>> index 48bc61ebc211..f5a0b68c4857 100644
>>>>> --- a/net/bridge/br_private.h
>>>>> +++ b/net/bridge/br_private.h
>>>>> @@ -248,7 +248,8 @@ enum {
>>>>>     	BR_FDB_ADDED_BY_EXT_LEARN,
>>>>>     	BR_FDB_OFFLOADED,
>>>>>     	BR_FDB_NOTIFY,
>>>>> -	BR_FDB_NOTIFY_INACTIVE
>>>>> +	BR_FDB_NOTIFY_INACTIVE,
>>>>> +	BR_FDB_ENTRY_LOCKED,
>>>>>     };
>>>>>     
>>>>>     struct net_bridge_fdb_key {

