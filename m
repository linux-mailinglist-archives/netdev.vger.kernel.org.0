Return-Path: <netdev+bounces-5606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F70F7123E6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29D4F1C20FE1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C421548E;
	Fri, 26 May 2023 09:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DD111B8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E31B8C433D2;
	Fri, 26 May 2023 09:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685094020;
	bh=SWRLH0NIHJFfMDLCo4Wq6EQJEgdqnhfHMCeaBi81ZL8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ElBrTWgrFoXW3aLa9F4+7w4j/6zrqUR5R/KDn+xutho7JaQg/5UKPHHetsg7Lb4oB
	 zdu7KE/z5k6iH+MpEgJpaWZKg9vYLXeNqoQ96uGLuwWDCB/eDvXg24fWHnurlxmcxw
	 rL/T9VrdJsDRrlsKBFDTdJh7V/7KhB16atsFocCTjny5WQHEjMsRGEQV1E+1Z+MmKM
	 IO78yazEvT8KkC01XWizBxt0ShI2VyLDwdyQJEEASs3JSfF4+MPCBlX8lDxVbIOnWx
	 mFEUS2kOCqFp+iyjL3EZifHOCzIKZV1GsQfQCAln5xCxdl4IaWCLDAgbCZclHPophA
	 R19qHprLvP7LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7490C4166F;
	Fri, 26 May 2023 09:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tls: improve lockless access safety of tls_err_abort()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168509401974.30918.3445051497579032375.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 09:40:19 +0000
References: <20230525051741.2223624-1-kuba@kernel.org>
In-Reply-To: <20230525051741.2223624-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 24 May 2023 22:17:41 -0700 you wrote:
> Most protos' poll() methods insert a memory barrier between
> writes to sk_err and sk_error_report(). This dates back to
> commit a4d258036ed9 ("tcp: Fix race in tcp_poll").
> 
> I guess we should do the same thing in TLS, tcp_poll() does
> not hold the socket lock.
> 
> [...]

Here is the summary with links:
  - [net] tls: improve lockless access safety of tls_err_abort()
    https://git.kernel.org/netdev/net/c/8a0d57df8938

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



