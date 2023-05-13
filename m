Return-Path: <netdev+bounces-2365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E18CC70182E
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A89B91C20C2A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 16:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CEE63BD;
	Sat, 13 May 2023 16:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1581C10
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 16:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CF04C433D2;
	Sat, 13 May 2023 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683995421;
	bh=ly8za853lDrkm0I5eubVH/ZaXydTu5s8Guub+Dxgq6o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Z20xWioqZ8mJTXOn2JftDaFxJyllWZihJSJYwIRAvlJUfrR8/Qm5dpLvoqAgK67Ix
	 1lMiqRY7vYlEMnacz/2BN6iJ8pKmSPehukSXP2aN/Eg5GSavpXDjoF1cKkMhX2Vj6r
	 nclnMWuZPzpCkxLlHuXkWHnMfUfRTSxaBlqZz8aLSEvnEvmVD9ghg5NZt5bJq0Wi5d
	 tzUrPc44AOscTJszeW1tlHvUskponGapnjfWmr2X0Ujg0zUq1cTUbfvulTjk2wJZAX
	 qA9q/CpA9Mqkr2ho3aXOsWOhSI31QQDLDsEpKDT5qOsyr6t9TW9fYHdrXXpPXNkJgI
	 rNFAYRMYVXIDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57C15E450BA;
	Sat, 13 May 2023 16:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: hns3: There are some bugfixes for the HNS3
 ethernet driver
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168399542135.7347.589985237371368267.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 16:30:21 +0000
References: <20230512100014.2522-1-lanhao@huawei.com>
In-Reply-To: <20230512100014.2522-1-lanhao@huawei.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 huangguangbin2@huawei.com, simon.horman@corigine.com, shaojijie@huawei.com,
 chenhao418@huawei.com, shenjian15@huawei.com, liuyonglong@huawei.com,
 wangjie125@huawei.com, yuanjilin@cdjrlc.com, cai.huoqing@linux.dev,
 xiujianfeng@huawei.com, tanhuazhong@huawei.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 18:00:10 +0800 you wrote:
> There are some bugfixes for the HNS3 ethernet driver.
> Patch#1 fix output information incomplete for dumping tx queue info
>  with debugfs.
> Patch#2 fix sending pfc frames after reset issue.
> Patch#3 fix reset delay time to avoid configuration timeout.
> Patch#4 fix reset timeout when enable full VF.
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: hns3: fix output information incomplete for dumping tx queue info with debugfs
    https://git.kernel.org/netdev/net/c/89f6bfb07118
  - [net,2/4] net: hns3: fix sending pfc frames after reset issue
    https://git.kernel.org/netdev/net/c/f14db0706472
  - [net,3/4] net: hns3: fix reset delay time to avoid configuration timeout
    https://git.kernel.org/netdev/net/c/814d0c786068
  - [net,4/4] net: hns3: fix reset timeout when enable full VF
    https://git.kernel.org/netdev/net/c/6b45d5ff8c2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



