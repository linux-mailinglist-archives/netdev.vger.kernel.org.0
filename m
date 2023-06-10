Return-Path: <netdev+bounces-9846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC4872AE3C
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 21:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 161491C20A7A
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C95200DA;
	Sat, 10 Jun 2023 19:02:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA66B2F4D
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 19:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80F71C433EF;
	Sat, 10 Jun 2023 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686423740;
	bh=xfDuIxRevw0QRKypgrIkHN6eT7in5zBj6+K+rcyGiKQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QbVtD8wNX9lRYP9NpZSONaRR67DYr0OD1NgFol5ZGQ2+SQHIhv3+rRJ6hQYeKtc9P
	 xw1qdifuHqQ2zkSc+Xjlu1MH9/aqFMXgJBWPxpdzd62RtRd1AhY3DVWQzXPna63z5T
	 IrrgOoKy01iaZl9OXf9ftlHW/CkCjJ/WoRpfmMp9u09FRm9Ib4MiDz2N6mIJuqsZmA
	 7uJ/LLMlXif3fDwQLlO6jjANXH8mDNr3VQzvkpxGMfTX+d0T2pmYgoCgE9Sr5dXrVJ
	 l1AXhBCorheLzHnltTqILgpCxkSYQjS1bN8CvPs24RJ9Vr3K/AzAV1XkdaAk/461Ie
	 Stb26VJHO11qQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62C08E87232;
	Sat, 10 Jun 2023 19:02:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netlabel: fix shift wrapping bug in netlbl_catmap_setlong()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168642374040.25242.3572082546685041139.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 19:02:20 +0000
References: <20230608135754.25044-1-dmastykin@astralinux.ru>
In-Reply-To: <20230608135754.25044-1-dmastykin@astralinux.ru>
To: Dmitry Mastykin <dmastykin@astralinux.ru>
Cc: paul@paul-moore.com, netdev@vger.kernel.org,
 linux-security-module@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 16:57:54 +0300 you wrote:
> There is a shift wrapping bug in this code on 32-bit architectures.
> NETLBL_CATMAP_MAPTYPE is u64, bitmap is unsigned long.
> Every second 32-bit word of catmap becomes corrupted.
> 
> Signed-off-by: Dmitry Mastykin <dmastykin@astralinux.ru>
> ---
>  net/netlabel/netlabel_kapi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - netlabel: fix shift wrapping bug in netlbl_catmap_setlong()
    https://git.kernel.org/netdev/net/c/b403643d154d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



