Return-Path: <netdev+bounces-3835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A607090FE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 045501C21224
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AB22117;
	Fri, 19 May 2023 07:50:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06DA20F2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B0CDC433D2;
	Fri, 19 May 2023 07:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684482633;
	bh=gdC5qQr1W6bNI16LVMYlGukiO0yLZdjLqB7T94s6bBM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iR/seNoUZUoUeIm21p9Vdt0Jamm4EMai+4CSuNxg74Kq1yjNZ6S1sQulw8UYXKbM1
	 kfGtE8+3Cr/kPtxqiGYJgaiuaZGetNzZHPDpk9bfMvJhBDPXaVPe3gbHkar3iZlnZd
	 98Xrj7M9BsQIjUhdzUdvk9Wt4vPLZvr/3caTiMjCbHz5NSErTt22b2wfAmD3Bt1hHJ
	 nCsmMaKKtH2hnr6l2mqM0hoUXBytBUXwWN+3D1SUFJOdISyb2GBz7d8dOS4wCpGiAh
	 C3kxU4uiAGPo8wOSPD5CubtmJ87kSTaJVGJXdchfvBY/guEnDWkrMzQSx8nLeFqEMJ
	 F3xSZeSdLvORA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B27CC3959E;
	Fri, 19 May 2023 07:50:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/mlx5e: do as little as possible in napi poll when
 budget is 0
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448263343.27405.3135650014524847376.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 07:50:33 +0000
References: <20230517015935.1244939-1-kuba@kernel.org>
In-Reply-To: <20230517015935.1244939-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
 brouer@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 18:59:35 -0700 you wrote:
> NAPI gets called with budget of 0 from netpoll, which has interrupts
> disabled. We should try to free some space on Tx rings and nothing
> else.
> 
> Specifically do not try to handle XDP TX or try to refill Rx buffers -
> we can't use the page pool from IRQ context. Don't check if IRQs moved,
> either, that makes no sense in netpoll. Netpoll calls _all_ the rings
> from whatever CPU it happens to be invoked on.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5e: do as little as possible in napi poll when budget is 0
    https://git.kernel.org/netdev/net/c/afbed3f74830

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



