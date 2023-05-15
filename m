Return-Path: <netdev+bounces-2595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67EB07029CF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 665C01C20AA5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50238C2C8;
	Mon, 15 May 2023 10:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA4FC157
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7DBD4C4339C;
	Mon, 15 May 2023 10:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684144821;
	bh=brZAg4HC4B8ZDhw3xpm0FIi3+HADqPvhBqK024DoW0o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ifwiRrAzeEipVB0vFTCa9KtcHSjnF+4J8oeTfEF2v6F2idA2vJq4M3qFoNDe9vTWe
	 dGZbTNZkpKXUracoYTAZc+BJUV9xcr+giLRqPWC+ICn+O7d34kGKM3IQZ0LQA0y+Jk
	 6z36lh2asYcrEp0LP0KyEX0FF5RXNnNieajh4vsIVD9Ug/2N61M3wYIq6f27rPFbA+
	 V+G4des8h8s5fXPcTzVs8tRUm0i+xnRY/gW7aOFMqD01QCC1lQKjO6raOpZvaygHqn
	 3uawOnwLTQ2UHTZFpBo+VrfXGdZzNGiQFrrrpzoBPAETmdHFzpnj0qtppktJCKuNl8
	 ICrXXeD9pD1MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6059CE5421D;
	Mon, 15 May 2023 10:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-pf: mcs: Remove unneeded semicolon
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168414482139.15349.3751374833607911323.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 10:00:21 +0000
References: <20230515085645.43309-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230515085645.43309-1-yang.lee@linux.alibaba.com>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
 sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
 hkelam@marvell.com, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, abaci@linux.alibaba.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 May 2023 16:56:45 +0800 you wrote:
> ./drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:242:2-3: Unneeded semicolon
> ./drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:476:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4947
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: mcs: Remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/d1e4632b304c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



