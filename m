Return-Path: <netdev+bounces-9848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D10D72AE53
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 21:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D47B728141C
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7C720688;
	Sat, 10 Jun 2023 19:12:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5ABC8F6
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C28AC4339C;
	Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686424348;
	bh=Z0fG7WLWYcSYfk8yk7VxAcXZyHQs6FI+Dl0Ez10rIHw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IMtQcalXxFRRSGXHD1uP/i+jMk3icOhytlb5v5Hq1jLLHV/+YJmw+P/g646i4NE+X
	 cihNXfr/nEHI59Urpv0X1cBsVgrm/Ucqvmn26xez5Mu1tRNmCgthlgLORJ7io+ggaF
	 n5cJsbjG3+GMcwU8QOukmj2c+GupCPIP7uWCBLqe8MGwTYRloGZgp323v38luQ30NJ
	 mW7oNVBaGNcmDubl5vC28z7tSXmRM5hih1cBEPIbXxAUPDAaA1Aj6dTaV2v0Lisbt7
	 pXMkbZca8YIKjd+PG62HyX9MJSt85cPFvup4+7j1/IUGN4ged0XkCeRKW91J5thFAD
	 WFjv33y/EG08Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F110E87232;
	Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: fix page fault following EEH recovery
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168642434805.30474.14730718900440917512.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 19:12:28 +0000
References: <20230608200143.2410139-1-drc@linux.vnet.ibm.com>
In-Reply-To: <20230608200143.2410139-1-drc@linux.vnet.ibm.com>
To: David Christensen <drc@linux.vnet.ibm.com>
Cc: manishc@marvell.com, aelior@marvell.com, skalluru@marvell.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 16:01:43 -0400 you wrote:
> In the last step of the EEH recovery process, the EEH driver calls into
> bnx2x_io_resume() to re-initialize the NIC hardware via the function
> bnx2x_nic_load().  If an error occurs during bnx2x_nic_load(), OS and
> hardware resources are released and an error code is returned to the
> caller.  When called from bnx2x_io_resume(), the return code is ignored
> and the network interface is brought up unconditionally.  Later attempts
> to send a packet via this interface result in a page fault due to a null
> pointer reference.
> 
> [...]

Here is the summary with links:
  - bnx2x: fix page fault following EEH recovery
    https://git.kernel.org/netdev/net/c/7ebe4eda4265

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



