Return-Path: <netdev+bounces-3331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 771637067A3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DBCF1C20EC7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7072331103;
	Wed, 17 May 2023 12:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110FF2C757
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1790C4339C;
	Wed, 17 May 2023 12:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684325422;
	bh=DGwZ31ewz3iZy+bN5cHOTTQlTzO3tq2EEIqygqEMHpc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pEKCKpRz4A9B/BJTkW3/C9M2X3L89eArCswRne63auv9SEs7scRv3CyQswhqdD1tS
	 0TZayz1DbLH3rlWvEfDrDrwIIzuUMVV9n6MQuwIf9KFl9wP7hCfgZYnecvTT7cMDzA
	 iG9ksP3mRa8+BS2YiarFJ4BwOmb4p5Qr6FHfQgcLMNNtYBrm/c861EHddxWDmFX9pA
	 cHKRg0FVVdzlM8T0FX0DDVETzGJsVs8ibm4VfPvoN5p6d6LKxJ/3aqdCUwKZYsPIzv
	 3MzgP6kbo+Ss9KckdDVoGfUtyq6fllW4UMjstraHckxBYSKLy+oq3lS8DE7grx4GrO
	 ZEl5eOjg3/Pkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A529DC4166F;
	Wed, 17 May 2023 12:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next v5] dt-bindings: net: nxp,sja1105: document
 spi-cpol/cpha
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168432542266.5953.1478389436139674022.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 12:10:22 +0000
References: <20230517082602.14387-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230517082602.14387-1-krzysztof.kozlowski@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, conor.dooley@microchip.com,
 vladimir.oltean@nxp.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 May 2023 10:26:02 +0200 you wrote:
> Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
> SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:
> 
>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
> 
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
    https://git.kernel.org/netdev/net-next/c/af2eab1a8243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



