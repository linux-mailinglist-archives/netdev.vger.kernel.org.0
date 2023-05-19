Return-Path: <netdev+bounces-3796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3A6708E26
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 742A5281B35
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875C4395;
	Fri, 19 May 2023 03:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DEA643;
	Fri, 19 May 2023 03:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E96D9C433A1;
	Fri, 19 May 2023 03:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684465832;
	bh=W6R639fXJKKuVSruVJ3DRcbZrpVwnwcW4TEC6fZ4LMg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SbqJMvIWzRrhdXhue6Y6g06G1y6wOn5QQRDNPLWCjl/aZRPMCWfWXvxcAgrfR9E98
	 aLyTke7r0DMTOIDfLGp7qWRiuziofnyn3APShsGxdcFuG5jp5LQuedkbGtUIuecQVc
	 oEmAnKi+u81+NBNlIVCH301zpesa1rh2Bm8eYrOH6YPVhHMwf0Xf2Q9+lF6iEas+vf
	 mWjNwpGUgcN2nuD3kV+Lk3U/FZTC/JxUJyZ7xyvAbX0sc+gvyBHSMrzpiuZ1B5uovL
	 4lEGyBW18j8888vSuGdWwtK+6XiZm3ZqyIP6Ldf/Bt7O9SBGn16uiVLOv4vZ1hBvWg
	 1vfzzXbJ9UDWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD7B9E54223;
	Fri, 19 May 2023 03:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: Refactor inet_accept() and MIB updates
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168446583177.25467.315675860296939022.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 03:10:31 +0000
References: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
In-Reply-To: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
To: Mat Martineau <martineau@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, matthieu.baerts@tessares.net, netdev@vger.kernel.org,
 mptcp@lists.linux.dev

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 May 2023 12:16:13 -0700 you wrote:
> Patches 1 and 2 refactor inet_accept() to provide a new __inet_accept()
> that's usable with locked sockets, and then make use of that helper to
> simplify mptcp_stream_accept().
> 
> Patches 3 and 4 add some new MIBS related to MPTCP address advertisement
> and update related selftest scripts.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] inet: factor out locked section of inet_accept() in a new helper
    https://git.kernel.org/netdev/net-next/c/711bdd5141d8
  - [net-next,2/5] mptcp: refactor mptcp_stream_accept()
    https://git.kernel.org/netdev/net-next/c/e76c8ef5cc5b
  - [net-next,3/5] mptcp: introduces more address related mibs
    https://git.kernel.org/netdev/net-next/c/45b1a1227a7a
  - [net-next,4/5] selftests: mptcp: add explicit check for new mibs
    https://git.kernel.org/netdev/net-next/c/0639fa230a21
  - [net-next,5/5] selftests: mptcp: centralize stats dumping
    https://git.kernel.org/netdev/net-next/c/985de45923e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



