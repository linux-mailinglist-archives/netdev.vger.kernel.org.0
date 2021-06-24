Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403063B244A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 02:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFXAjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 20:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFXAja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 20:39:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3F4C061574;
        Wed, 23 Jun 2021 17:37:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so2402761pjn.1;
        Wed, 23 Jun 2021 17:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eqh+49vXDZS6SaYXY+bpU/7GeTuaaMqXxbB85C2tCPE=;
        b=B6NW8IjUsI+6Grs3UDOUQN2s3b2c6hOgjNnz2iH41lh/FONk4yu7NsVzIP4SlaC4+7
         fy++BpZKP4nHWbat2E483Sioco3fXRsZWwVfQmor0Ur/UlVepiPn8Rpgj6hKIKEO7eFX
         HNxqk5PrqB9S5vofQQZ2zu9LOF4oYc+DlpaElfb5p4Ix5ccEYYP0V8nH7fAJOA/Yh8Yo
         enNYc1ERbsrXBn0jjq4orvTlbF7b0YSTx2dm0ljp1ENB0poRidVS7P7KQNvEnOsm86R8
         iUkO6ZMVlWZyuo72tpnGZh97fLRyPZrsNzkBMgc8kpGV5vnpigMoBzHLmEvNZOzLALdL
         zuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eqh+49vXDZS6SaYXY+bpU/7GeTuaaMqXxbB85C2tCPE=;
        b=FPMV/bFooe3RkbmArU8hRUYE4MFhoW0C2HRolklrjfX8AQ163gp0rcgcTn8z4Nj/vL
         LPuTXO42xdVNUyVNXuvDi233aTFmEsLWsy/6UO4EkSvO+rdZDxvQakH7XULQeXIZQC+z
         q+m0SMqHABV8kgygCsNESy8V6M9BjVwttz6gUMkW/je6CcxbFAsePXsbvxpPM0xFkpfC
         QWJBPHGZ/logj6nEB59RUyDJWU1ccIm86bTJzaCsH05F83zJ9IMdQhHsgpqNu89oA+2e
         rTWZPvjMwcKnqsLetgEVxY/0KSyyn/q8JH4YgcFueYxousW1OPKm/lqs8JFi4QBf7ojH
         iAkA==
X-Gm-Message-State: AOAM5322HUEHMhy3j33tnuJ2g4rQ6Sg7LxinmLYibuVtRWM4Eh8ZWrcz
        dadErlEdMnK77TAlhDjUP/29h4KEuyU=
X-Google-Smtp-Source: ABdhPJw4nS7VsA39W5qub6XK3PVjED0p7Wp7syo2iGsj4oLZwQi3paKmnCJw2F5Xv/CRVugdwxBC7A==
X-Received: by 2002:a17:90b:14d1:: with SMTP id jz17mr12083410pjb.45.1624495030610;
        Wed, 23 Jun 2021 17:37:10 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d189sm860002pfa.28.2021.06.23.17.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 17:37:10 -0700 (PDT)
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
To:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-2-lukma@denx.de> <YNH3mb9fyBjLf0fj@lunn.ch>
 <20210622225134.4811b88f@ktm> <YNM0Wz1wb4dnCg5/@lunn.ch>
 <20210623172631.0b547fcd@ktm>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
Date:   Wed, 23 Jun 2021 17:36:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623172631.0b547fcd@ktm>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/2021 8:26 AM, Lukasz Majewski wrote:
> Hi Andrew,
> 
>> On Tue, Jun 22, 2021 at 10:51:34PM +0200, Lukasz Majewski wrote:
>>> Hi Andrew,
>>>
>>>> On Tue, Jun 22, 2021 at 04:41:09PM +0200, Lukasz Majewski wrote:
>>>>> The 'eth_switch' node is now extendfed to enable support for L2
>>>>> switch.
>>>>>
>>>>> Moreover, the mac[01] nodes are defined as well and linked to
>>>>> the former with 'phy-handle' property.
>>>>
>>>> A phy-handle points to a phy, not a MAC! Don't abuse a well known
>>>> DT property like this.
>>>
>>> Ach.... You are right. I will change it.
>>>
>>> Probably 'ethernet' property or 'link' will fit better?
>>
>> You should first work on the overall architecture. I suspect you will
>> end up with something more like the DSA binding, and not have the FEC
>> nodes at all. Maybe the MDIO busses will appear under the switch?
>>
>> Please don't put minimal changes to the FEC driver has your first
>> goal. We want an architecture which is similar to other switchdev
>> drivers. Maybe look at drivers/net/ethernet/ti/cpsw_new.c.
> 
> I'm a bit confused - as I thought that with switchdev API I could just
> extend the current FEC driver to add bridge offload.
> This patch series shows that it is doable with little changes
> introduced.

Regardless of how you end up implementing the switching part in the 
driver, one thing that you can use is the same DT binding as what DSA 
uses as far as representing ports of the Ethernet controller. That means 
that ports should ideally be embedded into an 'ethernet-ports' container 
node, and you describe each port individually as sub-nodes and provide, 
when appropriate 'phy-handle' and 'phy-mode' properties to describe how 
the Ethernet PHYs are connected.

> 
> However, now it looks like I would need to replace FEC driver and
> rewrite it in a way similar to cpsw_new.c, so the switchdev could be
> used for both cases - with and without L2 switch offload.
> 
> This would be probably conceptually correct, but i.MX FEC driver has
> several issues to tackle:
> 
> - On some SoCs (vf610, imx287, etc.) the ENET-MAC ports don't have the
>    same capabilities (eth1 is a bit special)
> 
> - Without switch we need to use DMA0 and DMA1 in the "bypass" switch
>    mode (default). When switch is enabled we only use DMA0. The former
>    case is best fitted with FEC driver instantiation. The latter with
>    DSA or switchdev.
> 
>> The cpsw
>> driver has an interesting past, it did things the wrong way for a long
>> time, but the new switchdev driver has an architecture similar to what
>> the FEC driver could be like.
>>
>> 	Andrew
> 
> Maybe somebody from NXP can provide input to this discussion - for
> example to sched some light on FEC driver (near) future.

Seems like some folks at NXP are focusing on the STMMAC controller these 
days (dwmac from Synopsys), so maybe they have given up on having their 
own Ethernet MAC for lower end products.
-- 
Florian
