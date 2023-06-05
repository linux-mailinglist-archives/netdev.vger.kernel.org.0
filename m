Return-Path: <netdev+bounces-7961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D134772237F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F16901C20A9C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F1820FB;
	Mon,  5 Jun 2023 10:30:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A7617AB8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7B8BC4339B;
	Mon,  5 Jun 2023 10:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685961025;
	bh=2L2uK0B49nA6JvrAKIky0xpu2CygDXxBs5ZD6P03gvo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qdAYBpcdi+Zx+xbnjtmDBFfQEQdyaURz/1UR9jpGjYErT8Wqm29ZdSziK0S212mgl
	 BRUvQ+8dNuTNKw/KHVaw6pQVqrns5H5O7w6GtCWnvH2yRvffSHTD8/ZpNPib6TA9oP
	 WS+PKZg0Zu/yXLX6vNNNCPNSvGYS7DbNGMTeAO/jjltYjm4Nwao5y5LxU1He9wxOuf
	 iurizaIFFnobsNdZYKJBle6MuAuMVQUtaHLG3K5LwB/FaiG23A8qK1GYzy49+M6pnf
	 EvK7J1zgh+qVssHHlia9QBOj3eMY5l7W6ZWYv1ir5LtAde/mZOnXUdTggfFiZc7x09
	 wnCXOA20n1cFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6F28E49FA8;
	Mon,  5 Jun 2023 10:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw, selftests: Cleanups
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168596102474.26938.22774406358566950.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 10:30:24 +0000
References: <cover.1685720841.git.petrm@nvidia.com>
In-Reply-To: <cover.1685720841.git.petrm@nvidia.com>
To: Petr Machata <petrm@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
 amcohen@nvidia.com, danieller@nvidia.com, linux-kselftest@vger.kernel.org,
 mlxsw@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Jun 2023 18:20:04 +0200 you wrote:
> This patchset consolidates a number of disparate items that can all be
> considered cleanups. They are all related to mlxsw in that they are
> directly in mlxsw code, or in selftests that mlxsw heavily uses.
> 
> - patch #1 fixes a comment, patch #2 propagates an extack
> 
> - patches #3 and #4 tweak several loops to query a resource once and cache
>   in a local variable instead of querying on each iteration
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum_router: Clarify a comment
    https://git.kernel.org/netdev/net-next/c/be35db17c872
  - [net-next,2/8] mlxsw: spectrum_router: Use extack in mlxsw_sp~_rif_ipip_lb_configure()
    https://git.kernel.org/netdev/net-next/c/5afef6748c19
  - [net-next,3/8] mlxsw: spectrum_router: Do not query MAX_RIFS on each iteration
    https://git.kernel.org/netdev/net-next/c/3903249ee1af
  - [net-next,4/8] mlxsw: spectrum_router: Do not query MAX_VRS on each iteration
    https://git.kernel.org/netdev/net-next/c/75426cc0b316
  - [net-next,5/8] selftests: mlxsw: ingress_rif_conf_1d: Fix the diagram
    https://git.kernel.org/netdev/net-next/c/204cc3d04fe2
  - [net-next,6/8] selftests: mlxsw: egress_vid_classification: Fix the diagram
    https://git.kernel.org/netdev/net-next/c/34ad708d1b43
  - [net-next,7/8] selftests: router_bridge_vlan: Add a diagram
    https://git.kernel.org/netdev/net-next/c/812de4dfab98
  - [net-next,8/8] selftests: router_bridge_vlan: Set vlan_default_pvid 0 on the bridge
    https://git.kernel.org/netdev/net-next/c/f5136877f421

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



