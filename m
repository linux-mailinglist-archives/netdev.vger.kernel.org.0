Return-Path: <netdev+bounces-8274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6667237DF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4960B1C20D20
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 06:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEC92109;
	Tue,  6 Jun 2023 06:39:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03288813
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:39:36 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7717AC7;
	Mon,  5 Jun 2023 23:39:32 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686033570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r3h2rz63OfzutXB59RZcgO/gJzpMB99B07DK2JRkoIg=;
	b=BHCkoLX5X22HoXzHGb8MujppnFnDTWFmr8poVY6B+5CL+Q+Z2ybX6OUWmQicxCJBRYfWoi
	9EnPsX6jCAajf7PbC/053GAthHJh0B9zPk1ZinplqxqpkvqvkrqZKmmRXuzHgVPa5444sx
	DKm3QVtUJLO7PD6G7jQDpv10RyzEUnFQcdoTEhoYL7wkV5wmyaffoZKeyKmoagdx+d4BEW
	0N5v5+OqH9VoEABYsWcGXiLaq39uOe+gRKCzxHsdFjuKCWHzp5ckilEYQwbIqvGJKcVlSt
	vxFPvuDZpAcsuyshfUg5Js/L5x47AI5MrrbGZJ1RC165WIQrh6XgwWhHOFawug==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 08A1740006;
	Tue,  6 Jun 2023 06:39:26 +0000 (UTC)
Date: Tue, 6 Jun 2023 08:39:25 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
 thomas.petazzoni@bootlin.com, andrew@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
 linux@armlinux.org.uk, vladimir.oltean@nxp.com, ioana.ciornei@nxp.com,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, mcoquelin.stm32@gmail.com,
 joabreu@synopsys.com, alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
 simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 0/4] net: add a regmap-based mdio driver and
 drop TSE PCS
Message-ID: <20230606083925.2a543bc6@pc-7.home>
In-Reply-To: <20230605114626.188c357f@kernel.org>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
	<168596102478.26938.1530517069555858195.git-patchwork-notify@kernel.org>
	<20230605142039.3f8d1530@pc-7.home>
	<20230605114626.188c357f@kernel.org>
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

Hello Jakub,

On Mon, 5 Jun 2023 11:46:26 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 5 Jun 2023 14:20:39 +0200 Maxime Chevallier wrote:
> > Thanks for applying the patch, however as mentionned (maybe not
> > stressed enough in the cover) this series depends on a patch that went
> > through the regmap tree :
> > 
> > 
> >  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?id=e12ff28764937dd58c8613f16065da60da149048
> > 
> > How can we proceed on that matter ?  
> 
> I don't see a great solution, Mark already applied the change and 
> so did Dave. Don't think we can put them on stable branches now..
> 
> Only altera and stmmac-sogfpga are going to break?
> Maybe we're close enough to the merge window to put our heads 
> in the sand and wait?

only these two should, indeed. I'll still followup with some fixes for
kbuild issues still.

Thanks,

Maxime

