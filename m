Return-Path: <netdev+bounces-7187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC91671F085
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 286EA1C210DA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C3946FE5;
	Thu,  1 Jun 2023 17:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7044253A;
	Thu,  1 Jun 2023 17:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82847C433D2;
	Thu,  1 Jun 2023 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685640022;
	bh=LZFteKwaGN0IDeCXiUlxd+NIaIwWRgoKYWH/vjTXTio=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BVWVMTPudVpDaPw4X96jAGLIhzOHYpeug6yifgZOK2KDVZj2rHX4V5eb6R4xNnceE
	 NG8y6eIvB7vebbavw546ZTeu8hoYzKxbRLyGKt1yk0h3F+80OHoGzMZMH28tO3trDa
	 EosODlG+JzpzdQyY8M7BcnM5GCmqGS9jBjrbMVfYv8HmiPEBH5wndet1wrlPG93hgU
	 UOpBH6CMR38SNziy6EQyo0dHozQLS8oUpE1CyOlY7O7zpeY/qeJpZR1MPiBygkEoxG
	 n2ddBH5n8vhY5ANkJOLn3vBZ+tBhiUbcW1GV9vjz4ZCkmPfyw+w0tCowcvy/u9+RnK
	 S3uFuCLJtlB1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 613CBC395F0;
	Thu,  1 Jun 2023 17:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] mptcp: Fixes for connect timeout, access
 annotations, and subflow init
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168564002239.14862.18397323108950816840.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 17:20:22 +0000
References: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
In-Reply-To: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
To: Mat Martineau <martineau@kernel.org>
Cc: matthieu.baerts@tessares.net, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, geliang.tang@suse.com,
 netdev@vger.kernel.org, mptcp@lists.linux.dev, omosnace@redhat.com,
 stable@vger.kernel.org, cpaasch@apple.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 12:37:02 -0700 you wrote:
> Patch 1 allows the SO_SNDTIMEO sockopt to correctly change the connect
> timeout on MPTCP sockets.
> 
> Patches 2-5 add READ_ONCE()/WRITE_ONCE() annotations to fix KCSAN issues.
> 
> Patch 6 correctly initializes some subflow fields on outgoing connections.
> 
> [...]

Here is the summary with links:
  - [net,1/6] mptcp: fix connect timeout handling
    https://git.kernel.org/netdev/net/c/786fc1245726
  - [net,2/6] mptcp: add annotations around msk->subflow accesses
    https://git.kernel.org/netdev/net/c/5b825727d087
  - [net,3/6] mptcp: consolidate passive msk socket initialization
    https://git.kernel.org/netdev/net/c/7e8b88ec35ee
  - [net,4/6] mptcp: fix data race around msk->first access
    https://git.kernel.org/netdev/net/c/1b1b43ee7a20
  - [net,5/6] mptcp: add annotations around sk->sk_shutdown accesses
    https://git.kernel.org/netdev/net/c/6b9831bfd932
  - [net,6/6] mptcp: fix active subflow finalization
    https://git.kernel.org/netdev/net/c/55b47ca7d808

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



