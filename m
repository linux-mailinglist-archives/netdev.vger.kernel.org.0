Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018623FE73B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 03:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhIBBju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 21:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhIBBjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 21:39:48 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E1AC061575;
        Wed,  1 Sep 2021 18:38:51 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id s15so253121qta.10;
        Wed, 01 Sep 2021 18:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7nAENFB0y/kRriAUvRNpaGEX8ldJmWnzKenc0y0ORe8=;
        b=KUsCx0axO9WcBtdnEYK3qA9ZMGt5L/sovPB1OxwqXklJSaLtcD40qhWGDEexww6h+y
         y64pl+BBxPXuNo5b5m7hNYQNqMbdOiwoxNIyzVTyRd2Cb+NJ9HK4FjgYG1w7cxSZNlHU
         ED2Ws/LoQ1OwgfnR2VPzAGJ/fPSHd083dQSZxhdD3yhiS98tg2/g9LOtm2vWOZqYB61o
         3lDEQyAXT8XiOzTXlarHchsZZhit8gXKZ7LxAJp4lJjxsv0mxTgJbxk8Z1fPiyGrlGim
         KlcRaFBwReAmGi+XA3zAKrO3XgIn5+Afid/bfyN/iyR+aEQf4fg3C+m6V4iPXT23dffq
         E4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7nAENFB0y/kRriAUvRNpaGEX8ldJmWnzKenc0y0ORe8=;
        b=ejhW3kWSPmBC9t65QedV0u2pArCJVVwFUi6Fx756EfNK2mfVfTg44VWNL8rnCO1BIC
         mI4Cm10WEzPmhsxfioA8EZ763ud6NWQ7OX9VYb8ftKSCZO/PC8OAV4/12pyFEGMcu4Ve
         NL3g+u+kIsd1lV0LrNFYh9VClcQYalK6dS2+WI0KELzR4I3dUbV9nKajS00VyUMizxdK
         7fOl78k7BnuFA+lWZqk9EU2CgIFKDYeZek519bWl4EiOihgneqdg96KebkbzwO24iA+V
         KyVJeVIzYg7Nt+AlQh50tCH695sU+XJG7CzND+DPyBJ8uM+cuQf/5oNq3wkxb8c+DDua
         HcHw==
X-Gm-Message-State: AOAM531iKTCpVm1BGIL6PsZibhXKEAFgvR+pGsEdnidV65KEctAWHC13
        aQif2ySC+MDGn525dRuT91SAwtIDhYc=
X-Google-Smtp-Source: ABdhPJztSbArmmGjpgpTi8cgfqX932ADJnfAzpJxdGctNzyWsUB7fW5NKNETCe8U7lDibHJiKCR1hQ==
X-Received: by 2002:ac8:4618:: with SMTP id p24mr736600qtn.205.1630546730331;
        Wed, 01 Sep 2021 18:38:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:1456:dc25:4026:460e? ([2600:1700:dfe0:49f0:1456:dc25:4026:460e])
        by smtp.gmail.com with ESMTPSA id v5sm362941qkh.39.2021.09.01.18.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 18:38:49 -0700 (PDT)
Message-ID: <6411c7dd-79b4-3659-020b-aaa929447d50@gmail.com>
Date:   Wed, 1 Sep 2021 18:38:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net 2/2] net: dsa: b53: Set correct number of ports in the
 DSA struct
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        stable@vger.kernel.org
References: <20210901092141.6451-1-zajec5@gmail.com>
 <20210901092141.6451-2-zajec5@gmail.com>
 <ba35e7b8-4f90-9870-3e9e-f8666f5ebd0f@gmail.com>
 <20210901163657.74f39079@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901163657.74f39079@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2021 4:36 PM, Jakub Kicinski wrote:
> On Wed, 1 Sep 2021 10:21:55 -0700 Florian Fainelli wrote:
>> On 9/1/2021 2:21 AM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> Setting DSA_MAX_PORTS caused DSA to call b53 callbacks (e.g.
>>> b53_disable_port() during dsa_register_switch()) for invalid
>>> (non-existent) ports. That made b53 modify unrelated registers and is
>>> one of reasons for a broken BCM5301x support.
>>>
>>> This problem exists for years but DSA_MAX_PORTS usage has changed few
>>> times so it's hard to specify a single commit this change fixes.
>>
>> You should still try to identify the relevant tags that this is fixing
>> such that this gets back ported to the appropriate trees. We could use
>> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper"), to
>> minimize the amount of work doing the back port.
> 
> To be clear are you okay with the fixes tag you provided or should we
> wait for Rafał to double check?

That Fixes tag is correct and won't cause conflicts AFAICT with 
backports all the way down to that commit.
-- 
Florian
