Return-Path: <netdev+bounces-8378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0456723D76
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C88628160E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D42E294C8;
	Tue,  6 Jun 2023 09:30:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13438125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:30:45 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6E4E5F;
	Tue,  6 Jun 2023 02:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bX3B+1lGIzcbVKfEHUtN8MUbXcfS9WOFyXQZwIDBExg=; b=airJ5LgE8sLzCto3YG0rNnzbDT
	wHfh1Yn2sZQC2ZvFGnCWeyz1D3DYJoMe6cuQZycBlKJ9o2WWpuxbzZfSLGFOIa7ZTYKsSTqGm9w6K
	axLGxhjDbyxQNsQMRSJcEW/U8ZVO+qfNtfES5A8l5MNm9nCqTSEzG0cn4SVGUEfcHD3H6f2LYRO0s
	MtPjqphT+cEgtVi/heGupqlRTLgc56a2cjbXo/j9PFRo8748Prpt4xcMRijl3R9utJR/1O0/GCnIb
	GyV+iv3vN5+PF+decbKdjm8bE6zotFRFRnt3x7OqCGmJZ8SpzuAXvcRoIGhw536861xjQBWYjfe9Y
	uSLLYlLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34232)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6T1Q-0005NP-Tg; Tue, 06 Jun 2023 10:30:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6T1M-00070y-6f; Tue, 06 Jun 2023 10:30:32 +0100
Date: Tue, 6 Jun 2023 10:30:32 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>, davem@davemloft.net,
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
Message-ID: <ZH78uGBfeHjI4Cdn@shell.armlinux.org.uk>
References: <20230606064914.134945-1-maxime.chevallier@bootlin.com>
 <20230606064914.134945-2-maxime.chevallier@bootlin.com>
 <889297a0-88c3-90df-7752-efa00184859@linux-m68k.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <889297a0-88c3-90df-7752-efa00184859@linux-m68k.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 10:29:20AM +0200, Geert Uytterhoeven wrote:
> 	Hi Maxime,
> 
> On Tue, 6 Jun 2023, Maxime Chevallier wrote:
> > Although pcs_lynx is only used on dwmac_socfpga for now, the cleanup
> > path is in the generic driver, and triggers build issues for other
> > stmmac variants. Make sure we build pcs_lynx in all cases too, as for
> > XPCS.
> 
> That seems suboptimal to me, as it needlesly increases kernel size for
> people who do not use dwmac_socfpga.  Hence I made an alternative patch:
> https://lore.kernel/org/7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be

A better solution would be to re-architect the removal code so that
whatever creates the PCS is also responsible for removing it.

Also, dwmac_socfpga nees to be reorganised anyway, because it calls
stmmac_dvr_probe() which then goes on to call register_netdev(),
publishing the network device, and then after stmmac_dvr_probe(),
further device setup is done. As the basic driver probe flow should
be setup and then publish, the existing code structure violates that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

