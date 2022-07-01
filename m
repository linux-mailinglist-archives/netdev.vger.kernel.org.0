Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90405562D70
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiGAIIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiGAIIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:08:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D913F42;
        Fri,  1 Jul 2022 01:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Kc8HZYH8DYs5NZTuVB/857Gwett0sQHh5cdL2FzQFkA=; b=SzVMo+Bea1QV+nMePVXcpYp75T
        rWeogavJ4jrPx6Eof83X2CTuYcfT9nzS0VJOgG2TJytRNO7kKg72j/If21frkSiQzJ+JIeaS/pVRC
        Ztfy9g1i8tnJ+o5paX1VVov7lPQTTUMFYkubzQoCeyXWBbKHlnFgc21ou5T3aaJXZbJ8xQ6W/22E3
        xKRyxoLApDDEQFzGxkuM94GbBNAyA27Pv1hTbG68uFw8ctFhSJXmOV2ubghemVibm5W7zEksQM9sy
        KnwEUWGGGjL6I9N/lHNxlQ8NXsMuwHsq/Y8GtVSi6E9LElgUtvvGJ/Zz9dYwEKKbJYIvYNtftGZ6c
        eGo3bBcQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33128)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o7Bh1-0005T3-R4; Fri, 01 Jul 2022 09:07:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o7Bgu-0007aG-Dz; Fri, 01 Jul 2022 09:07:52 +0100
Date:   Fri, 1 Jul 2022 09:07:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        ast@kernel.org, bpf@vger.kernel.org, olteanv@gmail.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org, andrii@kernel.org,
        songliubraving@fb.com, f.fainelli@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, kpsingh@kernel.org, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, krzysztof.kozlowski+dt@linaro.org,
        yhs@fb.com, davem@davemloft.net, kafai@fb.com
Subject: Re: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add
 phylink_get_caps support
Message-ID: <Yr6rWE38HH3dSQHV@shell.armlinux.org.uk>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
 <20220630102041.25555-11-arun.ramadoss@microchip.com>
 <Yr2KuQonUBo74As+@shell.armlinux.org.uk>
 <4cf0a3ba409dcb0768150c2a1a181753dddc595b.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cf0a3ba409dcb0768150c2a1a181753dddc595b.camel@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 05:51:33AM +0000, Arun.Ramadoss@microchip.com wrote:
> > > +void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
> > > +                           struct phylink_config *config)
> > > +{
> > > +     config->mac_capabilities = MAC_100FD;
> > > +
> > > +     if (dev->info->supports_rgmii[port]) {
> > > +             /* MII/RMII/RGMII ports */
> > > +             config->mac_capabilities |= MAC_ASYM_PAUSE |
> > > MAC_SYM_PAUSE |
> > > +                                         MAC_100HD | MAC_10 |
> > > MAC_1000FD;
> > 
> > And SGMII too? (Which seems to be a given because from your list in
> > the
> > series cover message, SGMII ports also support RGMII).
> 
> No, SGMII port does not support the RGMII. I have mentioned in the
> cover message that LAN9373 has 2 RGMII and 1 SGMII port. No other part
> number has SGMII port.

So when using SGMII, there's no way for pause frames to be supported?
It seems a bit weird that the pause frame capability is dependent on
the interface type, as pause frames are just the same as normal
ethernet frames, except they're ggenerally enerated and/or interpreted
by the MAC.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
