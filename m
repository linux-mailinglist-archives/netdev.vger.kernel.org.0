Return-Path: <netdev+bounces-11247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9397322A0
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80D741C20E4D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7455517AA8;
	Thu, 15 Jun 2023 22:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E4E168C8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F3C5C433C9;
	Thu, 15 Jun 2023 22:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686867620;
	bh=wg3wGQxTj13gSGY2wtF6/8w9ZhPo5FILdjUuEZ8tMYU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Z9wZaXWPoa/BHTNzxeQbZmKyq6N49gMk6zAq4A/nDrKetk5XdRt9HgOq0aJE4WUPJ
	 Umt8wCOaHfldLKZy/QA9eq0SvMX/4lYkwoMh4r5jtpPDa2eQX7CX3A2Bi+V3MylCEh
	 FGVCp0+nEJatOFmG5qAu0pwq2Fz3Qp5RngZJ7vs4xyLjqMgqjOMOcDYuC8uYgY3mpj
	 PHucgDYWgry8XNRB2Fpo4LV4vqpFGr/vJvRomItItw8caEM1ihBtuRfNUBOwwyvQb8
	 vGOmsJ8ejTUrGJwLgpphUOrFj/ZgPAkbziBymvPA0kGapzLvFSKB3Ch/yTTZ0XK0ZA
	 1iNRfKiUNN35A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6080EC395E0;
	Thu, 15 Jun 2023 22:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/2] udplite/dccp: Print deprecation notice.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168686762039.14952.9539770701942860783.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 22:20:20 +0000
References: <20230614194705.90673-1-kuniyu@amazon.com>
In-Reply-To: <20230614194705.90673-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, willemdebruijn.kernel@gmail.com, kuni1840@gmail.com,
 netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 12:47:03 -0700 you wrote:
> UDP-Lite is assumed to have no users for 7 years, and DCCP is
> orphaned for 7 years too.
> 
> Let's add deprecation notice and see if anyone responds to it.
> 
> Kuniyuki Iwashima (2):
>   udplite: Print deprecation notice.
>   dccp: Print deprecation notice.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/2] udplite: Print deprecation notice.
    https://git.kernel.org/netdev/net/c/be28c14ac8bb
  - [v1,net,2/2] dccp: Print deprecation notice.
    https://git.kernel.org/netdev/net/c/b144fcaf46d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



