Return-Path: <netdev+bounces-2376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C20701975
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7A441C20B8B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 19:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F262479E4;
	Sat, 13 May 2023 19:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799942583;
	Sat, 13 May 2023 19:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B657C4339E;
	Sat, 13 May 2023 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684005021;
	bh=REHf7EgiT9cfmIDG5iDRvXJ/VUyxKNWsx+skNYcLCLE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b0IJcsa2d0doIWc5BTgmW+LCMN9XF/bv4f0FXjJx/J7S6b/6NesUY+xAErgkFcpKL
	 9XmXWUZiLISl7i6W0F7/Y7jC4d30wdSdrq2cq0RBA5VfkCSwuywS4/EeAAmwsjehM1
	 JTH+iI7ZogofnAJS2sFJTcxHD0ERqRT8qQoeN26SpXB/NfeXZzKn0t+X5fVNY5qmlN
	 LZo7WHqKpZ9PSIs8krzIzR5uiuBEWLHWMkOaHMTorQtzSquF5U+H31yNhDm7+ZAQme
	 y19XBzEJaHIo5FsRuuc3IlKbDTDPj0ma/wIjMiSQs/QU0wMvbTmnY4mxMwzvEPcHta
	 atWZv4oFm5NpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7919E501EF;
	Sat, 13 May 2023 19:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] introduce skb_frag_fill_page_desc()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168400502094.13341.12095425560976446028.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 19:10:20 +0000
References: <20230511011213.59091-1-linyunsheng@huawei.com>
In-Reply-To: <20230511011213.59091-1-linyunsheng@huawei.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 09:12:11 +0800 you wrote:
> Most users use __skb_frag_set_page()/skb_frag_off_set()/
> skb_frag_size_set() to fill the page desc for a skb frag.
> It does not make much sense to calling __skb_frag_set_page()
> without calling skb_frag_off_set(), as the offset may depend
> on whether the page is head page or tail page, so add
> skb_frag_fill_page_desc() to fill the page desc for a skb
> frag.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: introduce and use skb_frag_fill_page_desc()
    https://git.kernel.org/netdev/net-next/c/b51f4113ebb0
  - [net-next,v2,2/2] net: remove __skb_frag_set_page()
    https://git.kernel.org/netdev/net-next/c/278fda0d52f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



