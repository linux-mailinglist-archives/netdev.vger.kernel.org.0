Return-Path: <netdev+bounces-10015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973A872BAF9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 916C31C209BB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EF0168C0;
	Mon, 12 Jun 2023 08:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D62A11CA1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83FB7C433A0;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559222;
	bh=/XMXjqWs79M5mFOv6TougyM/ZSmiKItM7dBl6O17l6s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Odnn/yuQBBvjfz1SYTsLLAYJXPcgL71ySsgMWjGIXEzpdf4mmoECRJlB4QBPpjCWV
	 RXpSd1xsDVaa37h6vOnOiRYGpXlsi7Sh8taQwep9MLg8iEc7UsdhfD0vEiYXi6NSBK
	 u/S3xo75nokNz92M+8xUl5lPQx9unj8mnvrvXLANkRZzBX1jG0JK/B/ZZdG6A5xSY7
	 vZexcavHXu0c+NiPKQqw2i9SjHJkdi6yvTkycu5TjK6UWaXAresy4xfMByI91gJrwO
	 GEICI2rhtvcnddZQV42N78zF4rtmGBVV0aSCpNp0JvblGz7xjiXYilzpkFmxi6QPAv
	 Y0VPXTVMPD6OQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CEC6C395EC;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] ice: Improve miscellaneous
 interrupt code
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922244.2912.10217934419364747900.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:22 +0000
References: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, jacob.e.keller@intel.com,
 richardcochran@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  8 Jun 2023 13:21:10 -0700 you wrote:
> Jacob Keller says:
> 
> This series improves the driver's use of the threaded IRQ and the
> communication between ice_misc_intr() and the ice_misc_intr_thread_fn()
> which was previously introduced by commit 1229b33973c7 ("ice: Add low
> latency Tx timestamp read").
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: handle extts in the miscellaneous interrupt thread
    https://git.kernel.org/netdev/net-next/c/6e8b2c88fc8c
  - [net-next,2/5] ice: always return IRQ_WAKE_THREAD in ice_misc_intr()
    https://git.kernel.org/netdev/net-next/c/d578e618f192
  - [net-next,3/5] ice: introduce ICE_TX_TSTAMP_WORK enumeration
    https://git.kernel.org/netdev/net-next/c/ae39eb42dd06
  - [net-next,4/5] ice: trigger PFINT_OICR_TSYN_TX interrupt instead of polling
    https://git.kernel.org/netdev/net-next/c/9a8648cce8d8
  - [net-next,5/5] ice: do not re-enable miscellaneous interrupt until thread_fn completes
    https://git.kernel.org/netdev/net-next/c/0ec38df36ea1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



