Return-Path: <netdev+bounces-11009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B88D673114C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA0C2816B2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE62720F0;
	Thu, 15 Jun 2023 07:50:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8983020E3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D342C433C8;
	Thu, 15 Jun 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686815419;
	bh=uXXz4yd7ee+6QGrv/NuvRMJeE5gSJfqC9YZGaaJo6WU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=khPEWZ0o7q7MaBPuSsXiKEQH8CeXfdRoTOLtbN1SWp3dHEOPGoIWCFLydNrd1iiaO
	 gleU9AXCQfBQelJC/Cqu4itv3ZNHzG+CvBC+Spxia8wF6Bz2aKoSlipAbQAb6Uki+G
	 WFXK7/8HE6e67lvyk27q2uuId9Dj9eRgLxLdyHji8veoUF3/9YGJE97q+MengkmFg+
	 +Qu65VFyQfqCCvZrBj1ZpCFkTGhdjuYhwep33QUsuGsRkkYnVxqtkn9/ea9u+D1t23
	 2jxxW/dZ3dY+5rofQM39KUR5A121TkCoAE85ylac7T4MTJl+Cgj9/a58Ev97bseqeI
	 MxoJ2ACnuw3+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33725C3274B;
	Thu, 15 Jun 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] s390/ism: Fix trying to free already-freed IRQ by repeated
 ism_dev_exit()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168681541920.22382.10439773407681596212.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 07:50:19 +0000
References: <20230613-ism-rmmod-crash-v1-1-359ac51e18c9@linux.ibm.com>
In-Reply-To: <20230613-ism-rmmod-crash-v1-1-359ac51e18c9@linux.ibm.com>
To: Julian Ruess <julianr@linux.ibm.com>
Cc: wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, davem@davemloft.net, jaka@linux.ibm.com,
 raspl@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, schnelle@linux.ibm.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 13 Jun 2023 14:25:37 +0200 you wrote:
> This patch prevents the system from crashing when unloading the ISM module.
> 
> How to reproduce: Attach an ISM device and execute 'rmmod ism'.
> 
> Error-Log:
> - Trying to free already-free IRQ 0
> - WARNING: CPU: 1 PID: 966 at kernel/irq/manage.c:1890 free_irq+0x140/0x540
> 
> [...]

Here is the summary with links:
  - s390/ism: Fix trying to free already-freed IRQ by repeated ism_dev_exit()
    https://git.kernel.org/netdev/net/c/78d0f94902af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



