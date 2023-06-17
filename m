Return-Path: <netdev+bounces-11695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12838733F00
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB7A328193D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73A263B3;
	Sat, 17 Jun 2023 07:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9355133FD
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 545B0C433C9;
	Sat, 17 Jun 2023 07:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686985820;
	bh=47GE8wCvogiXyLOcRpEnqpOy95mo8ka72n2fr5EuJbk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dqE8ODZwZrTHfNVIxaduWnMfYYP87dWzM14XdosDC+2DQNl69Z7Pq1JchqM3Btdz1
	 AjVhhVHrm5M8NsBxdvATanJsAqx0eVkbMTUN7JAKVy+aag3AcoWxFLTH0YiMiwQKqX
	 LGKvo96A+kVyKcwjEJKVIpR/ZZMdzolRejL5RirgVi7rZ/gULDp+bhPgV3xIuvL3HI
	 KkSyGWwnq/6DmSGuN/ernmHWPXyd+Qt7ozSEkU8czJ8EVFkrQjb9KwkSMBnTzFdY6j
	 lsvGZBoW/mpP044YI/Tc9ziiWplyo2Uggl7USP7ijfso2sWBHEqWfqZuIVWwyPsvAX
	 Yyl2MMSVOLHpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A518C1614E;
	Sat, 17 Jun 2023 07:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] sfc: use budget for TX completions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168698582023.12434.97365026241366224.git-patchwork-notify@kernel.org>
Date: Sat, 17 Jun 2023 07:10:20 +0000
References: <20230615084929.10506-1-ihuguet@redhat.com>
In-Reply-To: <20230615084929.10506-1-ihuguet@redhat.com>
To: =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@codeaurora.org
Cc: ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-net-drivers@amd.com, bkenward@solarflare.com,
 feliu@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 10:49:29 +0200 you wrote:
> When running workloads heavy unbalanced towards TX (high TX, low RX
> traffic), sfc driver can retain the CPU during too long times. Although
> in many cases this is not enough to be visible, it can affect
> performance and system responsiveness.
> 
> A way to reproduce it is to use a debug kernel and run some parallel
> netperf TX tests. In some systems, this will lead to this message being
> logged:
>   kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s!
> 
> [...]

Here is the summary with links:
  - [v2,net] sfc: use budget for TX completions
    https://git.kernel.org/netdev/net/c/4aaf2c52834b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



