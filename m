Return-Path: <netdev+bounces-5775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB674712B62
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1D391C2101B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA22628C10;
	Fri, 26 May 2023 17:07:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA3B2CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:07:15 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265D6F2;
	Fri, 26 May 2023 10:07:12 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685120831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLtQUPZvC6LXco0Vx6AbaJ5HU7nv5vKBXlxIPke6z2Y=;
	b=CECpw3jEVwuuKSlFLCkzKlgJtZIWmEHnjED4pWNOGYwHBJrqO6sf5p7UDG690IZ1rQOkIk
	uccVNqiMPwntgpaPwZrWVQISP02SBSYaGartrfM6cueTkfN9GMtZEqEANkdiQYdd+5Wog9
	kI2MVxiSKMClhk5O75rUDMNkZwLbkIGwyuJu2/UgBjfcbkX2uMZBJ7uWfIJFr49mDsDB/p
	O1UsRMlMM8oQnUc2zpDPMgz2Hvo3ide+77FwvMNanOSpJq11QPQuu18vB12u6mvsxlpr64
	T3hXEE75kq4tTx2hKBRUXFNCH0bnF+GwYi76S2yoJuQBlOxNM0LAgzOKdvZ3yg==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id CD8A860006;
	Fri, 26 May 2023 17:07:08 +0000 (UTC)
Date: Fri, 26 May 2023 19:07:07 +0200
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
Subject: Re: [PATCH net-next v3 3/4] net: pcs: Drop the TSE PCS driver
Message-ID: <20230526190707.217c5bde@pc-7.home>
In-Reply-To: <ZHBxH/O/NtssUZTF@corigine.com>
References: <20230526074252.480200-1-maxime.chevallier@bootlin.com>
	<20230526074252.480200-4-maxime.chevallier@bootlin.com>
	<ZHBxH/O/NtssUZTF@corigine.com>
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

On Fri, 26 May 2023 10:43:11 +0200
Simon Horman <simon.horman@corigine.com> wrote:

> On Fri, May 26, 2023 at 09:42:51AM +0200, Maxime Chevallier wrote:
> > Now that we can easily create a mdio-device that represents a
> > memory-mapped device that exposes an MDIO-like register layout, we
> > don't need the Altera TSE PCS anymore, since we can use the Lynx
> > PCS instead.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > ---
> > V2->V3 : No changes
> > V1->V2 : No changes
> > 
> >  MAINTAINERS                      |   7 --
> >  drivers/net/pcs/Kconfig          |   6 --
> >  drivers/net/pcs/Makefile         |   1 -
> >  drivers/net/pcs/pcs-altera-tse.c | 160
> > ------------------------------- include/linux/pcs-altera-tse.h   |
> > 17 ---- 5 files changed, 191 deletions(-)  
> 
> Less is more.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 

Thanks ! Also kudos to Russell who spotted the similarities between the
TSE and Lynx PCS in the first place, allowing for this driver to be
dropped :)

