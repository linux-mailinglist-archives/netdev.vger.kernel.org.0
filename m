Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E3A33FA95
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhCQVmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhCQVm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 17:42:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7959CC06174A;
        Wed, 17 Mar 2021 14:42:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t18so1829155pjs.3;
        Wed, 17 Mar 2021 14:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=44auvYUUIKCuBlG/Ha93OO2YDP539tvtlw8ITUUzMzo=;
        b=aCK6xxAIu5rG0ENNdO5fYXZLu/ZaImRKfqIeE1G+848dh0Z8YzTDT83F+LyuYj0LGR
         9MLUSQZzVxE7UsSVzr9Bf5sKVlX5ShWg8jV7GS9vns83+TvBQu79GWiNn5OxDECu81nS
         CHsGUi2Nw/6H0NjfdTWFk3QBKY9KcXRfjch357crjF6CZrjUPRuDG8JiM1HuGALrsoyp
         Z7izaL24xj0scQkyKtXnPxEn85sILNXVa2jbpAydcoufuNor9krIcD6ugBvmm1rSBR2T
         mjKWPMZf5m6pM3iQsTppmwyXVsYaqZzC60pEiRJPz9yIL6kM/F8Rz2xcyfYZ5SCJrQ2h
         /WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=44auvYUUIKCuBlG/Ha93OO2YDP539tvtlw8ITUUzMzo=;
        b=ZyydG9UaEK0KjsG8pH//NjXUqDI+kpC2QteokBvYnx46sqce5w63cyScrh1BTuYklD
         5P9245hSXPm3cbW9oMuWCpB3pU/arg3CB7PfodRoP6RbmmpwleFbJNwCrsx+xr6nXJx3
         rviPMABUwea04TNKTgZjJyqrF7zCRvyr6RpEld00Ep8VSCanD+IdxggUqYjLZVaBHlSH
         62Mm4TQUntCBynOq3on69VcDlQBbsiRC40nKoqAjsPk8piPv75bZnvfCgMhi0mlGbUdZ
         FrVasJqiL+hZT9cG6o3fqmEG7xl3hQ4yPRg7iaGmPbihBdVk/EoseTJEcATQxxw+jmkb
         fUkg==
X-Gm-Message-State: AOAM5338d1xVg5H44YZvaV+U+OiDUHiTUEv1iStRbSLTUbB4e1nx66bM
        li1AWtGKwgnsdRB4+xMkwEacsgjwT2s=
X-Google-Smtp-Source: ABdhPJy9hEpuOivND1Etai95q/eD9Q6CPXWmpcHhBWejSZz8MJkvsEUHucaXmGIq9Mb3b8jx9qL5Xg==
X-Received: by 2002:a17:903:1c3:b029:e6:a15:751f with SMTP id e3-20020a17090301c3b02900e60a15751fmr6464154plh.44.1616017346581;
        Wed, 17 Mar 2021 14:42:26 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20sm4228573pji.3.2021.03.17.14.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 14:42:26 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-3-noltari@gmail.com> <YEaQdXwrmVekXp4G@lunn.ch>
 <D39D163A-C6B3-4B66-B650-8FF0A06EF7A2@gmail.com> <YFJBJ1IHpkXXaGvc@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4c3f1252-50fd-8d90-3fac-009dace44813@gmail.com>
Date:   Wed, 17 Mar 2021 14:42:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFJBJ1IHpkXXaGvc@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/2021 10:49 AM, Andrew Lunn wrote:
>> BCM6368 (and newer) SoCs have an integrated ethernet switch controller with dedicated internal phys, but it also supports connecting to external phys not integrated in the internal switch.
>> Ports 0-3 are internal, ports 4-7 are external and can be connected to external switches or phys and port 8 is the CPU.
>> This MDIO bus device is integrated in the BCM63xx switch registers, which corresponds to the same registers present in drivers/net/dsa/b53/b53_regs.h.
>> As you can see in the source code, registers are the same for the internal and external bus. The only difference is that if MDIOC_EXT_MASK (bit 16) is set, the MDIO bus accessed will be the external, and on the contrary, if bit 16 isn’t set, the MDIO bus accessed will be the internal one.
>>
>> I don’t know if this answers your question, but I think that adding it as mdiomux is the way to go.
> 
> Hi Álvaro
> 
> The Marvell mv88e6390 family of switches has a very similar setup. An
> internal and an external MDIO bus, one bit difference in a
> register. When i wrote the code for that, i decided it was not a mux
> as such, but two MDIO busses. So i register two MDIO busses, and rely
> on a higher level switch register mutex to prevent parallel operations
> on the two busses.
> 
> The reason i decided it was not a mux, is that all the other mux
> drivers are separate drivers which rely on another MDIO bus
> driver. The mux driver gets a handle to the underlying MDIO bus
> driver, and and builds on it. Here you have it all combined in one, so
> it does not follow the pattern.
> 
> So if you want to use a max, please break this up into an MDIO driver,
> and a mux driver. Or have one driver which registers two mdio busses,
> no mux.

Also, if you were to support some dynamic power management in the
future, it may be desirable to have the switch drivers and the MDIO mux
controller be within the same driver, so you are in complete control of
when the resources are needed and you can fully clock gate everything.
-- 
Florian
