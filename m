Return-Path: <netdev+bounces-8677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 517907252AF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669832811BD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EA1A5B;
	Wed,  7 Jun 2023 04:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E367C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29835C433EF;
	Wed,  7 Jun 2023 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686111021;
	bh=pE9H11vu1kE72HaDlJN5pwU1KMF7Iolf0UOrwRjn0Ro=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DHq48AIPcYpTd6I2K2eMQAOaX7IjDxSsLzqHO/99wF4BJmpnE/VLcjrVv2BtLSFyF
	 qXr7iVIm5Zc2O9QMbQgBQgFwtptlpsI7YxSyylbVY5wduicfs805QmW5de4V/O0unN
	 wY49smiRFJt9XN6D3ztkhwUAPiHYcVd/lsbzmccPTCMIY4gDn15FEM148NVrHgi9ZW
	 kR5Po8kufwUHKUhW7VNp0p9c9K0r9cE2QrEEWEA1iWxGwgVP9VCaDgn3JQXHlOSUwb
	 xGCmtAbkJx8r+CAIDl8Gbgm2fsSIzoundH6qObLeDcvVs51ScqvB5CFV4hxuwXf8sf
	 +woTTkjFN8kiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFE73E8723C;
	Wed,  7 Jun 2023 04:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] tcp: gso: really support BIG TCP
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611102090.26028.14307356797046850878.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 04:10:20 +0000
References: <20230605161647.3624428-1-edumazet@google.com>
In-Reply-To: <20230605161647.3624428-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, alexanderduyck@fb.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Jun 2023 16:16:47 +0000 you wrote:
> We missed that tcp_gso_segment() was assuming skb->len was smaller than 65535 :
> 
> oldlen = (u16)~skb->len;
> 
> This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO problems.")
> 
> This leads to wrong TCP checksum.
> 
> [...]

Here is the summary with links:
  - [v2,net] tcp: gso: really support BIG TCP
    https://git.kernel.org/netdev/net/c/82a01ab35bd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



