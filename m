Return-Path: <netdev+bounces-1359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B236FD95F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0C152813F0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B60112B90;
	Wed, 10 May 2023 08:30:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE795668
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22D93C4339C;
	Wed, 10 May 2023 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683707423;
	bh=AN+Eo+qzhyw47/MyXdApQCMAYN3iMem6tBDKDVm5ntE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b8T6Nh8ELnyMMcbsAIKZbbujBuDPDMFknIFXWChTjwVxuS0RKXujkLgSeDxjMU6ty
	 PxcJ3hwdhG7odmGe7GH0SQ9w94dK8rLzFSR7WtLAsACrEcLlE/28y82NdQLtB1I+Of
	 LaJ7Za4bsQqd5u0z+sKOudyFD8NwJfBMsmBX3/qc1PLvElfL+bYUMsQAWuf3pOY7Gv
	 ISQvP7r45zA1pVvBP63ntWISnPJ8hkCIG0lfjFY0aqQaxnrKpBApCxyd99ZDvyBN5i
	 Kh5O4/NfgBlGznsyFyFsNv1BJKRLivINOERR4bHjYFD2vj0x5Z2F2QX0G/Kp0vfGOh
	 6avUcX/C1/rBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 053A1E270C4;
	Wed, 10 May 2023 08:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix NULL pointer dereference
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370742301.8895.5605086676316626500.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 08:30:23 +0000
References: <ZFmfxpsd8Fiqc7K_@pidgin.makrotopia.org>
In-Reply-To: <ZFmfxpsd8Fiqc7K_@pidgin.makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
 Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 9 May 2023 03:20:06 +0200 you wrote:
> Check for NULL pointer to avoid kernel crashing in case of missing WO
> firmware in case only a single WEDv2 device has been initialized, e.g. on
> MT7981 which can connect just one wireless frontend.
> 
> Fixes: 86ce0d09e424 ("net: ethernet: mtk_eth_soc: use WO firmware for MT7981")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix NULL pointer dereference
    https://git.kernel.org/netdev/net/c/7c83e28f1083

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



