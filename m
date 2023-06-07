Return-Path: <netdev+bounces-8830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EABAC725E28
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 552501C20B91
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CCB34443;
	Wed,  7 Jun 2023 12:11:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D7530B90
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:11:32 +0000 (UTC)
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793731FCF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:11:03 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686139862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rp0K8640Fk4khJPMOcvKgtsAsCpZyigTf7DSBqpS3v4=;
	b=G3FrJzFOwfnQ5wmBhycJ6WPzwdNsdBq9oKtRUet6SUDSAld2QDIlzSaMkC/GXQ5BKDm/BK
	X/Oq+liPK4XThP+84YW6TSrDAQgOhAUJt6LAbUI048SjrZCg+f+JQ5M0wNcJGXn7kiBc3a
	c18ZzbrSkl/8421fxDPKKglI2qfKaFcaHA2bEYKHY2hOaW3OJJot0eJnMSVEi9qorSgw9e
	M2RdOvZmCCgmF/s+/LZHAxBzJoTy3Oqi/i/ass+6XHxkXXyFzZaTBksMRPOKLha1mZvSxT
	z69Aybw49KkEppjDmtt9ckLNP2YpwjFsIdtfJj/FCOHlNaAwo1DCisERBFz/hg==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id F2C3A1C0005;
	Wed,  7 Jun 2023 12:10:58 +0000 (UTC)
Date: Wed, 7 Jun 2023 16:02:19 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Feiyang Chen <chenfeiyang@loongson.cn>, <peppe.cavallaro@st.com>,
 <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
 <netdev@vger.kernel.org>, <loongson-kernel@lists.loongnix.cn>,
 <chris.chenfeiyang@gmail.com>, Yanteng Si <siyanteng@loongson.cn>
Subject: Re: [PATCH] net: stmmac: Fix stmmac_mdio_unregister() build errors
Message-ID: <20230607160219.7dd5e867@pc-7.home>
In-Reply-To: <ZIBwPc95jooavl86@boxer>
References: <20230607093440.4131484-1-chenfeiyang@loongson.cn>
	<ZIBwPc95jooavl86@boxer>
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

Hello,

On Wed, 7 Jun 2023 13:55:41 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Wed, Jun 07, 2023 at 05:34:40PM +0800, Feiyang Chen wrote:
> > When CONFIG_PCS_LYNX is not set, lynx_pcs_destroy() will not be
> > exported. Add #ifdef CONFIG_PCS_LYNX around that code to avoid
> > build errors like these:
> > 
> > ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
> > stmmac_mdio.c:(.text+0x1440): undefined reference to `lynx_pcs_destroy'
> > 
> > Reported-by: Yanteng Si <siyanteng@loongson.cn>
> > Fixes: 5d1f3fe7d2d5 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
> > Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > index c784a6731f08..c1a23846a01c 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > @@ -665,8 +665,10 @@ int stmmac_mdio_unregister(struct net_device *ndev)
> >  	if (priv->hw->xpcs)
> >  		xpcs_destroy(priv->hw->xpcs);
> >  
> > +#ifdef CONFIG_PCS_LYNX  
> 
> wouldn't it be better to provide a stub of lynx_pcs_destroy() for
> !CONFIG_PCS_LYNX ? otherwise all of the users will have to surrounded with
> this ifdef.

I just sent another fix that has been in the works since yesterday :

https://lore.kernel.org/netdev/20230607135941.407054-1-maxime.chevallier@bootlin.com/T/#t

It uses a better solution of only using pcs_lynx-related helpers on dwmac_socfpga,
as this is the only stmmac variant that needs this PCS.

Sorry for the mess,

Maxime

> >  	if (priv->hw->lynx_pcs)
> >  		lynx_pcs_destroy(priv->hw->lynx_pcs);
> > +#endif
> >  
> >  	mdiobus_unregister(priv->mii);
> >  	priv->mii->priv = NULL;
> > -- 
> > 2.39.3
> > 
> >   


