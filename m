Return-Path: <netdev+bounces-7347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D239F71FCE8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80F5E2816DB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632EB17743;
	Fri,  2 Jun 2023 09:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2202171AA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F09D8C4339B;
	Fri,  2 Jun 2023 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685696419;
	bh=Fk+l9DZKdsNSTjZvKyeObVaDm8wwUDqpLO+9WsZPdEw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IIKmcfkUUlA2fe5Xfh142xIFb6lo27nYLbTfDQTN5/g1FatT1Dqh9Ww6yw8WvDvAd
	 cPkoI5qQlgD+OfAa2EjMjHZim2Hplz31cRwJ8FF09LCAbA48PR6efgsoYqatv5d4ar
	 m9JA8wFlafeZkBhGTYHPQb2jxo45eJjtXgUP3bLnk3niElDBGoldabjmsRF8M9mQHD
	 ZnKGjBaFMCr6wD0a8kCWJz+GyeHjW661/M2xS8HXEeh9ZCS46YF2WxLQ/Fscci5nIj
	 mpXWtPy2rnMLRy90ROg3qUPmz0KxtyCG1dJufficp1tUj04d5UEFCukWPT3IXDUhXF
	 vkuH8JmDeH2ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D30AFC395E0;
	Fri,  2 Jun 2023 09:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/ipv4: ping_group_range: allow GID from 2147483648
 to 4294967294
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168569641886.3424.10702306383468804424.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 09:00:18 +0000
References: <20230601031305.55901-1-akihiro.suda.cz@hco.ntt.co.jp>
In-Reply-To: <20230601031305.55901-1-akihiro.suda.cz@hco.ntt.co.jp>
To: Akihiro Suda <suda.gitsendemail@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, segoon@openwall.com,
 kuniyu@amazon.com, akihiro.suda.cz@hco.ntt.co.jp, suda.kyoto@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  1 Jun 2023 12:13:05 +0900 you wrote:
> With this commit, all the GIDs ("0 4294967294") can be written to the
> "net.ipv4.ping_group_range" sysctl.
> 
> Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid() in
> include/linux/uidgid.h), and an attempt to register this number will cause
> -EINVAL.
> 
> [...]

Here is the summary with links:
  - [net,v3] net/ipv4: ping_group_range: allow GID from 2147483648 to 4294967294
    https://git.kernel.org/netdev/net/c/e209fee4118f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



