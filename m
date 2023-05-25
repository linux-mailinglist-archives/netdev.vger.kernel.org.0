Return-Path: <netdev+bounces-5315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E177E710C43
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F6B72814F8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B56FBE1;
	Thu, 25 May 2023 12:44:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E15D534
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:44:08 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4D29B;
	Thu, 25 May 2023 05:44:05 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685018644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feQW98atuVGJR2g0z3VlLS9I5fF0OgwIq8sXEMfFC28=;
	b=d2q9GAMDrDVfcZSPsOhWMuyyoXiCcYlXwPhHX3iLR80pY8cnEsNDVhuflsLM1uEys7WC3Q
	iEk/QVY+mnBmjDGSB3MW4JvhtiMokHVMM04OkEC1kzROmDIBxrLJlP+PlFHiSYfCN11lP3
	2DZhxM4AtrVs7tWNVv/SHhSJzPEX6xUHfNdmPwz/SfBJvgbQRTwHRGohnvU9gELWmwU/kP
	dTXDtu5DL7U2BInP48pr7dfIWP8EzQKQV8B75aGxMr1H4hLldw8CTJcb2PjHuBxIrkqnzw
	SVMspbG1cBVIBsd2YXO5IzXPlnai3Hu5uq+siLA5CoF22I2JX8K+jxyZgBe8rQ==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id A9647C0013;
	Thu, 25 May 2023 12:44:00 +0000 (UTC)
Date: Thu, 25 May 2023 14:43:59 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com, Andrew Lunn
 <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Florian Fainelli
 <f.fainelli@gmail.com>, Heiner Kallweit <hkallweit1@gmail.com>, Russell
 King <linux@armlinux.org.uk>, Vladimir Oltean <vladimir.oltean@nxp.com>,
 Ioana Ciornei <ioana.ciornei@nxp.com>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, Alexandre
 Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v2 1/4] net: mdio: Introduce a regmap-based
 mdio driver
Message-ID: <20230525144359.0cb16996@pc-7.home>
In-Reply-To: <ZG9AT4EeCmoyN5N2@corigine.com>
References: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
	<20230525101126.370108-2-maxime.chevallier@bootlin.com>
	<ZG9AT4EeCmoyN5N2@corigine.com>
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

Hello Simon,

On Thu, 25 May 2023 13:02:39 +0200
Simon Horman <simon.horman@corigine.com> wrote:

> On Thu, May 25, 2023 at 12:11:23PM +0200, Maxime Chevallier wrote:
> > There exists several examples today of devices that embed an
> > ethernet PHY or PCS directly inside an SoC. In this situation,
> > either the device is controlled through a vendor-specific register
> > set, or sometimes exposes the standard 802.3 registers that are
> > typically accessed over MDIO.
> > 
> > As phylib and phylink are designed to use mdiodevices, this driver
> > allows creating a virtual MDIO bus, that translates mdiodev register
> > accesses to regmap accesses.
> > 
> > The reason we use regmap is because there are at least 3 such
> > devices known today, 2 of them are Altera TSE PCS's, memory-mapped,
> > exposed with a 4-byte stride in stmmac's dwmac-socfpga variant, and
> > a 2-byte stride in altera-tse. The other one
> > (nxp,sja1110-base-tx-mdio) is exposed over SPI.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
> 
> ...
> 
> > +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> > +					  const struct
> > mdio_regmap_config *config) +{
> > +	struct mdio_regmap_config *mrc;
> > +	struct mii_bus *mii;
> > +	int rc;
> > +
> > +	if (!config->parent)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	mii = devm_mdiobus_alloc_size(config->parent,
> > sizeof(*mrc));
> > +	if (!mii)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	mrc = mii->priv;
> > +	memcpy(mrc, config, sizeof(*mrc));
> > +
> > +	mrc->regmap = config->regmap;
> > +	mrc->valid_addr = config->valid_addr;
> > +
> > +	mii->name = DRV_NAME;
> > +	strscpy(mii->id, config->name, MII_BUS_ID_SIZE);
> > +	mii->parent = config->parent;
> > +	mii->read = mdio_regmap_read_c22;
> > +	mii->write = mdio_regmap_write_c22;
> > +
> > +	if (config->autoscan)
> > +		mii->phy_mask = ~BIT(config->valid_addr);
> > +	else
> > +		mii->phy_mask = ~0UL;  
> 
> Hi Maxime,
> 
> phy_mask is a u32.
> But 0UL may be either 32 or 64 bits wide.

Right

> I think a better approach would be to use U32_MAX.

I guess ~0 would also work, and this would also align with what
fixed-phy and sfp do for their internal MDIO bus.

I'll fix that for next revision

Thanks,

Maxime
> > +
> > +	rc = devm_mdiobus_register(dev, mii);
> > +	if (rc) {
> > +		dev_err(config->parent, "Cannot register MDIO
> > bus![%s] (%d)\n", mii->id, rc);
> > +		return ERR_PTR(rc);
> > +	}
> > +
> > +	return mii;
> > +}
> > +EXPORT_SYMBOL_GPL(devm_mdio_regmap_register);
> > +
> > +MODULE_DESCRIPTION("MDIO API over regmap");
> > +MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
> > +MODULE_LICENSE("GPL");  


