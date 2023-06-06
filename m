Return-Path: <netdev+bounces-8412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3493723F58
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E89E81C20DF3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609522A71E;
	Tue,  6 Jun 2023 10:26:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5394A28C3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:26:22 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9B0E6E;
	Tue,  6 Jun 2023 03:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PP+oq9SiF87lBNI6tats4jiuMD4acRFhfDstaMQqkVg=; b=O86TfGr/JsGqU9JoWtD9rq4e0D
	WdU4OjJMOzATtHlzH3FDupVbiJ7nUkC6KSBCwa4M4K7GjTf37SSjKRKR+Eu4lKU/3EIZpxcNP+pO4
	JUCBx/hIz8FEY4gK+0vjBTzKwYzLC7gLew9VzYmYD9Rkh3BDb3JtitiGfZJqOPXvckqLFA8KGl3Gq
	I0hbxK3KLdfmiU6nLTIpOJn/bxOYBrW72lk2fo1evKo9BAshGWcmIgreYmGUZ2kSkEDrBX7Kf3Tyd
	dXMg6lTpW6nZwIZuRxXI2DNKE8/sp52vLFUBDIdzxXjdoYZu80iFbbrSyUTIcLHz5q+HgNvugkSOY
	H4JCJOIw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41340)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6TtH-0005Sx-DX; Tue, 06 Jun 2023 11:26:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6TtE-00073O-Cm; Tue, 06 Jun 2023 11:26:12 +0100
Date: Tue, 6 Jun 2023 11:26:12 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next 1/2] net: stmmac: Add PCS_LYNX as a dependency
 for the whole driver
Message-ID: <ZH8JxF+TNuX0C1vC@shell.armlinux.org.uk>
References: <20230606064914.134945-1-maxime.chevallier@bootlin.com>
 <20230606064914.134945-2-maxime.chevallier@bootlin.com>
 <889297a0-88c3-90df-7752-efa00184859@linux-m68k.org>
 <ZH78uGBfeHjI4Cdn@shell.armlinux.org.uk>
 <20230606121311.3cc5aa78@pc-7.home>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606121311.3cc5aa78@pc-7.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:13:11PM +0200, Maxime Chevallier wrote:
> Hello Geert, Russell,
> 
> On Tue, 6 Jun 2023 10:30:32 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Tue, Jun 06, 2023 at 10:29:20AM +0200, Geert Uytterhoeven wrote:
> > > 	Hi Maxime,
> > > 
> > > On Tue, 6 Jun 2023, Maxime Chevallier wrote:  
> > > > Although pcs_lynx is only used on dwmac_socfpga for now, the cleanup
> > > > path is in the generic driver, and triggers build issues for other
> > > > stmmac variants. Make sure we build pcs_lynx in all cases too, as for
> > > > XPCS.  
> > > 
> > > That seems suboptimal to me, as it needlesly increases kernel size for
> > > people who do not use dwmac_socfpga.  Hence I made an alternative patch:
> > > https://lore.kernel/org/7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be  
> > 
> > A better solution would be to re-architect the removal code so that
> > whatever creates the PCS is also responsible for removing it.
> > 
> > Also, dwmac_socfpga nees to be reorganised anyway, because it calls
> > stmmac_dvr_probe() which then goes on to call register_netdev(),
> > publishing the network device, and then after stmmac_dvr_probe(),
> > further device setup is done. As the basic driver probe flow should
> > be setup and then publish, the existing code structure violates that.
> > 
> 
> I agree that this solution is definitely suboptimal, I wanted mostly to get it
> fixed quickly as this breaks other stmmac variants.
> 
> Do we still go on with the current patch (as Geert's has issues) and then
> consider reworking dwmac_socfpga ?

As Geert himself mentioned, passed on from Arnd:
  As pointed out by Arnd, this doesn't work when PCS_LYNX is a loadable
  module and STMMAC is built-in:
  https://lore.kernel.org/r/11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com

So Geert's solution will just get rid of the build error, but leave the
Lynx PCS undestroyed. I take Geert's comment as a self-nack on his
proposed patch.

The changes are only in net-next at the moment, and we're at -rc5.
There's probably about 2.5 weeks to get this sorted before the merge
window opens.

So, we currently have your suggestion. Here's mine as an immediate
fix. This doesn't address all the points I've raised, but should
resolve the immediate issue.

Untested since I don't have the hardware... (the test build is
running):

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index e399fccbafe5..239c7e9ed41d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -494,6 +494,17 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static void socfpga_dwmac_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct phylink_pcs *pcs = priv->hw->lynx_pcs;
+
+	stmmac_pltfr_remove(pdev);
+
+	lynx_pcs_destroy(pcs);
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int socfpga_dwmac_resume(struct device *dev)
 {
@@ -565,7 +576,7 @@ MODULE_DEVICE_TABLE(of, socfpga_dwmac_match);
 
 static struct platform_driver socfpga_dwmac_driver = {
 	.probe  = socfpga_dwmac_probe,
-	.remove_new = stmmac_pltfr_remove,
+	.remove_new = socfpga_dwmac_remove,
 	.driver = {
 		.name           = "socfpga-dwmac",
 		.pm		= &socfpga_dwmac_pm_ops,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fa07b0d50b46..1801f8cc8413 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -940,9 +940,6 @@ static struct phylink_pcs *stmmac_mac_select_pcs(struct phylink_config *config,
 	if (priv->hw->xpcs)
 		return &priv->hw->xpcs->pcs;
 
-	if (priv->hw->lynx_pcs)
-		return priv->hw->lynx_pcs;
-
 	return NULL;
 }
 
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

