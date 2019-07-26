Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072927672A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfGZNTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:19:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51182 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGZNTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 09:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1ide1S0VA9YNwqSMlXRfUIlxbpaz20nr8XX4lCcdPsk=; b=l8LCWcB8yjaQG0uSpG+DN990G
        pp2jnxAF1UjU37FQBaQviWeZ2M2bWm9Qh2PRjEVm2yytR/H6IOv0ur/jnhR02P3wRTI84qrmhYcgc
        W7HZEaQSKtE+X8AeSjpA0ITldNNZeXBbjyI0OAEhueG9g81rS5R3Lh2v78oNKi6cc+hXz4aIsiqm8
        MYB+FFRMZPB3vv6MxTc/6mc8ti/PN6BktKtJp8PnioI4UXVibWejHtFOTvqkZls22SakiJi84OydL
        NvI2X8ykD/ET9QFQDkOWRoj6vDdhEfEarlex/ZlIKV2JNjJ8aRDFwgbYfb1kzTT8NLaRBs9/yLz5I
        ljWkMFtrw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:44778)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hr07t-0006Qj-L0; Fri, 26 Jul 2019 14:19:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hr07l-0006om-BN; Fri, 26 Jul 2019 14:19:05 +0100
Date:   Fri, 26 Jul 2019 14:19:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: ethernet: Update mt7622
 docs and dts to reflect the new phylink API
Message-ID: <20190726131905.GP1330@shell.armlinux.org.uk>
References: <20190724192411.20639-1-opensource@vdorst.com>
 <20190725193123.GA32542@lunn.ch>
 <20190726071956.Horde.s4rfuzovwXB-d3LnV0PLRc8@www.vdorst.com>
 <20190726131604.GA18223@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726131604.GA18223@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 03:16:04PM +0200, Andrew Lunn wrote:
> Are you sure it is using SGMII and not 2500BaseX? Can you get access
> to the signalling word? SGMII is supposed to indicate to the MAC what
> speed it is using, via inband signalling. So there should not be any
> need for a fixed-link. 2500BaseX however does not have such
> signalling, so there would need to be a fixed link.
> 
> Maybe we should really consider what phy-mode = "sgmii"; means. Should
> this include the overclocked 2.5G speed, or should we add a 2500sgmii
> link mode?

Note that Documentation/networking/phy.rst now contains definitions
for SGMII, 1000BASE-X and 2500BASE-X.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
