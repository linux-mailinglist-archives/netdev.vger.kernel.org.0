Return-Path: <netdev+bounces-4231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C0D70BCC5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A36D81C209FD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9FDD2FC;
	Mon, 22 May 2023 12:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6222FBA27
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E588C4339B;
	Mon, 22 May 2023 12:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684756822;
	bh=OURKnhOVxqplYRqjMFvG5DVxkMxkDMgC6v26DEoYjAY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=CaiZCd0JNF4CVq5yihqtf0FGLeQsURKnL9mWLVsj/tBGBamyH4/EYQVWhmfwvv5av
	 KkNwFsTafeG8mDpl4q1WefIJi0BkXMpfHfTSa4rOJ+t2xVnBu7l64CC62ndFMr7QVs
	 YoJAN9xQ6Q2B2Aa3FDh/btY9Nvuq8rgvTKU0jjdrhXLhBwk8y+U8qwoPJO+a1hkb+V
	 AqfQvJ5dy0DfbSA7IICtJ34kpuxDno4dfqpiGF6UC293RXdUT2EFags4uzUKooYn9D
	 LvryGC5AeqJ7AisyNAghNU1o5m/Tp5G+GROfa4aYnqpFGENo460OUniJEai0m7WzVB
	 q87M/7eblOMzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4C21C395F8;
	Mon, 22 May 2023 12:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] ice: allow matching on meta data
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475682193.1139.17113741137990281733.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 12:00:21 +0000
References: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230519170018.2820322-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org,
 michal.swiatkowski@linux.intel.com, piotr.raczynski@intel.com,
 simon.horman@corigine.com, leonro@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 19 May 2023 10:00:13 -0700 you wrote:
> Michal Swiatkowski says:
> 
> This patchset is intended to improve the usability of the switchdev
> slow path. Without matching on a meta data values slow path works
> based on VF's MAC addresses. It causes a problem when the VF wants
> to use more than one MAC address (e.g. when it is in trusted mode).
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: define meta data to match in switch
    https://git.kernel.org/netdev/net-next/c/ecd01b69a5f8
  - [net-next,2/5] ice: remove redundant Rx field from rule info
    https://git.kernel.org/netdev/net-next/c/40fd749245f2
  - [net-next,3/5] ice: specify field names in ice_prot_ext init
    https://git.kernel.org/netdev/net-next/c/17c6d8357da1
  - [net-next,4/5] ice: allow matching on meta data
    https://git.kernel.org/netdev/net-next/c/03592a14b938
  - [net-next,5/5] ice: use src VSI instead of src MAC in slow-path
    https://git.kernel.org/netdev/net-next/c/0ef4479d13af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



