Return-Path: <netdev+bounces-7305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA6F71F976
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09072281950
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389DC23417;
	Fri,  2 Jun 2023 04:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC1F15A8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D416C4339B;
	Fri,  2 Jun 2023 04:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685681420;
	bh=rKUrvROCJrrMmfkN3sXGykdMoT4O9rrI9krcIvWypeA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KUuqS6WxiaBJuPxnHkHFhLKG1tzwLqI+Pb/vECSheeLf/vV/ppOWOX4XEnG9lkRD4
	 YddakJdZt866NP19NdK4pJBq2dxWej76At3kBExWHIa0us7AFEFSGXvqCURN25l7cM
	 pBH6mIwnygkKPNB+T1iS1MxmG9YQWjw0fjLPI51dx3xC9dLZufSqChWvA2YmfzPcJ8
	 Mc4LncLJYzMahpeLaPFwzguAg3lBmYhPTeNQy0ScWfZsL3YTadeaWgMoc00NSJruja
	 NyDQb1RCVQthf61LK7alTpk2DDOdz3bHJmMhgUVpzebmx9jrwGdrDW3Yat2ew40Yui
	 ykm5gpeB7Zheg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0CD3E49FA9;
	Fri,  2 Jun 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] neighbour: fix unaligned access to pneigh_entry
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568141998.21492.1839866290257514531.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 04:50:19 +0000
References: <20230601015432.159066-1-dqfext@gmail.com>
In-Reply-To: <20230601015432.159066-1-dqfext@gmail.com>
To: Qingfang DENG <dqfext@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, yoshfuji@linux-ipv6.org, nakam@linux-ipv6.org,
 vnuorval@tcs.hut.fi, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 qingfang.deng@siflower.com.cn

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Jun 2023 09:54:32 +0800 you wrote:
> From: Qingfang DENG <qingfang.deng@siflower.com.cn>
> 
> After the blamed commit, the member key is longer 4-byte aligned. On
> platforms that do not support unaligned access, e.g., MIPS32R2 with
> unaligned_action set to 1, this will trigger a crash when accessing
> an IPv6 pneigh_entry, as the key is cast to an in6_addr pointer.
> 
> [...]

Here is the summary with links:
  - [net,v2] neighbour: fix unaligned access to pneigh_entry
    https://git.kernel.org/netdev/net/c/ed779fe4c9b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



