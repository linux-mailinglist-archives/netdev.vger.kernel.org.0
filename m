Return-Path: <netdev+bounces-11777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B2073466D
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6122D1C209AF
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 13:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4A35226;
	Sun, 18 Jun 2023 13:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F339E1C32
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C2ACC433C0;
	Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687095620;
	bh=2hyS4/RHBEnq0Wqtzj+t+ZmWg2QArDPOi5kjDcBRwjI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PBdrQGUWCbc+i8g8r+LwJR4dHvKuWrufjdfmh9rmFqU+yoajtRWZ6SgOXFsQkDyZC
	 N7zUbTcTQ1g0fv9wJPYmN7WUU5bCXk/J/eOZk0Vk0uy1cdG+mLls7Qk9gsUPeu7Sw5
	 4rXH9jVmwDTzp76QSO0YvypNc1eyLHcb04B5eU2CYKEbGwzPppOQ05tGlgiipkMn3z
	 ZEMItnKOmA/s6XSGTtBY3yF22OSDYfoxKEyaJgAKSiFpYRWYj8GBA09HwZF/6XTyVY
	 kxnfkA6AT8OmIWXJYFORmqPA1YVXI6P3FpQa7dqj3ZbaeSY6x3pXzZJKPaAjN/Hi8h
	 45me6EH2lYBgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4487EC395C7;
	Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] crypto: Fix af_alg_sendmsg(MSG_SPLICE_PAGES) sglist
 limit
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168709562027.22941.17137534932175260669.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 13:40:20 +0000
References: <322883.1686863334@warthog.procyon.org.uk>
In-Reply-To: <322883.1686863334@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org,
 syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, axboe@kernel.dk, willy@infradead.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 15 Jun 2023 22:08:54 +0100 you wrote:
> When af_alg_sendmsg() calls extract_iter_to_sg(), it passes MAX_SGL_ENTS as
> the maximum number of elements that may be written to, but some of the
> elements may already have been used (as recorded in sgl->cur), so
> extract_iter_to_sg() may end up overrunning the scatterlist.
> 
> Fix this to limit the number of elements to "MAX_SGL_ENTS - sgl->cur".
> 
> [...]

Here is the summary with links:
  - [net-next] crypto: Fix af_alg_sendmsg(MSG_SPLICE_PAGES) sglist limit
    https://git.kernel.org/netdev/net-next/c/4380499218c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



