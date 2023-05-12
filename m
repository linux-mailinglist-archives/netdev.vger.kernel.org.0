Return-Path: <netdev+bounces-2081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8939700371
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F14591C20DF4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB107BA47;
	Fri, 12 May 2023 09:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0CABA3B
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEF56C433AC;
	Fri, 12 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683882621;
	bh=XHnFAQ7ze9vEUkTeEUYx83aW+SNA9fUq3BXEuhSG/Ww=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=O7TRXXvl2KZxMoMZvkG/xx+RQYolf1u3/uP5wLVF8thJpu6H+isMNkhcZoXl3/3RB
	 bonmyJSB8SxIxT2pnBTMQrtmo1/4YDNcnJ1OisZiv8uNEO+F2wO5kXinQEoAFwcG2F
	 zBW70+9LzViWrahjGtBFGAjVFxACRp1HIgiRRdsCd2ZjCUYIeWWHdinOK+b0V5W01L
	 fbusXOb8PQFxxymNW9b+zWa+MDNEz89ELIlAr35xeSM8ZzTx9I4Q3RGwDHibks1t2R
	 gmbZmXCX1YfMbNqjjrh98sib8pAp/fcnIn21Hty8UrY1IZrH5llaNLqywX8wcw2nzm
	 tRkJqofI0G1Ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBF1BE26D20;
	Fri, 12 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] sctp: add bpf_bypass_getsockopt proto callback
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388262182.3920.17093137867529020681.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 09:10:21 +0000
References: <20230511132506.379102-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230511132506.379102-1-aleksandr.mikhalitsyn@canonical.com>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, daniel@iogearbox.net,
 brauner@kernel.org, sdf@google.com, marcelo.leitner@gmail.com,
 lucien.xin@gmail.com, linux-sctp@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 15:25:06 +0200 you wrote:
> Implement ->bpf_bypass_getsockopt proto callback and filter out
> SCTP_SOCKOPT_PEELOFF, SCTP_SOCKOPT_PEELOFF_FLAGS and SCTP_SOCKOPT_CONNECTX3
> socket options from running eBPF hook on them.
> 
> SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS options do fd_install(),
> and if BPF_CGROUP_RUN_PROG_GETSOCKOPT hook returns an error after success of
> the original handler sctp_getsockopt(...), userspace will receive an error
> from getsockopt syscall and will be not aware that fd was successfully
> installed into a fdtable.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] sctp: add bpf_bypass_getsockopt proto callback
    https://git.kernel.org/netdev/net-next/c/2598619e012c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



