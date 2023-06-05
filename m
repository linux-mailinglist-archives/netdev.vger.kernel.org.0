Return-Path: <netdev+bounces-8157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10EBE722EE4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C6802813B3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301831F94B;
	Mon,  5 Jun 2023 18:46:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFAF20EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5104C433D2;
	Mon,  5 Jun 2023 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685990788;
	bh=FoDr5w3gdB61Azw86AvGtNPjt2Cdolk3qbB4WzHGalQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IW4HdDjW3vMaXCOSzfFWuU8epkHVPb52t8aNv5uQxG3dvkS5PQX+TAuLnGRPwmCFU
	 qM1W9CISuOsOtzF9hTslqlJfnQeXhZ29FZYrlZeJfRnpSPkTrVXfZ7HQtpV0bpVvZ6
	 dUXlIbIxe3QV2zZfsKyDKVo4fqvGSuJSXl4KoUN17RM5yT2Q5dh9iHYxyeQ/888ZIR
	 eBK43FU3J2A8ncRxsIvm1yy5CPq/oBbA4+zVpsGiOPEkElNvAj+KHIQJvSZAAqwEhJ
	 W+ZDHymL3WiK/9b9yHP2PpybWhjS6jJLLR9PGlGVdJAHLJea6yrP+hakyTs9r0bse2
	 eN6yqevoQYSXQ==
Date: Mon, 5 Jun 2023 11:46:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
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
Message-ID: <20230605114626.188c357f@kernel.org>
In-Reply-To: <20230605142039.3f8d1530@pc-7.home>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
	<168596102478.26938.1530517069555858195.git-patchwork-notify@kernel.org>
	<20230605142039.3f8d1530@pc-7.home>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jun 2023 14:20:39 +0200 Maxime Chevallier wrote:
> Thanks for applying the patch, however as mentionned (maybe not
> stressed enough in the cover) this series depends on a patch that went
> through the regmap tree :
> 
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git/commit/?id=e12ff28764937dd58c8613f16065da60da149048
> 
> How can we proceed on that matter ?

I don't see a great solution, Mark already applied the change and 
so did Dave. Don't think we can put them on stable branches now..

Only altera and stmmac-sogfpga are going to break?
Maybe we're close enough to the merge window to put our heads 
in the sand and wait?

