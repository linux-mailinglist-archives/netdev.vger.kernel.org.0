Return-Path: <netdev+bounces-11296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 672417326F7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97E841C20F61
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1F04694;
	Fri, 16 Jun 2023 06:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF732ED0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46FE6C433C9;
	Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686895223;
	bh=nqLqzNx7gUZu0xo6s7uaBOSAsUVCyWFz/UHAUJVeRV4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Pqh6JaPKYMdxV8IfBYl7MWnpUd5cbXHUu55G3vSNWFwKzECHhhcIrAcrRdGwF1aIK
	 NBjTx4NN3ONoaCq85T17XCLRoZuY76G/0yoTyqFlYluZ2LRuzEej8q2fjLNOwgDA9m
	 leHQF7cuRf8WSTB8wKP+v1hK5jeXMNUf1abiXY33F1o1BAGkjtYKlMKUY24aSPQc0O
	 GtGrKdCW8kb86gfhoDSVFYdeyjhk6XAiv7N2su+1IF9cayd7k7MuB5tcfg5qJcFg5f
	 fH9GbLJ3/bvZcrKvki3w0fUDq+uMiC4PXhgEH7myyXb7xFJfx+SUhiob2sUPxuyLKv
	 f1wp7/7UN9vfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FF97E49BBF;
	Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] splice,
 net: Fix splice_to_socket() to handle pipe bufs larger than a page
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689522312.30897.4975538278032137122.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 06:00:23 +0000
References: <1428985.1686737388@warthog.procyon.org.uk>
In-Reply-To: <1428985.1686737388@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org,
 syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com,
 willemdebruijn.kernel@gmail.com, dsahern@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, axboe@kernel.dk,
 willy@infradead.org, brauner@kernel.org, viro@zeniv.linux.org.uk,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 11:09:48 +0100 you wrote:
> splice_to_socket() assumes that a pipe_buffer won't hold more than a single
> page of data - but this assumption can be violated by skb_splice_bits()
> when it splices from a socket into a pipe.
> 
> The problem is that splice_to_socket() doesn't advance the pipe_buffer
> length and offset when transcribing from the pipe buf into a bio_vec, so if
> the buf is >PAGE_SIZE, it keeps repeating the same initial chunk and
> doesn't advance the tail index.  It then subtracts this from "remain" and
> overcounts the amount of data to be sent.
> 
> [...]

Here is the summary with links:
  - [net-next] splice, net: Fix splice_to_socket() to handle pipe bufs larger than a page
    https://git.kernel.org/netdev/net-next/c/ca2d49f77ce4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



