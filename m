Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9072B63E3D8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiK3W71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK3W70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:59:26 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4535AE0D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:59:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id x17so29482205wrn.6
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uj6BmGAnzvoTtvK6BAtmcK2wG3hf73fMKQYgZn8bXgk=;
        b=i7GMf+a6qKLu7GqOEqlHbZ7R1eXbaKJ0m/dImT6MbV13CslaNoe7IeaQCnqwuBximj
         1wqtVjUV7RXjRLKfnqGaEVNzfD/0KcxSz3MIqcGwICzcFI4I/CQz/Kl2OzCqiqmEfTTq
         I7LammwZssm8IxVx2wXPHwx2QluK3pWymjmME7DgwcIny4xT4BVGY1+Rjh3v87ZJTk+E
         BYszrE2sP5xQS6EkF/NIcpFiLjeZ3NYL58/dKc5y5vG1N2hlD39hqnjEOSJZrubfKeaJ
         1v7ekOaNAj8C2ThizPToYtBrLW+YTuU82PoJYBguTbJZYrSWnO5tX4ixWxtIql0ZM8nD
         nIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uj6BmGAnzvoTtvK6BAtmcK2wG3hf73fMKQYgZn8bXgk=;
        b=hnWj2O5jXp4rmw0rJ4d+gDrmvisXV8G0SPXxkwc1Ji15INWwvU91H1U1nvxl76QZ20
         bEc8kPS4ir/iMm/STbOeb04NnUJL90v1WxDJq81Mgiiz2ZpBKNGPF2kfr66uRF/CwauT
         9ZVHmJPiiAWU1lb35un64g5ollbz2zPrGNSufbWEbB//RPYA7hA4HQ6wWu+yuFH7r9Cx
         TdIfRuD5E8naUY0eqQYgH4Qy/hiGJ3XAlCQOdpUwRt8uJ0ASq5pEabMHVRYmoVZ0dOVx
         K+jBisbzwmLVasYgNsjAh8Jmqxfn8SLOae4aWl3PpkLdiWrlxcm0U1SNue+au04nKcg6
         LY+Q==
X-Gm-Message-State: ANoB5pler5ZOp6l00MeF/r9Sd+3PJwOcSVTSJoLRVcz6v78OwORGUgSW
        KmrFDh23eLO9Nfy729H4p5Y5UE8wwX6UGw==
X-Google-Smtp-Source: AA0mqf5VIRJjR6Emnoq1ajr7zrr3go63H6AQfTqw9XuHhTJEvcinaeuUGvpiVtf2aqelKfs7OJa5zA==
X-Received: by 2002:adf:e2c9:0:b0:241:db86:176d with SMTP id d9-20020adfe2c9000000b00241db86176dmr29169507wrj.40.1669849163840;
        Wed, 30 Nov 2022 14:59:23 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id y5-20020a056000108500b00241d544c9b1sm3152750wrw.90.2022.11.30.14.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 14:59:23 -0800 (PST)
Date:   Wed, 30 Nov 2022 23:59:27 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: Help on PHY not supporting autoneg
Message-ID: <Y4fgT1kjX9LTULOi@gvm01>
References: <Y4dJgj4Z8516tJwx@gvm01>
 <Y4d3fV8lUhUehCq6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4d3fV8lUhUehCq6@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > [   27.049388] socfpga-dwmac ff700000.ethernet eth0: configuring for phy/mii link mode
> > [   27.057155] ncn_resume  // I don't fully understand what happened since the link up, but it seems the MAC is doing more initialization
> 
> This looks odd. I would not expect a resume here. Add a WARN_ON(1) to
> get a stack trace and see if that helps explain why. My guess would
> be, you somehow end up in socfpga_dwmac_resume().
Ok, I can see the MAC driver gets there. I'll try to debug this later
(not my focus at the moment).

> > [   27.061251] ncn_handle_interrupt 8001
> > [   27.065100] link = 0, ret = 0809 // here I get a link down (???)
> > 
> > >From there on, if I read the LINK_CONTROL bit, someone set it to 0 (???)
> 
> You can add a WARN_ON(regnum==0) in phy_write() to get a stack trace.
Indeed, it was genphy_setup_forced setting this bit to 0.

> 
> > I've also tried a completely different approach, that is "emulating"
> > autoneg by implementing the config_aneg, aneg_done and read_status
> > callbacks. If I do this, then my driver works just fine and nobody seems
> > to be overwriting register 0.
> 
> That is not emulating. The config_aneg() just has a bad name.
> 
> If you have not provided a config_aneg() the default implementation is
> used, __genphy_config_aneg(), which will call genphy_setup_forced():
> 
> int genphy_setup_forced(struct phy_device *phydev)
> {
> 	u16 ctl;
> 
> 	phydev->pause = 0;
> 	phydev->asym_pause = 0;
> 
> 	ctl = mii_bmcr_encode_fixed(phydev->speed, phydev->duplex);
> 
> 	return phy_modify(phydev, MII_BMCR,
> 			  ~(BMCR_LOOPBACK | BMCR_ISOLATE | BMCR_PDOWN), ctl);
> 
Ok, there is where my problem was. If I supply a config_aneg()
implementation that sets the bits I want, then everything works just
fine, and ethtool seems to report the correct information.

[   17.061733] dwmac1000: Master AXI performs any burst length
[   17.061766] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
[   17.061799] socfpga-dwmac ff700000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
[   17.062957] socfpga-dwmac ff700000.ethernet eth0: registered PTP clock
[   17.066366] socfpga-dwmac ff700000.ethernet eth0: configuring for phy/mii link mode
[   17.067170] socfpga-dwmac ff700000.ethernet eth0: No phy led trigger registered for speed(10)
[   17.067404] socfpga-dwmac ff700000.ethernet eth0: Link is Up - 10Mbps/Half - flow control off
/root #
/root # ethtool eth0
Settings for eth0:
        Supported ports: [ MII ]
        Supported link modes:   10baseT1S_P2MP/Half
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT1S_P2MP/Half
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 10Mb/s
        Duplex: Half
        Auto-negotiation: off
        Port: Twisted Pair
        PHYAD: 8
        Transceiver: external
        MDI-X: off (auto)
        Supports Wake-on: d
        Wake-on: d
        Current message level: 0x0000003f (63)
                               drv probe link timer ifdown ifup
        Link detected: yes


> What exactly is LINK_CONTROL. It is not one of the Linux names for a
> bit in BMCR.
The 802.3cg standard define link_control as a varibale set by autoneg.
In factm it is tied to the BMCR_ANENABLE bit. The standard further
specifies that when AN is not supported, this bit can be supplied in a
vendor-specific way. A common thing to do is to just leave it tied to
the BMCR_ANENABLE bit.

So, the "problem" seems to lie in the genphy_setup_forced() function.
More precisely, where you pointed me at: 
>       return phy_modify(phydev, MII_BMCR,
>                         ~(BMCR_LOOPBACK | BMCR_ISOLATE | BMCR_PDOWN), ctl);
> 

In my view we have two choices to handle LINK_CONTROL.

1. Just let the PHY driver override the config_aneg() callback as I did.
This may be a bit counter-intuitive because of the function name, but it
works.

2. in phylib, distinguish the case of a PHY having aneg disabled from a
PHY NOT supporting aneg. In the latter case, don't touch the control
register and/or provide a separate callback for "starting" the PHY
(e.g., set_link_ctrl)

Thoughts?

Thank you again for your kind answer!
Piergiorgio
