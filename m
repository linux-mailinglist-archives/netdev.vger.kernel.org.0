Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7440B749
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 20:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhINS6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 14:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhINS5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 14:57:54 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4E0C061574;
        Tue, 14 Sep 2021 11:56:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso2962827pji.4;
        Tue, 14 Sep 2021 11:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/Vzqb4zpB+o7XTWVTgwP88QlPfBbr0l51uZrkKoD2tI=;
        b=D4yxK71K33/1h2U+79vG26zF/n4fmDNefnbVwbHTuNFQ0FyEE6MfPK+Y1/tviPCS85
         q8gL4Auj1aXZ3yQwn4+pIh1kZLinw3N9m0nSNyn+W/JTWC/aIwFhIzB0rdRP3QlkXOoe
         R5+MpvuG67uM4bhBESSWoDeZbfBYKY5E6OftMx2XFZEqVIMbzJUokaSAFcw02XLwf1wQ
         UpKcwokooLndBVwYTrUw5FA7OnT5zrfsicHVqcKu5Xd+JPnVNM3EqPCieDvxlQaeyu6d
         xhufbFOtnNohwANcqAidD5vEzYcsMybPSiXsI9zRnfXM5AmgjQBOXI/lxFM7g7GdxaJI
         rTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/Vzqb4zpB+o7XTWVTgwP88QlPfBbr0l51uZrkKoD2tI=;
        b=PG3jQyUfqUWntvpsCVuzJM7yrHkkvEHGhBvD2MBo2qpxfi8aGqLRDbVPiX6rhRcju4
         wSQrB3gJYFRpx3Nt7OzIrfRrYgqmQ1R1VRFLOIe2k0B79CclQ8xWVu5tHkITkOkbKRhJ
         fw4VOnzsEehyak8wN7dsnd28sBNWJ+xPockWXM/9WM1r6dtePPCW4WcyskQIfrIJa/M3
         aGpl4bVvC3ZYa2tIminEISX2MMWMCKFJb2zCu8HVCHit36lhTgOMwS7UOdxSHEAStSyL
         mTMCIKRP2UrJ8GXmbG829ewN75lBD07Wbr6TEWl9WcXfRzgBjrDaRav7w3TZmrlHIsz0
         oLew==
X-Gm-Message-State: AOAM532xVwIhOiZrJIdFkDuG/DWhYVTA3lm4BY97VVCBiHH0VYmnLMcE
        h8lZb6H4eKMlUXKV24x87ZE=
X-Google-Smtp-Source: ABdhPJx6HH6hfwGJ7oA3rhF9hY8ptNJBQ/GNEWROQiq7XR/Hj7HF7M8HACKESRm6552pBN4XP07M3g==
X-Received: by 2002:a17:90a:7c42:: with SMTP id e2mr3740148pjl.132.1631645796507;
        Tue, 14 Sep 2021 11:56:36 -0700 (PDT)
Received: from [10.69.77.159] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c123sm10701539pfc.50.2021.09.14.11.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:56:35 -0700 (PDT)
Message-ID: <28f240f8-3fd8-d9ff-3169-50ae06cf8df5@gmail.com>
Date:   Tue, 14 Sep 2021 11:56:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 net] Revert "net: phy: Uniform PHY driver access"
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
References: <20210914140515.2311548-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210914140515.2311548-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2021 7:05 AM, Vladimir Oltean wrote:
> This reverts commit 3ac8eed62596387214869319379c1fcba264d8c6, which did
> more than it said on the box, and not only it replaced to_phy_driver
> with phydev->drv, but it also removed the "!drv" check, without actually
> explaining why that is fine.
> 
> That patch in fact breaks suspend/resume on any system which has PHY
> devices with no drivers bound.
> 
> The stack trace is:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
> pc : mdio_bus_phy_suspend+0xd8/0xec
> lr : dpm_run_callback+0x38/0x90
> Call trace:
>   mdio_bus_phy_suspend+0xd8/0xec
>   dpm_run_callback+0x38/0x90
>   __device_suspend+0x108/0x3cc
>   dpm_suspend+0x140/0x210
>   dpm_suspend_start+0x7c/0xa0
>   suspend_devices_and_enter+0x13c/0x540
>   pm_suspend+0x2a4/0x330
> 
> Examples why that assumption is not fine:
> 
> - There is an MDIO bus with a PHY device that doesn't have a specific
>    PHY driver loaded, because mdiobus_register() automatically creates a
>    PHY device for it but there is no specific PHY driver in the system.
>    Normally under those circumstances, the generic PHY driver will be
>    bound lazily to it (at phy_attach_direct time). But some Ethernet
>    drivers attach to their PHY at .ndo_open time. Until then it, the
>    to-be-driven-by-genphy PHY device will not have a driver. The blamed
>    patch amounts to saying "you need to open all net devices before the
>    system can suspend, to avoid the NULL pointer dereference".
> 
> - There is any raw MDIO device which has 'plausible' values in the PHY
>    ID registers 2 and 3, which is located on an MDIO bus whose driver
>    does not set bus->phy_mask = ~0 (which prevents auto-scanning of PHY
>    devices). An example could be a MAC's internal MDIO bus with PCS
>    devices on it, for serial links such as SGMII. PHY devices will get
>    created for those PCSes too, due to that MDIO bus auto-scanning, and
>    although those PHY devices are not used, they do not bother anybody
>    either. PCS devices are usually managed in Linux as raw MDIO devices.
>    Nonetheless, they do not have a PHY driver, nor does anybody attempt
>    to connect to them (because they are not a PHY), and therefore this
>    patch breaks that.
> 
> The goal itself of the patch is questionable, so I am going for a
> straight revert. to_phy_driver does not seem to have a need to be
> replaced by phydev->drv, in fact that might even trigger code paths
> which were not given too deep of a thought.
> 
> For instance:
> 
> phy_probe populates phydev->drv at the beginning, but does not clean it
> up on any error (including EPROBE_DEFER). So if the phydev driver
> requests probe deferral, phydev->drv will remain populated despite there
> being no driver bound.
> 
> If a system suspend starts in between the initial probe deferral request
> and the subsequent probe retry, we will be calling the phydev->drv->suspend
> method, but _before_ any phydev->drv->probe call has succeeded.
> 
> That is to say, if the phydev->drv is allocating any driver-private data
> structure in ->probe, it pretty much expects that data structure to be
> available in ->suspend. But it may not. That is a pretty insane
> environment to present to PHY drivers.
> 
> In the code structure before the blamed patch, mdio_bus_phy_may_suspend
> would just say "no, don't suspend" to any PHY device which does not have
> a driver pointer _in_the_device_structure_ (not the phydev->drv). That
> would essentially ensure that ->suspend will never get called for a
> device that has not yet successfully completed probe. This is the code
> structure the patch is returning to, via the revert.
> 
> Fixes: 3ac8eed62596 ("net: phy: Uniform PHY driver access")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
