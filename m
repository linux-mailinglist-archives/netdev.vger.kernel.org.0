Return-Path: <netdev+bounces-3180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95941705E7D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45F0A1C20B10
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142CF2101;
	Wed, 17 May 2023 04:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639082100
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 085C9C433EF;
	Wed, 17 May 2023 04:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684296020;
	bh=YxGEmu7bPO995GubobasqmD56YsH0z47jOm8RYTw+7A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Gsggi/fHT8AY7FpyqpnsbGkG2Vyal+EDs8Jfw7OoZhL1/18ZztHhT0nLmavphNPGK
	 2WElf4xIAONNNQvfPvVrMIr1xOilAVCMmXNEtusfVWBV5pCFJ5+BXcb0jzoPwRitCN
	 ynyELIrIRL2BBMi/qyQtB/WOtom3mzRF9F/xgBfoz1y+KPm/OWnXBBBgWbNDz/+s8w
	 T0Fc+AZ2Tmgm2+sxJLfaoVYBQO5rUMlDT+ze4CHcvoADT2w8YbDDtXKfxpET2enw5Q
	 tXx0X8MF9sg9kZLIS12gQrpNWo1/5eS0jwctJ4OaDom2MBtScJ8yaET4N1TGSoJw8q
	 9qAzmGUyO6Hkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA393C73FE2;
	Wed, 17 May 2023 04:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: Remove low_thresh in ip defrag"
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168429601989.23839.7156354882761941176.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 04:00:19 +0000
References: <20230517034112.1261835-1-kuba@kernel.org>
In-Reply-To: <20230517034112.1261835-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, angus.chen@jaguarmicro.com, idosch@idosch.org,
 syzbot+a5e719ac7c268e414c95@syzkaller.appspotmail.com,
 syzbot+a03fd670838d927d9cd8@syzkaller.appspotmail.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 May 2023 20:41:12 -0700 you wrote:
> This reverts commit b2cbac9b9b28730e9e53be20b6cdf979d3b9f27e.
> 
> We have multiple reports of obvious breakage from this patch.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Link: https://lore.kernel.org/all/ZGIRWjNcfqI8yY8W@shredder/
> Link: https://lore.kernel.org/all/CADJHv_sDK=0RrMA2FTZQV5fw7UQ+qY=HG21Wu5qb0V9vvx5w6A@mail.gmail.com/
> Reported-by: syzbot+a5e719ac7c268e414c95@syzkaller.appspotmail.com
> Reported-by: syzbot+a03fd670838d927d9cd8@syzkaller.appspotmail.com
> Fixes: b2cbac9b9b28 ("net: Remove low_thresh in ip defrag")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: Remove low_thresh in ip defrag"
    https://git.kernel.org/bpf/bpf-next/c/e7480a44d7c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



