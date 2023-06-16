Return-Path: <netdev+bounces-11553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAF5E7338AB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F06928187E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1436B1DCB9;
	Fri, 16 Jun 2023 19:00:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE051DCA8
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 562B2C433C8;
	Fri, 16 Jun 2023 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686942020;
	bh=teSmhnbNd2Y9ynIPY9m7ASM6Pzg+6PiTm476HdBc/ew=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QUTV15MwnSbaI8/Ep78V2gld/Jg4fT+7pwWtLWQgjPXLU4/Vatv/6fgWGqq//bTYB
	 IQUKf1bO5FWTjCoL4Hbf4UIc3hCSDD4h1Q8rHmjrVGNmQWnYr+bV09HrLfwW4ZtRwA
	 i2oOABSvmS44htOFSY/tU2QlVQyL56YcZUHC6HXgQoaeeleGN1mw/8wM13uRVvLFyv
	 3LQeTxGGARC5o1hPL8AHu4vdzv7OovVV9pP1kNRjItTyJXUmgsB29HIrRE40t/mTm4
	 TnnsNvPN2fANQ6IgKRFU5RIYI4GLsBLDvS5DiEFcOkAyB9Ltc7pTpqsmpPxQjWWJPL
	 yvASbxJkJZ+AQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33376E21EEA;
	Fri, 16 Jun 2023 19:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip, ip6: Fix splice to raw and ping sockets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168694202020.4240.5219219028692952674.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 19:00:20 +0000
References: <1410156.1686729856@warthog.procyon.org.uk>
In-Reply-To: <1410156.1686729856@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org,
 syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com,
 willemdebruijn.kernel@gmail.com, dsahern@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, axboe@kernel.dk,
 willy@infradead.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 09:04:16 +0100 you wrote:
> Splicing to SOCK_RAW sockets may set MSG_SPLICE_PAGES, but in such a case,
> __ip_append_data() will call skb_splice_from_iter() to access the 'from'
> data, assuming it to point to a msghdr struct with an iter, instead of
> using the provided getfrag function to access it.
> 
> In the case of raw_sendmsg(), however, this is not the case and 'from' will
> point to a raw_frag_vec struct and raw_getfrag() will be the frag-getting
> function.  A similar issue may occur with rawv6_sendmsg().
> 
> [...]

Here is the summary with links:
  - [net-next] ip, ip6: Fix splice to raw and ping sockets
    https://git.kernel.org/netdev/net-next/c/5a6f6873606e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



