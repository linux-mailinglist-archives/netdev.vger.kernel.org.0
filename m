Return-Path: <netdev+bounces-4062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBE170A5C6
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 07:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0CDE1C20B0D
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 05:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B126E801;
	Sat, 20 May 2023 05:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2564C7F8
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1277C4339B;
	Sat, 20 May 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684561819;
	bh=QtWTqMs4G/reV+d+uLzdoCxVPn+JvO8Pu6WwVR0iHK4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FEkelctngyEvL4+s+vIzXYvC2ECBgxkw2bT7+QEMCqCeMWCmOL/1q7svsSgmYzzDY
	 O7N8zxVFDvnNNqrB15hindmpZEkd+ZxqcpDxJhelVLR1RXUPJXOmttdCGc+8roEIxs
	 2/Af5szvz6j0sG7R0j0Z4xNBT4mQhDKD0t1Jv/8GKSMdLcuP2lGNMLXy5wVQzJNvqw
	 4RRrGFwpau3X43Q36u553lnRRZ3OA33kD76peoZtKWUWLAQ4i9Ouq5Gj3ivxAncMUk
	 zX84Izlv7BBLlxXZuDohDbxYOkOFBJT7EgLfUBhygcRuZLCOPDhw2uN4bKdsiNb2hh
	 3Sl3ycDbBCwUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6F3AC73FE2;
	Sat, 20 May 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168456181968.1665.6469597610813083931.git-patchwork-notify@kernel.org>
Date: Sat, 20 May 2023 05:50:19 +0000
References: <20230517143010.3596250-1-ap420073@gmail.com>
In-Reply-To: <20230517143010.3596250-1-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, jiri@resnulli.us, j.vosburgh@gmail.com,
 andy@greyhouse.net, netdev@vger.kernel.org, jarod@redhat.com,
 razor@blackwall.org, simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 May 2023 14:30:10 +0000 you wrote:
> When the virtual interface's feature is updated, it synchronizes the
> updated feature for its own lower interface.
> This propagation logic should be worked as the iteration, not recursively.
> But it works recursively due to the netdev notification unexpectedly.
> This problem occurs when it disables LRO only for the team and bonding
> interface type.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: fix stack overflow when LRO is disabled for virtual interfaces
    https://git.kernel.org/netdev/net/c/ae9b15fbe634

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



