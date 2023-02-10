Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A46691CB4
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjBJKbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjBJKbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:31:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F8128856;
        Fri, 10 Feb 2023 02:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0Xo2ox37+Egn/6Ir107WQst5VTd3PA7umPp/8qxJ+cs=; b=dVIONNKXENZUqAvpuFHrmXFG2e
        fHmIlPW51KDfwGRcaGVcZoIcokwoff4EYSfraJOO/w915PSODJsEZp2T7Rn/X1azgEWiJLtUTAVeJ
        HVrBT1e/KqkjlaX6gjTecLCOtrtm0DPUf42QUd5tYSQ1Vpgg0Jg4v6Zq1dhyn+Jk0vEEJovyfr3Y3
        L4hbIrYrUilM2i237GVRlfhkQeyRtzy2jvkoaq7fRIbpRgwo/bP7uotL79J1xS9lFBoNPZq2KrLZa
        mbig1uAg2KZivRyzc5xvpZEgukY39vJPJfew/R62lXbCkhy+D7gXOdLZXA+Mp945YWDjTz6ezDJjd
        5qpG5JOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36500)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQQgB-0001G3-8k; Fri, 10 Feb 2023 10:30:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQQg4-0005UQ-Mt; Fri, 10 Feb 2023 10:30:48 +0000
Date:   Fri, 10 Feb 2023 10:30:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v2 03/11] dt-bindings: arm: mediatek: add
 'mediatek,pn_swap' property
Message-ID: <Y+Yc2GlgQh415FWx@shell.armlinux.org.uk>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <a8c567cf8c3ec6fef426b64fb1ab7f6e63a0cc07.1675779094.git.daniel@makrotopia.org>
 <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 06:38:23PM +0100, Krzysztof Kozlowski wrote:
> On 07/02/2023 15:19, Daniel Golle wrote:
> > +Optional Properties:
> > +
> > +- mediatek,pn_swap: Invert polarity of the SGMII data lanes.
> 
> No:
> 3. Does not look like property of this node. This is a clock controller
> or system controller, not SGMII/phy etc.

Wrong. Totally wrong.

SGMII data lines consist of a "positive" and a "negative" signal.
Clearly, this PHY supports swapping the sense of those.

This CLEARLY has nothing to do with a clock controller. It's also not
system-controller related either.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
