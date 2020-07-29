Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409972316DA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgG2Ajj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgG2Ajj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:39:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28909C061794;
        Tue, 28 Jul 2020 17:39:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id lw1so741757pjb.1;
        Tue, 28 Jul 2020 17:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=muLAl6LTD+gu14drrDwky2o0322l334QlBv9CFCwKwQ=;
        b=BpaRNNY1RCoy81v7tdTbEcmYtILAEPOWoAI3AjvJ1NLrL9oLUVjoiK59XiHVyMRUiE
         Y6pRDR8NOYZpCdJX1kX4Cpwbal1RMdV9XOKb9W3uf2rqk+YnofCPJrzK0qGOYS84SPNM
         0ngt9rrdPWh3g6E8oJ8PUNrJcOsTbPtj6lTz1mNhzgOBGazWeohoGInfLOhlMVcqoPUv
         MGLLTiVveXaS2OayafJzr+qktSH8VOzls9X7Nn1ukH9nIU24Am6x6JOCmA/ERHzGlNhz
         n3bqmDQNMvqUlCl3OOiRy5h3jtOs+4UC//77hFtITU/V8FJcERoiMD4YTbq5Etcts5km
         yYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=muLAl6LTD+gu14drrDwky2o0322l334QlBv9CFCwKwQ=;
        b=VbGe7XMJBRpGqL+fQmQdG+RoU3r+NFnUu1YGD0qbNNC7cF3UoI8zPnMYoGMCMzklEm
         VD5noSBKgBxCnsXWgRQqcGlMisM4QmtsrFrzvuHiB/+qDBCsAZqTl+vDtf/WTbJuPMM+
         /1zGT7/I/CFZ/7veH/WYDuVPvNXfllQao4VXgtx13Uzb0l1wvdZ8gaSQJUIICQTCSlD5
         N0O6/LwOnsJwASehWqXN8hKnLSK/jZWFnF/+zEnQGPG8679Uw+syKfsHo4nRwNX9+Ema
         tLc//amvPLs2483fRNfy+jAEI88ke6Oe3eKYCW1nATkx5g/z0LGkvwzuVh1QrTOTYqIV
         tAqg==
X-Gm-Message-State: AOAM533fr9t3Aew6sEfn1tJFFxNRimI3gMZo7JK6CzIt1PG/aNvh0rYH
        4yTjgwh0dTfTATI4Y3Zy9cIC9LDo
X-Google-Smtp-Source: ABdhPJxEwLCPJDU45oCwJFcH9RRW/z+uGBeG/xuRtEAquSmyoq4rjMiJ3GD6fS6n4akYIMCTeIe+1A==
X-Received: by 2002:a17:902:7405:: with SMTP id g5mr3029480pll.173.1595983178021;
        Tue, 28 Jul 2020 17:39:38 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm250500pjt.19.2020.07.28.17.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 17:39:37 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1e4301bf-cbf2-a96b-0b76-611ed08aa39a@gmail.com>
Date:   Tue, 28 Jul 2020 17:39:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/2020 3:30 PM, Jeremy Linton wrote:
> Hi,
> 
> On 7/28/20 3:06 AM, Dan Callaghan wrote:
>> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
>>> Now i could be wrong, but are Ethernet switches something you expect
>>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
>>> escape hatch?
>>
>> As an extra data point: right now I am working on an x86 embedded
>> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
>> I have been watching this patch series with great interest, because
>> right now there is no way for me to configure a complex switch topology
>> in DSA without Device Tree.
> 
> DSA though, the switch is hung off a normal MAC/MDIO, right? (ignoring
> whether that NIC/MAC is actually hug off PCIe for the moment).

There is no specific bus, we have memory mapped, MDIO, SPI, I2C swiches
all supported within the driver framework right now.

> 
> It just has a bunch of phy devices strung out on that single MAC/MDIO.

It has a number of built-in PHYs that typically appear on a MDIO bus,
whether that bus is the switch's internal MDIO bus, or another MDIO bus
(which could be provided with just two GPIOs) depends on how the switch
is connected to its management host.

When the switch is interfaced via MDIO the switch also typically has a
MDIO interface called the pseudo-PHY which is how you can actually tap
into the control interface of the switch, as opposed to reading its
internal PHYs from the MDIO bus.

> So in ACPI land it would still have a relationship similar to the one
> Andrew pointed out with his DT example where the eth0->mdio->phy are all
> contained in their physical parent. The phy in that case associated with
> the parent adapter would be the first direct decedent of the mdio, the
> switch itself could then be represented with another device, with a
> further string of device/phys representing the devices. (I dislike
> drawing acsii art, but if this isn't clear I will, its also worthwhile
> to look at the dpaa2 docs for how the mac/phys work on this device for
> contrast.).

The eth0->mdio->phy relationship you describe is the simple case that
you are well aware of which is say what we have on the Raspberry Pi 4
with GENET and the external Broadcom PHY.

For an Ethernet switch connected to an Ethernet MAC, we have 4 different
types of objects:

- the Ethernet MAC which sits on its specific bus

- the Ethernet switch which also sits on its specific bus

- the built-in PHYs of the Ethernet switch which sit on whatever
bus/interface the switch provides to make them accessible

- the specific bus controller that provides access to the Ethernet switch

and this is a simplification that does not take into account Physical
Coding Sublayer devices, pure MDIO devices (with no foot in the Ethernet
land such as PCIe, USB3 or SATA PHYs), SFP, SFF and other pluggable modules.

> 
> If so, then its probably possible to represent with a fairly regular
> looking set of ACPI objects and avoids part of the core discussion here
> about whether we need a standardized way to pick phy's out of arbitrary
> parts of the hierarchy using a part of the spec intended for one off
> problems.

Using regular ACPI objects would work, however I do not see how it can
alleviate having this discussion. It has been repeated again and again
that we do not want to see snowflake ACPI representation that each and
every driver writer is going to draw inspiration from.

Upon further reading of the ACPI specification, I do not think we are
going to see much definition or a driving force show up about how the
Ethernet objects (MAC, PHY, switches, SFPs, etc.) relate to one another.
The ACPI specification seems to be more about defining the ACPI objects
and their methods, which is on a different scope than how to tie them
together.

What Calvin has done thus far is the closest to what I believe we can
achieve given how nebulous and arcane ACPI is for the PHY library
maintainers within this context.
-- 
Florian
