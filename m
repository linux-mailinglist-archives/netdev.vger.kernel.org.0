Return-Path: <netdev+bounces-8851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0331726086
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC03F2812B1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC8B31EE9;
	Wed,  7 Jun 2023 13:07:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F308839
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:07:48 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357541FFE;
	Wed,  7 Jun 2023 06:07:41 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686143259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4KeBVX9fh5BWILoxWykoaXgMPfgR3e6KlRWLXnIjh8=;
	b=IFlntwt9MiUqyl4gGig/vm8dRCZC9qibzaOkFWfioFD80JRYgMO4LmWNjxgQr50TutwLfL
	05B0xsTMGMwWVjpZwuPpuxLAhlsUTUbqZcsWhTbx+Uyyqp38lAo/JTMwg/lo1qSo7JjoEq
	G/RmfirGiBqZE4bbsfw5J2R8aC3PzSraNp7N3wcWT4uy9DHcTyYMvf68IZ5rBX7ohTInTv
	UtIG93n4Pgd+bH2Dr73zbIQWO8tNPaRKTa0Op7fePe9XPgDMhJRfV4AiPgxOs8j1JR8dHA
	AdkROzL0P3ToQ5P822B9nOrlM3vmH7IseBuir7V4Qzsqm3CnoYtTCS3jjLWGKA==
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
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id B1E1920012;
	Wed,  7 Jun 2023 13:07:32 +0000 (UTC)
Date: Wed, 7 Jun 2023 16:54:09 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
 thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski
 <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, Heiner
 Kallweit <hkallweit1@gmail.com>, Vladimir Oltean <vladimir.oltean@nxp.com>,
 Ioana Ciornei <ioana.ciornei@nxp.com>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, Alexandre
 Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Simon Horman <simon.horman@corigine.com>, Maciej
 Fijalkowski <maciej.fijalkowski@intel.com>, Feiyang Chen
 <chenfeiyang@loongson.cn>
Subject: Re: [PATCH net-next v4 5/5] net: dwmac_socfpga: initialize local
 data for mdio regmap configuration
Message-ID: <20230607165409.7fddd49a@pc-7.home>
In-Reply-To: <ZIB306nKrhiru0hJ@shell.armlinux.org.uk>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
	<20230607135941.407054-6-maxime.chevallier@bootlin.com>
	<ZIB306nKrhiru0hJ@shell.armlinux.org.uk>
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
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 7 Jun 2023 13:28:03 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Wed, Jun 07, 2023 at 03:59:41PM +0200, Maxime Chevallier wrote:
> > @@ -447,19 +446,22 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
> >  		struct mdio_regmap_config mrc;
> >  		struct regmap *pcs_regmap;
> >  		struct mii_bus *pcs_bus;
> >    
> ...
> > +		memset(&mrc, 0, sizeof(mrc));  
> ...
> >  		mrc.parent = &pdev->dev;
> >  		mrc.valid_addr = 0x0;
> > +		mrc.autoscan = false;  
> 
> Isn't this covered by the memset() ?

I have the same answer as for the above. It's redundant, but I don't
think there's any harm having it set explicitely ?

Maxime

