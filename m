Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08A528528F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 21:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgJFTgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 15:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgJFTgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 15:36:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE6C061755;
        Tue,  6 Oct 2020 12:36:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id e10so9067539pfj.1;
        Tue, 06 Oct 2020 12:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/eeHDZDcpjWAS9l1EMQwr30CX+2r1cu9DpTlqTeQ1xg=;
        b=BNca2HRCKhtoZhtd/Mh3DzNZLZ5f+ClVzv3j/bRBVvDe0cTS0WDi5aaa7NJi4t8Oxo
         EEzu7Yr/bjoS/QOT1BQZNPvWK/ZZXLXgDFh0QzE2o3m0gYuFqQ5i0fpFXxIyWE6nG1gK
         gKfA0QzQMsBWAviBcv2XjSSc4Z8JzIU6bQTZg2OGQfHndANd/7e3X3cUNsSMIiQ5BbTc
         CGKyzNOZlFtccuV2RNMRxthSZgeAhl275iq7u68LvkOOENq2ZPJBAsGDag3uzrnj/oVw
         2XqYAoPONKeboThtqsWW96MH5291bYxnp+Nac9Dk9g6g5em2B+jGuY+NsmdRmupO8SEM
         DZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/eeHDZDcpjWAS9l1EMQwr30CX+2r1cu9DpTlqTeQ1xg=;
        b=opXSTGXZBdymaIbSfcIvmedRlATHHf/AgJVqV9lXQ9kVNjVWJV2Ga7BnPMXdHtxPfm
         2D1mDgovDBaHn15PVsYYgpaUUC31oiloyWP30S4uoeG3eAuuh3RpPosYPDGPJ44wHWz3
         vRk+TmswoWLhSnH1l3xDz6qzCbDRoiv9u+ekLB/AxiFdNRqNMOMB4AWuzxaMeA0zKMkV
         3qQeCKsY8MNROjJ88EuPWoa76v9BoQffKCfXt6r1S+cCFXKKygo58UqB90vuEU/mKyQW
         Mqnl+mLDR/TZTI+ELGJbqZfU9qxjpnzehheG7ScqRt2ptjj9mhFfzCFoG3Bfx42WUwCm
         U3PA==
X-Gm-Message-State: AOAM532CtlszuFfHSotM9XG0CVjUNJbVfyKhLacO7k6J4CJrozxpXRC9
        5ENMQ5ghLy1zxNPmvGZjUHF1T+MVV9WLww==
X-Google-Smtp-Source: ABdhPJzopm9wGn5eXHHL2IhzwUjScnoYO0+pDnaJ3uvZVRF4WZ71QHz299pTMj9OzL4sOfZ4gwhOpw==
X-Received: by 2002:a63:3403:: with SMTP id b3mr5186903pga.387.1602012982378;
        Tue, 06 Oct 2020 12:36:22 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k24sm1177577pfi.13.2020.10.06.12.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 12:36:21 -0700 (PDT)
Subject: Re: PHY reset question
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>
References: <20201006080424.GA6988@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
Date:   Tue, 6 Oct 2020 12:36:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006080424.GA6988@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/6/2020 1:04 AM, Oleksij Rempel wrote:
> Hello PHY experts,
> 
> Short version:
> what is the proper way to handle the PHY reset before identifying PHY?
> 
> Long version:
> I stumbled over following issue:
> If PHY reset is registered within PHY node. Then, sometimes,  we will not be
> able to identify it (read PHY ID), because PHY is under reset.
> 
> mdio {
> 	compatible = "virtual,mdio-gpio";
> 
> 	[...]
> 
> 	/* Microchip KSZ8081 */
> 	usbeth_phy: ethernet-phy@3 {
> 		reg = <0x3>;
> 
> 		interrupts-extended = <&gpio5 12 IRQ_TYPE_LEVEL_LOW>;
> 		reset-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
> 		reset-assert-us = <500>;
> 		reset-deassert-us = <1000>;
> 	};
> 
> 	[...]
> };
> 
> On simple boards with one PHY per MDIO bus, it is easy to workaround by using
> phy-reset-gpios withing MAC node (illustrated in below DT example), instead of
> using reset-gpios within PHY node (see above DT example).
> 
> &fec {
> 	[...]
> 	phy-mode = "rmii";
> 	phy-reset-gpios = <&gpio4 12 GPIO_ACTIVE_LOW>;
> 	[...]
> };
> 
> On boards with multiple PHYs (for example attached to a switch) and separate
> reset lines to each PHY, it becomes more challenging. In my case, after power
> cycle the system is working as expected:
> - pinmux is configured to GPIO mode with internal pull-up
> - GPIO is by default in input state. So the internal pull-up will automatically
>    dessert the PHY reset.
> 
> On reboot, the system will assert the reset. GPIO configuration will survive the
> reboot and PHYs will stay in the reset state, and not detected by the system.
> 
> So far I have following options/workarounds:
> - do all needed configurations in the bootloader.
>    Disadvantage:
>    - not clear at which init level it should be done?
>      1. Boot ROM script (in case of iMX). One fix per each board. Ease to forget.
>      2. Pre bootloader. Same as 1.
>      3. GPIO driver in the bootloader. What if some configuration was done in
>         1. or 2.?
>    - we will go back to the same problem if we jumped to Kexec
> 
> - Use compatible ("compatible = "ethernet-phy-id0022.1560") in the devicetree,
>    so that reading the PHYID is not needed
>    - easy to solve.
>    Disadvantage:
>    - losing PHY auto-detection capability
>    - need a new devicetree if different PHY is used (for example in different
>      board revision)

Or you can punt that to the boot loader to be able to tell the 
difference and populate different compatible, or even manage the PHY 
reset to be able to read the actual PHY OUI. To me that is still the 
best solution around.

> 
> - modify PHY framework to deassert reset before identifying the PHY.
>    Disadvantages?

The disadvantages would be that you would have to use 
__of_reset_control_get() against the PHY device tree node because there 
are no phy_device being created yet because you have not been able to 
identify it. Given that there are people working on the ACPIzation of 
the PHY framework, that would be a set back.
-- 
Florian
