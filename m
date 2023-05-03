Return-Path: <netdev+bounces-115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 093806F530B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE4572811EA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F87BA4C;
	Wed,  3 May 2023 08:20:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2599747E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3994CC4339B;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102021;
	bh=MNbBVlYbis/L18qS6wI8HpvxXDkCPPaY/e5bpD6riks=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E6cA4YIlZuy27KGN0RmddUDj2Focc2XiIjeWi1cKpUaBFzgwybLyOB55mIKPasYAK
	 HOrhGpwpNwq3b23YG+rT2tWxhndaFtGjs3Jb8lJX1sMJ0bF4ML8NXwHamfKi6qMQQD
	 DElSIs8q1dtUXNqpId6HZbTOQCd/NYgyy6ooPJT+/3K1G92rgiRN5rO7/NBXzcp9ia
	 85iM+bIV71FDtvSZNvP4PXUEO3Ex/IjbVf127STXhFgXNcquYaUeNFhD/zaLZzbKC0
	 5Sn2WRJlC+9QYv9s9D3seZcQAGkCBtTX1izY2VznFitvpcCopEfIA2CNb2+jd9DmUr
	 MRA8Q2Ksixjyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 154ADE5FFC9;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igc: read before write to SRRCTL register
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310202108.22454.4653955011857932951.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:20:21 +0000
References: <20230502154806.1864762-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230502154806.1864762-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, yoong.siang.song@intel.com,
 sasha.neftin@intel.com, maciej.fijalkowski@intel.com,
 magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
 stable@vger.kernel.org, jacob.e.keller@intel.com, brouer@redhat.com,
 naamax.meir@linux.intel.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 May 2023 08:48:06 -0700 you wrote:
> From: Song Yoong Siang <yoong.siang.song@intel.com>
> 
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 
> [...]

Here is the summary with links:
  - [net,1/1] igc: read before write to SRRCTL register
    https://git.kernel.org/netdev/net/c/3ce29c17dc84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



