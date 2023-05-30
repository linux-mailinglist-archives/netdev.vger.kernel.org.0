Return-Path: <netdev+bounces-6233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C70547154BC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AB391C20B2F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85FE4A16;
	Tue, 30 May 2023 05:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694E43D74
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0865DC433D2;
	Tue, 30 May 2023 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685423421;
	bh=vk92pUrdZgf6BAIvS8xJuaMroCSpDnuHXtMSOdBHGU8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=otEzTFz26u3L+I8wp8hzdCM5DGSzAA4iUnE8FlfZm7ewt7opqfAIZYDXNik4YnpGk
	 JNapdHTD5SrMSoqEfZnLv/81Pnm7VSixn9GiVwr4Eg3K7r61tgdQmX6OmasX7x+fFp
	 8HaKf7kH6UGwkRaFHE9nFTQsnhXH2CzD7MaYXVXbr2j+lSHZaZAblyMh3ceS9fOk/C
	 XCwfOfVwbrFF/j1m2hv5wc+6W6VGcg/e+rAMilREmelYVVRPPM/aog3YpMahE4s265
	 wZHEJJCdtUWFN31YWw3SMnHFDRFJTHkY+mPPEu++efQHn812WSDzNGo0ncHOMn54UV
	 uuCCcgYJncnoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9096E52BF8;
	Tue, 30 May 2023 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: fix signedness bug in skb_splice_from_iter()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542342088.26777.17946753562179966194.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:10:20 +0000
References: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
In-Reply-To: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alexanderduyck@fb.com, brouer@redhat.com,
 asml.silence@gmail.com, keescook@chromium.org, jbenc@redhat.com,
 netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 16:39:15 +0300 you wrote:
> The "len" variable needs to be signed for the error handling to work
> correctly.
> 
> Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> v2: tidy up a style mistake in v1.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: fix signedness bug in skb_splice_from_iter()
    https://git.kernel.org/netdev/net-next/c/ef1bc119ceb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



