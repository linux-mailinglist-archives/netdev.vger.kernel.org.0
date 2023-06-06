Return-Path: <netdev+bounces-8404-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E671C723F04
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58F991C20E4B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D6F2A70B;
	Tue,  6 Jun 2023 10:13:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F952A6EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:13:18 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5109196;
	Tue,  6 Jun 2023 03:13:16 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686046395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkbzNl9IfYOosD0T4TQy+60yjqN1tYHVKVHSGmiLV0c=;
	b=aMk1sVX/fUIK+Wi2jBs8zqKYJ/ZbN5EEiZR6MgBrlhP6ptv1tRLLheFfxr5A1NmcFN+S1q
	zCKpy2hNtEaMPiOiZfmq9nfxYUsrimD8UNSTtCwFnn5JByokY+YkdYNfgSqRBCLhI5DHqI
	ZidvgX5zn77fn3WLdZeY8HGDvsIXLsocSGL8Evunv1itRRlhr4GLLqWSoKXTvb4USc6awr
	vdwhf2lLhAkyQZgggss9qoyHSdOWH/tnPMeRN2RK9b5MTUkY5jqhJ6rfL/BYEwYZAhTaob
	8Z/vrpbdMEgr/pb4R8igKXW6CDD+TZItBVJj+ll7mjKa9vEGSEJztIL0gXYd+Q==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 840E56000A;
	Tue,  6 Jun 2023 10:13:12 +0000 (UTC)
Date: Tue, 6 Jun 2023 12:13:11 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, davem@davemloft.net,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com, Andrew Lunn
 <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Florian Fainelli
 <f.fainelli@gmail.com>, Heiner Kallweit <hkallweit1@gmail.com>, Vladimir
 Oltean <vladimir.oltean@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, Alexandre
 Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next 1/2] net: stmmac: Add PCS_LYNX as a dependency
 for the whole driver
Message-ID: <20230606121311.3cc5aa78@pc-7.home>
In-Reply-To: <ZH78uGBfeHjI4Cdn@shell.armlinux.org.uk>
References: <20230606064914.134945-1-maxime.chevallier@bootlin.com>
	<20230606064914.134945-2-maxime.chevallier@bootlin.com>
	<889297a0-88c3-90df-7752-efa00184859@linux-m68k.org>
	<ZH78uGBfeHjI4Cdn@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Geert, Russell,

On Tue, 6 Jun 2023 10:30:32 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Jun 06, 2023 at 10:29:20AM +0200, Geert Uytterhoeven wrote:
> > 	Hi Maxime,
> > 
> > On Tue, 6 Jun 2023, Maxime Chevallier wrote:  
> > > Although pcs_lynx is only used on dwmac_socfpga for now, the cleanup
> > > path is in the generic driver, and triggers build issues for other
> > > stmmac variants. Make sure we build pcs_lynx in all cases too, as for
> > > XPCS.  
> > 
> > That seems suboptimal to me, as it needlesly increases kernel size for
> > people who do not use dwmac_socfpga.  Hence I made an alternative patch:
> > https://lore.kernel/org/7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be  
> 
> A better solution would be to re-architect the removal code so that
> whatever creates the PCS is also responsible for removing it.
> 
> Also, dwmac_socfpga nees to be reorganised anyway, because it calls
> stmmac_dvr_probe() which then goes on to call register_netdev(),
> publishing the network device, and then after stmmac_dvr_probe(),
> further device setup is done. As the basic driver probe flow should
> be setup and then publish, the existing code structure violates that.
> 

I agree that this solution is definitely suboptimal, I wanted mostly to get it
fixed quickly as this breaks other stmmac variants.

Do we still go on with the current patch (as Geert's has issues) and then
consider reworking dwmac_socfpga ?

Maxime


