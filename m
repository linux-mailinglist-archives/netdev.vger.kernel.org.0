Return-Path: <netdev+bounces-2544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D9B702765
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6275A1C20AC8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15A879E6;
	Mon, 15 May 2023 08:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5F36FB9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9B8CC433EF;
	Mon, 15 May 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684140022;
	bh=rkPYRVHYoFIq5x31MeyoOcvF2XsRlsAmrW6c/Ah20e4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=T0qutthaj7wTluNWt8wE446nIlbekz+lyFEG3t+q84meeZCY+MNxV8qmdbf2LZs65
	 lfPXz/m9LH2F7O97wL/kgUyR8jLdgNKr/JWT4S7XCIys4wNEhX6dkPi/74Aiu6IoqC
	 MQa6KWpiVDHXrkb+d4bvKWFxsFnP3vkbijB4ksplyXE24LTvA1cS95UboNCDNT2wGY
	 GQ6Dbtar5Q4Sfoh6sd8k5fixnUi79x15pSQOoV7rzqEa8yic9HrrE0c0XrF9+esg5u
	 mmM3/JszZLwEiv+N18QdUBmp3F+0YkYbtV6rIiGgS0eCEm0hWtTrgOhlZxgarsk5+i
	 /ccxQSz8XUC4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB959C41672;
	Mon, 15 May 2023 08:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next Patch v10 0/8] octeontx2-pf: HTB offload support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168414002269.19885.17289418600724460807.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 08:40:22 +0000
References: <20230513085143.3289-1-hkelam@marvell.com>
In-Reply-To: <20230513085143.3289-1-hkelam@marvell.com>
To: Hariprasad Kelam <hkelam@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuba@kernel.org,
 davem@davemloft.net, willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
 sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
 jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvell.com,
 edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com,
 corbet@lwn.net, linux-doc@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 13 May 2023 14:21:35 +0530 you wrote:
> octeontx2 silicon and CN10K transmit interface consists of five
> transmit levels starting from MDQ, TL4 to TL1. Once packets are
> submitted to MDQ, hardware picks all active MDQs using strict
> priority, and MDQs having the same priority level are chosen using
> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> Each level contains an array of queues to support scheduling and
> shaping.
> 
> [...]

Here is the summary with links:
  - [net-next,v10,1/8] sch_htb: Allow HTB priority parameter in offload mode
    https://git.kernel.org/netdev/net-next/c/12e7789ad5b4
  - [net-next,v10,2/8] octeontx2-pf: Rename tot_tx_queues to non_qos_queues
    https://git.kernel.org/netdev/net-next/c/508c58f76ca5
  - [net-next,v10,3/8] octeontx2-pf: qos send queues management
    https://git.kernel.org/netdev/net-next/c/ab6dddd2a669
  - [net-next,v10,4/8] octeontx2-pf: Refactor schedular queue alloc/free calls
    https://git.kernel.org/netdev/net-next/c/6b4b2ded9c42
  - [net-next,v10,5/8] octeontx2-pf: Prepare for QOS offload
    https://git.kernel.org/netdev/net-next/c/cb748a7ebad7
  - [net-next,v10,6/8] octeontx2-pf: Add support for HTB offload
    https://git.kernel.org/netdev/net-next/c/5e6808b4c68d
  - [net-next,v10,7/8] octeontx2-pf: ethtool expose qos stats
    https://git.kernel.org/netdev/net-next/c/6cebb6a4b114
  - [net-next,v10,8/8] docs: octeontx2: Add Documentation for QOS
    https://git.kernel.org/netdev/net-next/c/efe103065ccb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



