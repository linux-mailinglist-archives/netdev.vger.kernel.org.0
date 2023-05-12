Return-Path: <netdev+bounces-2056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB2470020C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EC171C21133
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5209442;
	Fri, 12 May 2023 08:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FEE7475
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B313FC4339E;
	Fri, 12 May 2023 08:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683878422;
	bh=gUj7gGh4OJoB4CxweJ8piF2fXBRJwvz7pJEBYl6Fgg0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Z2ECf/jyeTv30+gxnp/gND1fLfwqKJrq0zjwEHPAhbRAIP3h4LuofNuncuoiGCBL6
	 4x5CgC2Ic+AGRE2FufLiB5VsGwuN+mgD5zbzz0Jgrgam6MHrpxqjeAxdxWsmzR3kSz
	 HIfHFRDI4RBJlOroZHiLOf+MMTErJ+/NN1tWDTQWVCQYqqlDvlOJIT61oOKT9x0DBm
	 aWmpKTWZmJRyNvCinrSXABvUHNO6qaU1bX8i1KxkWtDam5gp1x/YaaZbOt7H3KucfW
	 yKdauSmyEDbIdd+py8f2SiDv23cG9bHYFcqGI8RcR1CdATGpJfmJ3KjecdmAjTJkqp
	 qUKWM8MhoM8aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A30FE4D00E;
	Fri, 12 May 2023 08:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: don't CC docs@ for netlink spec changes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168387842262.16770.8136584455038121536.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:00:22 +0000
References: <20230511014339.906663-1-kuba@kernel.org>
In-Reply-To: <20230511014339.906663-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, linux-doc@vger.kernel.org, corbet@lwn.net

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 18:43:39 -0700 you wrote:
> Documentation/netlink/ contains machine-readable protocol
> specs in YAML. Those are much like device tree bindings,
> no point CCing docs@ for the changes.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] MAINTAINERS: don't CC docs@ for netlink spec changes
    https://git.kernel.org/netdev/net/c/01e8f6cd108b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



