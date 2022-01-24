Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311CF4985A2
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244058AbiAXRBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243970AbiAXRBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:01:35 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AC2C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:01:35 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 128so16550875pfe.12
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fmvrfR7KmaVgB5jsuEQuD7iS1yxFAbsqLPxbN2md/ps=;
        b=IyZE+Xe4X3Wr21TM0Equ9OehBLX3QMhm6xeH9z98sD3JfB1r22oVVCcZy3PqYYaE/y
         7VtSJg3xqDw3B7EkU7SoZ9Nc/c6IuYl+F+ONYXpiKPBvxzUCtsy7rlD8ZW1rxJ0mmA24
         UwLQWxI1ZOZ6+Q5XM+C8Z5AD7QWIpQ5cAdd16tTqrL7p/Pzb/VRIwCxwINVv8lLZ8XDF
         oyKWb1Kk5DVKb7xmLoYMjhCPU544tv9S6GJ9qg/LbtHJUrXpfaG0cGTM8TkqM03ZhbAR
         r4nzaM0YLakj7zYEcUpatD6nucz93n1N+MU8IaG2/1XW3D2qn4uUOXiUcivgyk+MeObS
         dKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fmvrfR7KmaVgB5jsuEQuD7iS1yxFAbsqLPxbN2md/ps=;
        b=HJGzc81Fd3B+E9tmXmve4Qb99tuFyp8o7RgDSwOT9Eq1v/mTwfWbRqhsWr6ZcTLysc
         VWgUYh5LU9jNBtgvAZGAokMjbpgtl038dt7AoF7DcRYdUqJ6azxG18isW75DIOQzEzZC
         JeRF2tFB4xrz8GCUsCyO1RGhHjVuGZRnXWfjNFiBtbQP+U8+kRy4MwepMzy5Z+RvQT5u
         ReIQZz8eWODdApTI4p8XcuJUI6T/s0K+/d1uDdS5scVwNmc+liyxv6Ygnx77uB4F8O9I
         GM1qiNoT3qMPBOBh+nJPuTEd/HOXXlN/XFTZQ7hcDhs7lLIvG361DX5YGPuam4y5JYfN
         JnXQ==
X-Gm-Message-State: AOAM530TdXRljd488V60udSGskIvrALwhMKevENGmZVgzROa98giq3yB
        yEERxPKlrR9HppABsyV1qU9VUJUdl9o=
X-Google-Smtp-Source: ABdhPJwzaePVpg0ifNMIQGhFRnmv0et/oN/KiKA4nwYBThLrHdO+MCEisqvlAiLb2o2wodtoag/pAQ==
X-Received: by 2002:a05:6a00:10cd:b0:4bc:a950:41e2 with SMTP id d13-20020a056a0010cd00b004bca95041e2mr15093415pfu.30.1643043694404;
        Mon, 24 Jan 2022 09:01:34 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d20sm3290897pfv.74.2022.01.24.09.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:01:33 -0800 (PST)
Message-ID: <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
Date:   Mon, 24 Jan 2022 09:01:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
References: <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
 <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
 <20220124153147.agpxxune53crfawy@skbuf>
 <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220124165535.tksp4aayeaww7mbf@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2022 8:55 AM, Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 08:46:49AM -0800, Jakub Kicinski wrote:
>> I thought for drivers setting the legacy NETIF_F_IP*_CSUM feature
>> it's driver's responsibility to validate the geometry of the packet
>> will work with the parser the device has. Or at least I think that's
>> what Tom was pushing for when he was cleaning up the checksumming last
>> (and wrote the long comment on the subject in skbuff.h).
> 
> Sorry Jakub, I don't understand what you mean to say when applied to the
> context discussed here?

I believe what Jakub meant to say is that if a DSA conduit device driver 
advertises any of the NETIF_F_IP*_CSUM feature bits, then the driver's 
transmit path has the responsibility of checking that the payload being 
transmitted has a chance of being checksummed properly by the hardware. 
The problem here is not so much the geometry itself (linear or not, 
number/size of fragments, etc.) as much as the placement of the L2/L3 
headers usually.

DSA conduit network device drivers do not have the ability today to 
determine what type of DSA tagging is being applied onto the DSA master 
but they do know whether DSA tagging is in use or not which may be 
enough to be overly compatible.

It is not clear to me whether we can solve this generically within the 
DSA framework or even if this is desirable, but once we have identified 
a problematic association of DSA tagger and DSA conduit, we can always 
have the DSA conduit driver do something like:

if (netdev_uses_dsa(dev))
	skb_checksum_help()

or have a fix_features callback which does reject the enabling of 
NETIF_F_IP*_CSUM if netdev_uses_dsa() becomes true.
-- 
Florian
