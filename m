Return-Path: <netdev+bounces-11776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9137673466C
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B80681C20A47
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 13:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A161D1FB5;
	Sun, 18 Jun 2023 13:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFD21FB3
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E30DC433C8;
	Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687095620;
	bh=3ZfdVHlvWNk4QSgyJ/JM9b/WhTMvolihQEHxoUoZ6WI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FSNXu9IxG8HHlo3Q3bHO/+wYR6f5hmyP6lit/1BvnN/YM3KS0qhf8rSZxOCVyyZQX
	 A3biijXH0y+nklROibUpIKSx111pD/yby0WnMFStfqLkFzmmzqeidiBlPCSwKtRAVI
	 jGcxwtCh6US2vnyvgcto1NDqoc1u6YsRU0Ju/+N90ChKZknCNPAPNoOHD4U9XfaI+J
	 CpvdzCANorGsUEwftwsrbey7ZJxJPKb3pMIfubv3lXpJzQLP7i/TFh7f5YMY737UI4
	 VuIY6KGCuUqgg0dTIij7aYtH6ZOU9SdmYkuteL4RGcqZfgN9QWAO4ZfstQkxtOp365
	 BFwjWLrOgO1lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 507FAE49BBF;
	Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dt-bindings: net: phy: gpy2xx: more precise
 description
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168709562032.22941.5957562536489573890.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 13:40:20 +0000
References: <20230616-feature-maxlinear-dt-better-irq-desc-v1-1-57a8936543bf@kernel.org>
In-Reply-To: <20230616-feature-maxlinear-dt-better-irq-desc-v1-1-57a8936543bf@kernel.org>
To: Michael Walle <mwalle@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, andrew@lunn.ch, michael@walle.cc,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, robh@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 12:45:57 +0200 you wrote:
> Mention that the interrupt line is just asserted for a random period of
> time, not the entire time.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Michael Walle <mwalle@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] dt-bindings: net: phy: gpy2xx: more precise description
    https://git.kernel.org/netdev/net-next/c/264879fdbea0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



