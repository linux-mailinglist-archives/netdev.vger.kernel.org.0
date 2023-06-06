Return-Path: <netdev+bounces-8462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A14F5724315
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ADD22816A3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98F337B86;
	Tue,  6 Jun 2023 12:52:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF26C37B60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:52:03 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF771731;
	Tue,  6 Jun 2023 05:51:29 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686055851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vPlrY3WjDY7pFW/27RY/fg0u0Ufgp/HpEKChnaNVaNo=;
	b=WtSRmpezbXnrGJhJIzu7g1Jf7sUfirjn2Sx/wTtuHm+1CFCn0L8nfIoZU1LeRZgY387uDi
	EfWWXvnWDucY3AsQaXso6txoCy/SNcy8eUwu73eUwE3o+pqdg9yC3DpKyisoAemNUVUoHS
	y834jecnDNCTIdmEDxCioxJZ4GgZG8gOy3SqCArK3YEaEqX/OYti1UI3RaeZ3c+hPyGbtL
	ZYrKf79UvScvA8tJ4zXXLg2g8uKvZO8Mnu9r/uJ4byT8lWHSIVvRZxbGBLWCivNPJtwFPM
	vszTHIETNYRH6txrFEQaln3FlAz9j39pJEZFG3i4LkhyQTcmZtYg7KXSlHl26g==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6719DC0006;
	Tue,  6 Jun 2023 12:50:47 +0000 (UTC)
Date: Tue, 6 Jun 2023 14:50:46 +0200
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
Message-ID: <20230606145046.7181bfae@pc-7.home>
In-Reply-To: <ZH8N+GtRFcDV4eaI@shell.armlinux.org.uk>
References: <20230606064914.134945-1-maxime.chevallier@bootlin.com>
	<20230606064914.134945-2-maxime.chevallier@bootlin.com>
	<889297a0-88c3-90df-7752-efa00184859@linux-m68k.org>
	<ZH78uGBfeHjI4Cdn@shell.armlinux.org.uk>
	<20230606121311.3cc5aa78@pc-7.home>
	<ZH8JxF+TNuX0C1vC@shell.armlinux.org.uk>
	<CAMuHMdWnqmwT_rEe5G4e+yZYAeTQxjjE=Xqq7R6No9SAF16sdg@mail.gmail.com>
	<ZH8N+GtRFcDV4eaI@shell.armlinux.org.uk>
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

On Tue, 6 Jun 2023 11:44:08 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Jun 06, 2023 at 12:35:23PM +0200, Geert Uytterhoeven wrote:
> > Hi Russell,
> >   
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index fa07b0d50b46..1801f8cc8413 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -940,9 +940,6 @@ static struct phylink_pcs *stmmac_mac_select_pcs(struct phylink_config *config,
> > >         if (priv->hw->xpcs)
> > >                 return &priv->hw->xpcs->pcs;
> > >
> > > -       if (priv->hw->lynx_pcs)
> > > -               return priv->hw->lynx_pcs;
> > > -
> > >         return NULL;
> > >  }  
> > 
> > I think the above hunk is wrong, and should be replaced by a removal
> > of the call to lynx_pcs_destroy()?  
> 
> Indeed, and wrong file too. Thanks for spotting, I think we spotted
> the mistake at almost the same time. Replacement patch sent.
> 
> It'd be good to have the patch thoroughly reviewed to make sure I
> haven't missed anything else, bearing in mind that I don't know this
> driver inside out and don't have the hardware.

I will give it a try righ-away,

Thanks,

Maxime

> Thanks.
> 


