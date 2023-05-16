Return-Path: <netdev+bounces-2901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC51570479E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1A302812E4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06D0200C5;
	Tue, 16 May 2023 08:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9DC1FB0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54011C4339B;
	Tue, 16 May 2023 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684225219;
	bh=krJvGApWpDZE3wULpmNNLp1qsJHZ8ewLviLisENMOPc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TuQ1kOb8g/GV0jTEdzVrCm4bUfPJsrkbzzxnp2oTHPmkjnIvvLVKt1UCkolL/zhoP
	 OW7LjblHxqrGO41f/gA/vr59fcA05d0kT/7S9d2moXyoNah/GWd+NGeBU64PN+Wmi7
	 8Dj9PBgTi5U3slZfOuxGOPZtgtZv1912ce6ebMoeAdqHiT++vIBgV5MUK+BgEss9A2
	 0C1P52izX8xAWIOpU8sRKTPgpcZsqqqCNODv23VITb/q/sC8nvZAN/G8SBjaaeuHGa
	 p3+qxBJ/f6aUtJIuUrpNGXsR+8WuKjewh02nN/PSBfUq7dHXfVAZOi3xZyud5KC6ke
	 lFFKbYcZRPHsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3782AE5421E;
	Tue, 16 May 2023 08:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: skbuff: update comment about pfmemalloc
 propagating
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168422521922.26974.9051827263547501041.git-patchwork-notify@kernel.org>
Date: Tue, 16 May 2023 08:20:19 +0000
References: <20230515050107.46397-1-linyunsheng@huawei.com>
In-Reply-To: <20230515050107.46397-1-linyunsheng@huawei.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, asml.silence@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 15 May 2023 13:01:07 +0800 you wrote:
> __skb_fill_page_desc_noacc() is not doing any pfmemalloc
> propagating, and yet it has a comment about that, commit
> 84ce071e38a6 ("net: introduce __skb_fill_page_desc_noacc")
> may have accidentally moved it to __skb_fill_page_desc_noacc(),
> so move it back to __skb_fill_page_desc() which is supposed
> to be doing pfmemalloc propagating.
> 
> [...]

Here is the summary with links:
  - [net-next] net: skbuff: update comment about pfmemalloc propagating
    https://git.kernel.org/netdev/net-next/c/8b33485128ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



