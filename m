Return-Path: <netdev+bounces-11766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CEFC7345CD
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 12:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68CB41C20992
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58537184C;
	Sun, 18 Jun 2023 10:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCCE1386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 961D4C433D9;
	Sun, 18 Jun 2023 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687083619;
	bh=PzTEnSq9qYk+OyGh4rp4xMPHDvA9Q/44FTRL5zNb+to=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=u9VZPYIUaUHcgnlJu+qEHM30rvpfHzO/7ih6JohjBorqvZieHTFsfSMBRfHqKxWrF
	 Ym0SlHick/mbfg9kRRq0ITyyQpnPklLjfUcwRTRqYWLsrbN2nqcgai7wSsljqyyayB
	 Ek2aBZNVcS8AavyiAJNClDxga5Bh+7tjI7lyUHKWBKF2DOjI9Iv8LiR1JOvWoZapqD
	 c3RrWXUKR8x2UOfhq+lMzw8Srb2k3aye2akWgsSwjF4Y3Jxaj6Mic5qPLc2jkpPjYM
	 FsCnx1tCikde57bwJRrNFilSPZP+AG/YnfqrLbpKIu5OioMMK3NxR+/B1RcveEf4E0
	 i8vGyh3UnBVGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81B03E21EE5;
	Sun, 18 Jun 2023 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next,v2] tcp: Use per-vma locking for receive zerocopy
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168708361952.30416.4165448356299935816.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 10:20:19 +0000
References: <20230616193427.3908429-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20230616193427.3908429-1-arjunroy.kdev@gmail.com>
To: Arjun Roy <arjunroy.kdev@gmail.com>
Cc: netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
 soheil@google.com, kuba@kernel.org, akpm@linux-foundation.org,
 dsahern@kernel.org, davem@davemloft.net, linux-mm@kvack.org,
 pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 12:34:27 -0700 you wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Per-VMA locking allows us to lock a struct vm_area_struct without
> taking the process-wide mmap lock in read mode.
> 
> Consider a process workload where the mmap lock is taken constantly in
> write mode. In this scenario, all zerocopy receives are periodically
> blocked during that period of time - though in principle, the memory
> ranges being used by TCP are not touched by the operations that need
> the mmap write lock. This results in performance degradation.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] tcp: Use per-vma locking for receive zerocopy
    https://git.kernel.org/netdev/net-next/c/7a7f09463534

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



