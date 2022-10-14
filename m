Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A985FEC70
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJNKSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiJNKSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:18:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D752B12FFA8
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 03:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2M67E4exov3pIudJ8dLX9p/62WDBS+2cAltVv6T03AA=; b=sfHm+VkQDbGDSCIPpuYyvJu4Op
        HByYBFDrqYxmiUy0/ltP/mwZ3fBqsuUWp7JPlrmTRBoCgYnK1wQiD+eDogKbjvWQ3kguf0JhNtHWX
        pOjaspaz6RlSgqzEmyP7gBjF92JKKgCDaaZgfxlJYxvrbVcfEWC9xTdua4i6ay06rx29OkrPaTXqG
        GEuhXjDZZohqo7F3SOuBbOfqSvxHm4/uYevqnlFP+Pij7rZoWZXGHWrk9PB6P8ZxkCUo60wNfzYDS
        68cv7b2cqjtta56EjRarN4kcSCuVwdBRWlHnd4ijQkF+Kc/VXG1Sw2cfxGqKkWNevhoXHK/C1Kilv
        84epCK8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34718)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ojHlV-0000hC-CG; Fri, 14 Oct 2022 11:18:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ojHlO-0005eU-FA; Fri, 14 Oct 2022 11:17:58 +0100
Date:   Fri, 14 Oct 2022 11:17:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v5 0/2] net: phylink: add phylink_set_mac_pm()
 helper
Message-ID: <Y0k3VqK4oOLOEljJ@shell.armlinux.org.uk>
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
 <Y0g3tW26qDDaxYPP@shell.armlinux.org.uk>
 <PAXPR04MB9185777624723D0FE11C6E4689259@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB9185777624723D0FE11C6E4689259@PAXPR04MB9185.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 07:24:02PM +0000, Shenwei Wang wrote:
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Thursday, October 13, 2022 11:07 AM
> > On Thu, Oct 13, 2022 at 08:39:02AM -0500, Shenwei Wang wrote:
> > > Per Russell's suggestion, the implementation is changed from the
> > > helper function to add an extra property in phylink_config structure
> > > because this change can easily cover SFP usecase too.
> > 
> > Which tree are you aiming this for - net-next or net?
> 
> The patch can be applied to both trees.  You can select the one which is easy to
> go ahead.

That may be the case at the moment, because the net-next tree has been
merged into mainline and the net tree recently updated to mainline, but
that is not always the case.

The purpose of the tag in the subject line is to tell the various
maintainers on the netdev mailing list what _your_ expectation is for
the patch and where _you_ intend it to be applied.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
