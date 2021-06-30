Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7436C3B8504
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 16:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhF3O1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 10:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhF3O1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 10:27:38 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59644C061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 07:25:08 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 128-20020a4a11860000b029024b19a4d98eso669123ooc.5
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 07:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EF2/INPdayXeLBwSZpEd7pDb7bOGB7yn3DM4oKFU+OU=;
        b=vSgiI2jEqwgAvHIMm2wDsUWkJQznNB+1DvqdaNua9B7YKy1gngENkVkZGACkOzOhvm
         GfcH6i7ICR+RbhJ2Yfyzerx0HOqVS2MlrSteyiiLZsLdq8OmYwiTlSRc8bcFmtpA3OST
         aZhinh8H4XSACmIgi3pR6e/DIB/1BNR6+IN05zIydXh1cukTrRAuW8VHv+gLYTLx7h+w
         MqSxuDT5NpeD23uHRB3umitDjeuvy0NCuHXt0RrJNGkT1+iupLXynzRiQzSFvA7nY2OS
         5C80KbMC9/p28Nv24mDMCgkBuuv/chBVyBO0zjcMmzIyZdlj7NnVSNQ0K7JJGkkp11bB
         czSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EF2/INPdayXeLBwSZpEd7pDb7bOGB7yn3DM4oKFU+OU=;
        b=CkJPy/OkDWwxU29cJILd3hTGKUnKJr51VlYxPAMl0aBGbDMRir9LyaCgMZQkClLXva
         UBssQ/tZXWvuDWM9KDxOvf2B7CsQzyKz6nSf6HL5/sUyCAziLDNJqecp0e9e8mH9s2BJ
         klbQQnysW9rnJNPaTDcGut1MVpF/JLU1z3hGSn/YDb9mXvva0V45ZliAhedcL+S9fv1j
         cEGxce0ejm85L8ctwRerGyRRk05LUw9u0fb6VK2D/uOkTarvrgtioiJ5cRLBY1e4uF+L
         uxtzst+2MGOaN0HL2MOkTueWZ5iDPGe5B4fdXi7v6jCcdYDYFqgDCO2YFgAysfMUJCLG
         8zyA==
X-Gm-Message-State: AOAM531DxsvLRqEsdBHfPkXwncdTcm3gU3gkKwVdgAepgd4rhYYIR6pG
        cXxNac4KGbNgOPGaZQDyVek=
X-Google-Smtp-Source: ABdhPJxmAfsAop38YpPt2SiSr/zBvy4i2otBSX/UvZpS8ehm2kdzmPo6Z7HlhfLvUEIqBzyQiBQkRQ==
X-Received: by 2002:a4a:6c0c:: with SMTP id q12mr8631919ooc.81.1625063107453;
        Wed, 30 Jun 2021 07:25:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o26sm519511oic.12.2021.06.30.07.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 07:25:06 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Add sysctl for RA default route table
 number
To:     antony.antony@secunet.com
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Christian Perle <christian.perle@secunet.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
 <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
 <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
 <20210629125316.GA18078@moon.secunet.de>
 <69e7e4e5-4219-5149-e7aa-fd26aa62260e@gmail.com>
 <b7e41f4b-04d6-2cff-038b-ccb250c2eb84@gmail.com>
 <20210630053448.GA24708@moon.secunet.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bd21f382-c9f4-23cd-3775-3531774d58a8@gmail.com>
Date:   Wed, 30 Jun 2021 08:25:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630053448.GA24708@moon.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/21 11:34 PM, Antony Antony wrote:
> On Tue, Jun 29, 2021 at 09:34:22 -0600, David Ahern wrote:
>> On 6/29/21 8:05 AM, Eyal Birger wrote:
>>> Hi Antony,
>>>
>>> On 29/06/2021 15:53, Antony Antony wrote:
>>>> Hi David,
>>>>
>>>> On Fri, Jun 25, 2021 at 22:47:41 -0600, David Ahern wrote:
>>>>> On 6/25/21 1:04 AM, Antony Antony wrote:
>>>>>> From: Christian Perle <christian.perle@secunet.com>
>>>>>>
>>>>>> Default routes learned from router advertisements(RA) are always placed
>>>>>> in main routing table. For policy based routing setups one may
>>>>>> want a different table for default routes. This commit adds a sysctl
>>>>>> to make table number for RA default routes configurable.
>>>>>>
>>>>>> examples:
>>>>>> sysctl net.ipv6.route.defrtr_table
>>>>>> sysctl -w net.ipv6.route.defrtr_table=42
>>>>>> ip -6 route show table 42
>>>>>
>>>>> How are the routing tables managed? If the netdevs are connected to a
>>>>> VRF this just works.
> 
> Ah! I figured it out what you were hinting at! Sorry, I didn't know about
> IFLA_VRF_TABLE attribute of link type vrf.
> 
> I also found the Documentation/networking/vrf.rst and red the commits
> including the iproute2 commits. Thanks for the hint.
> 
> It looks like the vrf->tb_id is used for both v4 and v6 routing?
> We are only looking at V6 routing, because the table only have v6 routes.

That's fine. There is no requirement to use both.

> 
>>>>
>>>> The main routing table has no default route. Our scripts add routing
>>>> rules
>>>> based on interfaces. These rules use the specific routing table where
>>
>> That's the VRF use case -- routing rules based on interfaces. Connect
>> those devices to VRFs and the RA does the right thing.
>>
>>>> the RA
>>>> (when using SLAAC) installs the default route. The rest just works.
>>>
>>> Could this be a devconf property instead of a global property? seems
> 
> yes adding to ipv6_devconf.cnf.ra_defrtr_tble is interesting.
> 
> I may propose a general solution that can replaces 
> vrf_fib_table(retrun vrf->tb_id).

no. You missed my point. No change is needed to VRF at all. No change is
needed for this use case at all if you simply:

ip link add VRF type vrf table TABLE
ip link set VRF up
ip link set dev <RA DEV> vrf VRF

You are good. RAs are processed and added to TABLE.

your proposed change is not needed.
