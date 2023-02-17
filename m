Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7163269AAA7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjBQLnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBQLnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:43:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D05644E3
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hXtMKcnIVC4pB/u5ZRz/yl0d1ILdtFcAtyYbsXXOaLw=; b=xgV0JyRyS1wKmnRpRLhWF3LEjI
        Yp1FEQvfdMgCqspsARBrlUw+2j/dQNAUbXdYAI1mX1ddgZ4cbbt5lEkmaauGTny+bU9H3jXOsahdZ
        88G7cJikcjGYuPiMwxlqUfj4UAhbniopOEMOUl4R7/RO/e3i5jfGQaz7lie6kLvIcGVJ3hbjYwi7t
        9jOA4avhj+BREqDz4mqVJ/Yl+cLB/Wbb3Qo2pZX65RaUgAs8n33O4yfrWjzDH2VhNN0z/iKGWGvoy
        TtaH83CFGNp1M8pgbnqQONqP7K97Db5NyboX+B1Zn2tR3QR/8b9N8sc0t7Uz7rjICzZT4RSCssmDv
        KuVAzc0Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54798)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSz9V-0000rz-Gf; Fri, 17 Feb 2023 11:43:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSz9T-0006lg-IT; Fri, 17 Feb 2023 11:43:43 +0000
Date:   Fri, 17 Feb 2023 11:43:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 16/18] net: phylink: Update comment about configuring
 EEE in mac_link_up()
Message-ID: <Y+9ob4IhDOTSFJYV@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-17-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-17-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:28AM +0100, Andrew Lunn wrote:
> phy_init_eee() is about to be removed. If eee is active can be
> determined directly from the phydev structure. Update the
> documentation to indicate this.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
