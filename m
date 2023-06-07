Return-Path: <netdev+bounces-8663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 478D47251C6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBD1828112D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239F663C;
	Wed,  7 Jun 2023 01:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152077C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72A5BC4339B;
	Wed,  7 Jun 2023 01:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686102619;
	bh=WYBB0nv4TIoDXC3N3wpy9wosSDo7rQ46y6w2iiNwRP8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sedkxNhNcjlz20vaqkVAnlzK/uP7/4gQZrdJlzxXrjkTdbBoBoqGUOSz/pvYQdNqG
	 Sp3fBkCan98bSp5IzrcywDZOzDY1Ax8/iVeZvvJuZCqPbRKJlcnf1/pr02pt+KOhcr
	 AzMGPG5W0SIuJ01lF+43bQAcKULmVJLVrg4ivAVW3rTA7TWLL6sAY2SJjJcwv8hkiS
	 ip8EAA4dOc3HPuWh3l/JRPb9EAbYBQlAxDoMUK99Wz0ZhITAusPHqxEkaw1lnuSDU+
	 63aER17WKgb6Nqa3qxJ9Vc12kEKmuV59xTwzKJomGZ9kwmDetdZw24J9dBqVZYY4eo
	 FQvJUVMGp65pA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 559BEE29F37;
	Wed,  7 Jun 2023 01:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: specs: ethtool: fix random typos
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168610261934.31041.7946284956041820469.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 01:50:19 +0000
References: <20230605233257.843977-1-kuba@kernel.org>
In-Reply-To: <20230605233257.843977-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, sdf@google.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Jun 2023 16:32:57 -0700 you wrote:
> Working on the code gen for C reveals typos in the ethtool spec
> as the compiler tries to find the names in the existing uAPI
> header. Fix the mistakes.
> 
> Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] netlink: specs: ethtool: fix random typos
    https://git.kernel.org/netdev/net/c/f6ca5baf2a86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



