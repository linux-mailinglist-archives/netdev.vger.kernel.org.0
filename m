Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EF9486326
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbiAFKsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbiAFKsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 05:48:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C2EC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 02:48:40 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o6so7881598edc.4
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 02:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MJANHNS+8aI/78fac1sUNs7UOadPi7MEsH1ZtuTV31A=;
        b=b/q6az6wTE2VKN54Lbkvi7KR7zAmB1K3LcQEEX/U7I/DMIr5qSrB6piuBNsTPD4ibV
         E2OrAejJl5ZLDCSbgMqaVzXPWH1cvy0M5LBypecl3/9Gf/3wTu/Pkz+09xSFg8OZJzbG
         zOhsJ+7I3yYWrmi306YlCvUAYLZQj2W0M+vI+UcXy+FWqH7to9okhDgyD3KVjlBTD1QO
         /FWZ78GT4R5mvisTF7v2hrrpsL9f60nKMLZw6BzMBB0WNCxXEJP5nVNNtl9y37qwusix
         OX+Sj6Y9HUh+hwd9U+vARgItg7X37oA5oMG+Zi0fv42i8dsErDniJW2C4Ae/gzx2l+z7
         xI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MJANHNS+8aI/78fac1sUNs7UOadPi7MEsH1ZtuTV31A=;
        b=D3oI1DlqzrOffYRzaK4Nz5WcGHvhHDAhKRbulN0pH8RKQxWH1y11S2FL11L4aTGAPY
         rhDOa6uLmm2VecHLn3oiibriZzMUfnGpe2gkBHuEzy7ljTHha21F3hIme71BYkKKn9/1
         pqQ8o57oxqR/Glc59bXxG6+e2PSpnVm58O9nzTREAGPz6f2ugVWl8OaiDzd6CVO6AC5Y
         QGUt+r9pEmOK3eMkEs6A5bN5I1DCe0kcl8LSCip26PiqLZNWKyttJ66beTKhBafOrgTr
         ey0s8gbYBQ/nMRezoXYYiilLPKb3DGlq+ZfRJQmhTFkBTXEkL4iwn5qYN+w/vAdfW0d7
         mgZA==
X-Gm-Message-State: AOAM533Pq8QIFD0IVOx/RYCATr/iOyFTLlVdpIsJv5elRPwqOxHXjy2u
        qbsdfxZ2jvYCoQh3LE2B5dq0NCl1U/c=
X-Google-Smtp-Source: ABdhPJx2C6GaeCVdst6DjNRiXu7O98kCHiNqtXcUKtcwcuVu2/xkOYJI56ThifcwONqH/pgtgCrc9A==
X-Received: by 2002:aa7:d2da:: with SMTP id k26mr57690616edr.137.1641466118840;
        Thu, 06 Jan 2022 02:48:38 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id ky5sm398299ejc.204.2022.01.06.02.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 02:48:38 -0800 (PST)
Date:   Thu, 6 Jan 2022 12:48:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        katie.morris@in-advantage.com, UNGLinuxDriver@microchip.com
Subject: Re: ocelot-pcs - qsgmii planning
Message-ID: <20220106104837.clp2t6wxus7o72ny@skbuf>
References: <20220106095003.GA253016@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106095003.GA253016@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

I'm sorry, but I have no direct experience with the SERDES and PCS of
the Ocelot switches, since those blocks were completely replaced from
the NXP instantiations I'm playing with.

On Thu, Jan 06, 2022 at 01:50:03AM -0800, Colin Foster wrote:
> Hi Alexandre, Vladimir, and those with interest of Ocelot chips,
> 
> I'm starting this thread to just touch base before I dive into any PCS
> changes for Ocelot. I've appreciated all your guidance, and the only
> time I felt I've been led astray is when Alexandre told me it should be
> easy :-)
> 
> I'm at the point where I'm starting to integrate the additional 4 copper
> ports of the VSC7512 reference board. They are 4 ports connected through
> a QSGMII bus, to a VSC8514 phy.
> 
> The 8514 driver seems to be getting invoked, and running just fine.
> Also, I was able to slightly modify (hack*)
> drivers/phy/mscc/phy-ocelot-serdes.c to work with my in-development
> ocelot-mfd. I believe that is what I need to configure the HSIO
> registers.

And are you also getting a reference to it and calling it, like the
ocelot driver does here?

	err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode);

Could we see that portion of the code in the felix driver?

> 
> (*the device_is_mfd info I was using falls apart with the
> HSIO/syscon/mfd implementation here, sadly. A new probe function would
> easily clean that up, but it is more for me to think about... I digress)
> 
> I'm using these device tree settings:
> 
>     port@4 {
>         reg = <4>;
>         label = "swp4";
>         status = "okay";
>         phy-handle = <&sw_phy4>;
>         phy-mode = "qsgmii";
>         phys = <&serdes 4 SERDES6G(0)>;
>     };
>     port@5 {
>         reg = <5>;
>         label = "swp5";
>         status = "okay";
>         phy-handle = <&sw_phy5>;
>         phy-mode = "qsgmii";
>         phys = <&serdes 5 SERDES6G(0)>;
>     };
> ...
>     serdes: serdes {
>         compatible = "mscc,vsc7514-serdes";
>         #phy-cells = <2>;
>     };
>     mdio1: mdio1 {
>         compatible = "mscc,ocelot-miim",
>         pinctrl-names = "default";
>         pinctrl-0 = <&miim1>;
>         #address-cells = <1>;
>         #size-cells = <0>;
> 
>         sw_phy4: ethernet-phy@4 {
>             reg = <0x4>;
>         };
>     };
> 
> [    3.886787] libphy: ocelot_ext MDIO bus: probed
> [    5.345891] ocelot-ext-switch ocelot-ext-switch: PHY [ocelot-ext-switch-mii:00] driver [Generic PHY] (irq=POLL)
> [    5.357341] ocelot-ext-switch ocelot-ext-switch: configuring for phy/internal link mode
> [    5.372525] ocelot-ext-switch ocelot-ext-switch swp1 (uninitialized): PHY [ocelot-ext-switch-mii:01] driver [Generic PHY] (irq=POLL)
> [    5.388865] ocelot-ext-switch ocelot-ext-switch swp2 (uninitialized): PHY [ocelot-ext-switch-mii:02] driver [Generic PHY] (irq=POLL)
> [    5.405086] ocelot-ext-switch ocelot-ext-switch swp3 (uninitialized): PHY [ocelot-ext-switch-mii:03] driver [Generic PHY] (irq=POLL)
> [    6.291876] ocelot-ext-switch ocelot-ext-switch swp4 (uninitialized): PHY [ocelot-miim1-mii:04] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    6.471891] ocelot-ext-switch ocelot-ext-switch swp5 (uninitialized): PHY [ocelot-miim1-mii:05] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    6.651895] ocelot-ext-switch ocelot-ext-switch swp6 (uninitialized): PHY [ocelot-miim1-mii:06] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> [    6.831879] ocelot-ext-switch ocelot-ext-switch swp7 (uninitialized): PHY [ocelot-miim1-mii:07] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
> 
> 
> It seems like that, along with everything in vsc7514_phylink_mac_config,
> should be everything I need for operation of the four ports through the
> 8512. I've added OCELOT_QUIRK_SGMII_PORTS_MUST_BE_UP - but I'm not sure
> that's a quirk I need. Plus the only behavior it currently adds is once
> the port is up, it never comes back down.

Correct. I noticed that the code was structured to do this when I
converted it to phylink, but I don't know if it's needed either. I just
named that behavior as OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP and made it
optional.

> The current behavior I'm seeing is links and rates get detected, packets
> appear to be getting transmitted (ethtool stats) but they aren't, and
> nothing is received on either end.

could you also check ethtool --phy-statistics swp4 on both ends?

> Is there something I'm missing with the device tree? Or is this the
> purpose of the PCS driver I'm looking into? I'm getting a feeling that
> my configuration is correct, and that I need to add SerDes support for
> these ports in phylink_mac_config... I noticed that there's the "SGMII
> only for now" comment, and when I look at the reference application for
> the 7512 there's a comment "external phy uses QSGMII interface" that
> appears to set the SGMII_MODE_ENA bit to 0.

SGMII_MODE_ENA in PCS1G_MODE_CFG refers to the selection between Cisco
SGMII/QSGMII vs IEEE 802.3 fiber modes. Different autonegotiation code
words being transmitted. It's correct to leave it the way it is. It's
curious that the reference application suggests to set it to 0 for QSGMII.
I suppose that if in-band autoneg isn't enabled in PCS1G_ANEG_CFG, it
doesn't really matter what kind of autoneg is used.

For SGMII vs QSGMII, the serdes_set_mode() function in
phy-ocelot-serdes.c should set HSIO_HW_CFG_QSGMII_ENA where appropriate.

> Thank you as always for your time,
> 
> Colin Foster.

What bootloader do you use? Do you have VSC8514 PHY initialization of
any sort in the bootloader?
