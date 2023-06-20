Return-Path: <netdev+bounces-12130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB997365C6
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92C8E1C20A65
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33878473;
	Tue, 20 Jun 2023 08:10:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D43F8471
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 161EBC433C9;
	Tue, 20 Jun 2023 08:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687248623;
	bh=BZxj+/JIcsG1tMX2T/L05c1gmEmaI3vQNIvKKORs2dQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pFfX31DvsP0YxdNX59lQnsXj7cPkTWIp2xU6uc58i8Md1QXRtpbly7nW09pU2rPCl
	 Z8oPb4L0p5gL1w83lzs/lFlVpM2uhJwSzkGnvdk0q4Jz5bTblzWXUUF+HwEJnwyrfo
	 MNa6m5cUbHaQ0ubQs+BKDx4vQX9pQxXO5BZdiJJJb4z/1uZB6oWFaSoXHWNgZrXZvd
	 Dqm/scXee9vjvLrTLVxAuijPvfIO4RJ4PwXHx1Xdav0QPCky4LskgLEQT22pltdSKD
	 K4jpdUv4f4luR5oLB1ylJtcYpZVWKorflR7TgFQAgprPTi88SsVPvgcbLG01wKpwsP
	 om9GFoIn3Yq6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6327C395D9;
	Tue, 20 Jun 2023 08:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/9] ptp .adjphase cleanups
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168724862293.22435.9678368746487298920.git-patchwork-notify@kernel.org>
Date: Tue, 20 Jun 2023 08:10:22 +0000
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, gal@nvidia.com, saeed@kernel.org,
 tariqt@nvidia.com, kuba@kernel.org, richardcochran@gmail.com,
 jacob.e.keller@intel.com, pabeni@redhat.com, davem@davemloft.net

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 12 Jun 2023 14:14:51 -0700 you wrote:
> The goal of this patch series is to improve documentation of .adjphase, add
> a new callback .getmaxphase to enable advertising the max phase offset a
> device PHC can support, and support invoking .adjphase from the testptp
> kselftest.
> 
> Changes:
>   v3->v2:
>     * Add information about returning -ERANGE instead of clamping
>       out-of-range offsets for driver implementations of .adjphase that
>       previously clamped out-of-range offsets.
> 
> [...]

Here is the summary with links:
  - [v3,1/9] ptp: Clarify ptp_clock_info .adjphase expects an internal servo to be used
    https://git.kernel.org/netdev/net-next/c/a05d070a6164
  - [v3,2/9] docs: ptp.rst: Add information about NVIDIA Mellanox devices
    https://git.kernel.org/netdev/net-next/c/fe3834cd0cf7
  - [v3,3/9] testptp: Remove magic numbers related to nanosecond to second conversion
    https://git.kernel.org/netdev/net-next/c/048f6d998eac
  - [v3,4/9] testptp: Add support for testing ptp_clock_info .adjphase callback
    https://git.kernel.org/netdev/net-next/c/3a9a9a613928
  - [v3,5/9] ptp: Add .getmaxphase callback to ptp_clock_info
    https://git.kernel.org/netdev/net-next/c/c3b60ab7a4df
  - [v3,6/9] net/mlx5: Add .getmaxphase ptp_clock_info callback
    https://git.kernel.org/netdev/net-next/c/67ac72a599d8
  - [v3,7/9] ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
    https://git.kernel.org/netdev/net-next/c/c066e74f34bc
  - [v3,8/9] ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
    https://git.kernel.org/netdev/net-next/c/e156e4d2e43f
  - [v3,9/9] ptp: ocp: Add .getmaxphase ptp_clock_info callback
    https://git.kernel.org/netdev/net-next/c/d8ee5ca845b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



