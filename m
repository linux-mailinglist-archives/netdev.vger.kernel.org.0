Return-Path: <netdev+bounces-3009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1972705019
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77E051C20E1E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4853027739;
	Tue, 16 May 2023 14:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E6834CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46C2EC433EF;
	Tue, 16 May 2023 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684245621;
	bh=CycJxwzgp6NdmMm5PSA0/XzQXHs+2X2MUpAmyyID13k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q4B4fo0H9Smg68Mor77RXLThjn0vgF0H71IqBgNFW2LrpkLBcbKlPoJJX4tRFVDoM
	 2ubtyypoHsJzSPD7uuPmqKusxoBxed4soktkS56h3AVcjV7lOCjfOeMK2+hfHA89YB
	 vBj+TqcMBSthoVSJcyD9tNqKOveZi9x/YhSR//nb4DkMm7N1UyNXMQ1xZb3gln9ubb
	 j2jln7A53WHDLhHuxjXAmlwdwEFUc0620COJKwwDlE1JFbZgKRXc86Ec/NulTM3zXy
	 fR6pStfyI/yzgEdFKVeBh6q1oyASSG2ym4sj3LPKP3SLjG9DSMNHGr2+9mG3UegPvq
	 nLVI9CmoxNHNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2998CE45237;
	Tue, 16 May 2023 14:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] SPDX conversion for bonding, 8390, and i825xx drivers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168424562116.31205.13617747575033389868.git-patchwork-notify@kernel.org>
Date: Tue, 16 May 2023 14:00:21 +0000
References: <20230515060714.621952-1-bagasdotme@gmail.com>
In-Reply-To: <20230515060714.621952-1-bagasdotme@gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, sammy@sammy.net,
 gerg@linux-m68k.org, simon.horman@corigine.com, trix@redhat.com,
 yangyingliang@huawei.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 15 May 2023 13:07:10 +0700 you wrote:
> This series is SPDX conversion for bonding, 8390, and i825xx driver
> subsystems. It is splitted from v2 of my SPDX conversion series in
> response to Didi's GPL full name fixes [1] to make it easily
> digestible.
> 
> The conversion in this series is divided by each subsystem and by
> license type.
> 
> [...]

Here is the summary with links:
  - [net,1/5] net: bonding: Add SPDX identifier to remaining files
    https://git.kernel.org/netdev/net-next/c/613a014191f5
  - [net,2/5] net: ethernet: 8390: Convert unversioned GPL notice to SPDX license identifier
    https://git.kernel.org/netdev/net-next/c/dc3eb2f4ec09
  - [net,3/5] net: ethernet: 8390: Replace GPL 2.0 boilerplate with SPDX identifier
    https://git.kernel.org/netdev/net-next/c/9f07af05d0e4
  - [net,4/5] net: ethernet: i825xx: Replace unversioned GPL (GPL 1.0) notice with SPDX identifier
    https://git.kernel.org/netdev/net-next/c/9ac40d080bef
  - [net,5/5] net: ethernet: i825xx: sun3_8256: Add SPDX license identifier
    https://git.kernel.org/netdev/net-next/c/4f693a8f5617

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



