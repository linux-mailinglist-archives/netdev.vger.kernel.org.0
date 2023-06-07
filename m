Return-Path: <netdev+bounces-8796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E2C8725D27
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5962F2812E1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5548833C8C;
	Wed,  7 Jun 2023 11:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE48712B99
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 107A8C4339E;
	Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686137421;
	bh=JtgpHR9jAS/ES9xJatWYkrumSaRdfcu4RH4GfXLyJIo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=W+2wQDkPbMwBNqcWiPok8wepVuZYyPYBE+lwrT3PF49s4uHygUxgeC1Qlelg9igGT
	 BAavRtgoFpWU6aB8DsVv/z597bufe7s+LkPbUgrjgUDVtZLgasNpO+rIQ34tMjIFuy
	 3uS99u2I/AIx2B0kLWrmi8PHvaQ1WcauCZnMOlScd0ckPvU9X94IidvjitfPKNyO56
	 O5HuWswXt0G1l8E4aPpPItr7YjXSHhw/GxW2UtNhOzqqfZrE0LqUEL002F+L/c7/V6
	 yTDYozPykWzUou6oABowcEBJNtN3RccwOhSCYvD9l06rjyhzEtNwVOG5dFO8L9IHqL
	 vbsJlyxAlogBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA25CE29F3C;
	Wed,  7 Jun 2023 11:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: openvswitch: fix upcall counter access before
 allocation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613742095.29815.15904515822900962652.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 11:30:20 +0000
References: <168605257118.1677939.2593213990325886393.stgit@ebuild>
In-Reply-To: <168605257118.1677939.2593213990325886393.stgit@ebuild>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, dev@openvswitch.org,
 aconole@redhat.com, simon.horman@corigine.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 13:56:35 +0200 you wrote:
> Currently, the per cpu upcall counters are allocated after the vport is
> created and inserted into the system. This could lead to the datapath
> accessing the counters before they are allocated resulting in a kernel
> Oops.
> 
> Here is an example:
> 
> [...]

Here is the summary with links:
  - [net,v2] net: openvswitch: fix upcall counter access before allocation
    https://git.kernel.org/netdev/net/c/de9df6c6b27e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



