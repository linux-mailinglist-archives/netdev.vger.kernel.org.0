Return-Path: <netdev+bounces-7626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 263A1720E1B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6330B1C212AF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F432EA0;
	Sat,  3 Jun 2023 06:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B90EC132
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D116C4339B;
	Sat,  3 Jun 2023 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685773822;
	bh=f0TtfCWpq+9yY6ha+jgh4kFkwXkoZ55oHOxLugenbf4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=CHLC7RaT+1nXGQ7A19oJ0Ij1e86yBUXMsFh79ihp1mTaIG0ft/trIoOD65KKHJqZS
	 +4NQGwk2gxVwXXo/MZs6K6NvdZ4nHtzX7R+yD0rBiKjUDGy1tPwWXRVNcFWH59y5s1
	 miWQ3Cl2ehqiwZ1XLbn2w5LTA4zTY9u/YRwyOoQV8cjHk+q55cXEFE5Pgm0Rn/vtFx
	 1mzG3dzYFTDLw1lMIIEpEGUgdWnslTOLPxfQCrCjtxLs/QyTFcJef+TjktRHOMabTu
	 FjX7X0C2mzYCrwRdGsSMCOtUgsImE7jyopWHOnc+5GBc81p1KyPndQV26C3pdZWewI
	 F6S6+R84+fdPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6AC73E49FA9;
	Sat,  3 Jun 2023 06:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/ipv6: skip_notify_on_dev_down fix
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168577382243.1168.3283542518432893640.git-patchwork-notify@kernel.org>
Date: Sat, 03 Jun 2023 06:30:22 +0000
References: <20230601160445.1480257-1-edumazet@google.com>
In-Reply-To: <20230601160445.1480257-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, dsahern@kernel.org, matthieu.baerts@tessares.net,
 eric.dumazet@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Jun 2023 16:04:43 +0000 you wrote:
> While reviewing Matthieu Baerts recent patch [1], I found it copied/pasted
> an existing bug around skip_notify_on_dev_down.
> 
> First patch is a stable candidate, and second one can simply land
> in net tree.
> 
> https://lore.kernel.org/lkml/20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net/
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/ipv6: fix bool/int mismatch for skip_notify_on_dev_down
    https://git.kernel.org/netdev/net/c/edf2e1d2019b
  - [net,2/2] net/ipv6: convert skip_notify_on_dev_down sysctl to u8
    https://git.kernel.org/netdev/net/c/ef62c0ae6db1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



