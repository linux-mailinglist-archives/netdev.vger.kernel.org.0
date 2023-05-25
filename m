Return-Path: <netdev+bounces-5314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6FE710C38
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3462E1C20EB5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB4AFBE0;
	Thu, 25 May 2023 12:41:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7BDF52
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 12:41:30 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096E69B;
	Thu, 25 May 2023 05:41:27 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685018486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LATq8y11VRK+GDnUyeoDnyHykvQtZzA+fhIGVKjKY/U=;
	b=OGofsE+mR6iQKrs/9UPk/kfzFlZ3sYngSppWGdbBDEN8LMeuuBybN3pbzUOaLcG8BOVY50
	TAuIl6LQPms5JDcysh30Vv7UULvEuwIbFjnaiCyKyCV7u8OXbUNwJ6up6P8zquak+GVywq
	kr/RCiEH0Di34lJxSHTINUqeOkldbzSHoGWllzmKKvCoEh7GLPVEVVQcuQVRB5d5ZFbrk2
	yPo88m59D6AQdd8LOoXAkps0ThJVqa/tH4eowLWICFcVoBW62NDHZP/YPlLT74SNWy19Ee
	lvu37L8+0b4ZpgLOwhByES6qIRs3fNSOb0DkjWrzyWLRomw4fC7xBf9n4tWguA==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 70B8660007;
	Thu, 25 May 2023 12:41:23 +0000 (UTC)
Date: Thu, 25 May 2023 14:41:22 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
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
 <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v2 1/4] net: mdio: Introduce a regmap-based
 mdio driver
Message-ID: <20230525144122.3d2d8aba@pc-7.home>
In-Reply-To: <ZG9CajddFYKAFlO/@shell.armlinux.org.uk>
References: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
	<20230525101126.370108-2-maxime.chevallier@bootlin.com>
	<ZG9CajddFYKAFlO/@shell.armlinux.org.uk>
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

Hello Russell,

On Thu, 25 May 2023 12:11:38 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Thu, May 25, 2023 at 12:11:23PM +0200, Maxime Chevallier wrote:
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
> 
> You have just memcpy'd everything from config into mrc. Doesn't this
> already include "regmap" and "valid_addr" ?

Oh right... good catch, thanks !

> However, these are the only two things used, so does it really make
> sense to allocate the full mdio_regmap_config structure, or would a
> smaller data structure (of one pointer and one u8) be more
> appropriate?
> 

You are correct, other fields are unused so I'll use a new struct for
the mii->priv field.

Thank you for reviewing,

Best regards,

Maxime

