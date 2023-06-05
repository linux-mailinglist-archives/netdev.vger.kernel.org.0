Return-Path: <netdev+bounces-7984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2AE72256E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D96CE28110F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F30218B03;
	Mon,  5 Jun 2023 12:20:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02804525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:20:47 +0000 (UTC)
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF29E9C;
	Mon,  5 Jun 2023 05:20:44 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685967643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nMy8jOn3QwsSSA0c+m8gW2VcF2TjCe8+rIvNflPEe5k=;
	b=Bbjt27xU7k12RxSL8+07oLlYoRcikhvnrVDE5aZOhSaz1GdvhkP2zA/wu+rokBrIgtSFaM
	pYZINe36JMe+jVf40wve8mh1Jly7o1wkPMRg1/RAlFuLa1w7tZHP+o24TYkQoDqom/bFdA
	DaJ9zp7qgfYrzUaaS1p5CO58HIJxaLSJuKFJhEeJixkN6nKsF2CbF2dO+y2DEPb8RezTgb
	dXwKsoOz6awL5ovsMiD/JvzRpMosXOKoVYoQp4tDtBNxq240+cggA5uRm2UBxif7zd650x
	xlA6Oocq5hnD9szrTh5IFatkBkVWDAw/dgbgTn1jq2HePcsaFO7Gss883c9Pmg==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7079B24000A;
	Mon,  5 Jun 2023 12:20:40 +0000 (UTC)
Date: Mon, 5 Jun 2023 14:20:39 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: patchwork-bot+netdevbpf@kernel.org
Cc: broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
 thomas.petazzoni@bootlin.com, andrew@lunn.ch, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com, f.fainelli@gmail.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk, vladimir.oltean@nxp.com,
 ioana.ciornei@nxp.com, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, mcoquelin.stm32@gmail.com,
 joabreu@synopsys.com, alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
 simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 0/4] net: add a regmap-based mdio driver and
 drop TSE PCS
Message-ID: <20230605142039.3f8d1530@pc-7.home>
In-Reply-To: <168596102478.26938.1530517069555858195.git-patchwork-notify@kernel.org>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
	<168596102478.26938.1530517069555858195.git-patchwork-notify@kernel.org>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Maintainers,

Thanks for applying the patch, however as mentionned (maybe not
stressed enough in the cover) this series depends on a patch that went
through the regmap tree :


 https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?id=e12ff28764937dd58c8613f16065da60da149048

How can we proceed on that matter ?

Thanks,

Maxime

On Mon, 05 Jun 2023 10:30:24 +0000
patchwork-bot+netdevbpf@kernel.org wrote:

> Hello:
> 
> This series was applied to netdev/net-next.git (main)
> by David S. Miller <davem@davemloft.net>:
> 
> On Thu,  1 Jun 2023 16:14:50 +0200 you wrote:
> > Hello everyone,
> > 
> > This is the V4 of a series that follows-up on the work [1] aiming
> > to drop the altera TSE PCS driver, as it turns out to be a version
> > of the Lynx PCS exposed as a memory-mapped block, instead of living
> > on an MDIO bus.
> > 
> > One step of this removal involved creating a regmap-based mdio
> > driver that translates MDIO accesses into the actual underlying bus
> > that exposes the register. The register layout must of course match
> > the standard MDIO layout, but we can now account for differences in
> > stride with recent work on the regmap subsystem [2].
> > 
> > [...]  
> 
> Here is the summary with links:
>   - [net-next,v4,1/4] net: mdio: Introduce a regmap-based mdio driver
>     https://git.kernel.org/netdev/net-next/c/642af0f92cbe
>   - [net-next,v4,2/4] net: ethernet: altera-tse: Convert to
> mdio-regmap and use PCS Lynx
> https://git.kernel.org/netdev/net-next/c/db48abbaa18e
>   - [net-next,v4,3/4] net: pcs: Drop the TSE PCS driver
>     https://git.kernel.org/netdev/net-next/c/196eec4062b0
>   - [net-next,v4,4/4] net: stmmac: dwmac-sogfpga: use the lynx pcs
> driver https://git.kernel.org/netdev/net-next/c/5d1f3fe7d2d5
> 
> You are awesome, thank you!


