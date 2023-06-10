Return-Path: <netdev+bounces-9795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F2A72A9CC
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 027D92818B6
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096B479F1;
	Sat, 10 Jun 2023 07:21:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938E43C15
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23B52C4339B;
	Sat, 10 Jun 2023 07:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381690;
	bh=BP2G57NBPTRH0I8G78BmiwKP7U1qRlQezFk+sgL6hjE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FkvADy/Yh7WqxbxVzwgvzBEys0pYehi9Ks7lLZkCROQw0nhbylgljZVeaj/dYjIlo
	 4sBzFiZirOMi8fYkiW5A/l+lT13gNFGT9T5O3leC7spsF/2HRiqKQ4TB4+VBPziHQu
	 hUP4eyceSJEHGImt+8fBoxpQB7cSugESkI1+Hroiu3S+q3hX2BYy9xMH5xwi1jJQod
	 ReZLugR0tQ3MIPxZifu3KYC/oNEXMWmBUMK6OvI950aF+eX0frwaw3eJ0ZWxq0Ca87
	 BpX3EZ1/bz2BDnhdUElrzh/whTYlowByIznHk99+MbzA36DdZEMmjwO+kUsiRs4L5q
	 ZBlH9GdmOR5Hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2061E87232;
	Sat, 10 Jun 2023 07:21:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-06-08 (ice)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168638168998.9909.1557833652014622256.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 07:21:29 +0000
References: <20230608200051.451752-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230608200051.451752-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  8 Jun 2023 13:00:49 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Simon Horman stops null pointer dereference for GNSS error path.
> 
> Kamil fixes memory leak when downing interface when XDP is enabled.
> 
> The following are changes since commit 6c0ec7ab5aaff3706657dd4946798aed483b9471:
>   Merge branch 'bnxt_en-bug-fixes'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: Don't dereference NULL in ice_gnss_read error path
    https://git.kernel.org/netdev/net/c/05a1308a2e08
  - [net,2/2] ice: Fix XDP memory leak when NIC is brought up and down
    https://git.kernel.org/netdev/net/c/78c50d6961fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



