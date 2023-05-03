Return-Path: <netdev+bounces-117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C960F6F5325
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3DAE1C20D0E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51A5EA5;
	Wed,  3 May 2023 08:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D921BA31
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CED4C433D2;
	Wed,  3 May 2023 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102620;
	bh=nqWIGxhQ2qtdB99jGM8dmNjyV9zAERLRtd5Aaij9hdE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XGK4HZ4bcS4bYo3ECikftqTW7eIJnMuaFNNjKqFtFoxJU5a0NcQKNMiCFsUuRBVHi
	 8Ef4Uxy70acuTtZV65bestmB3U90C/q89QYLWBiTlZaeyZeS1ZO8abJ2I2LAdJz96T
	 VAG11cZ4Jeo8l3Tg3XBQ1G2zjr126MnpDSGlOtJ2jkwb2lz3vwTIkHW1EZ1HpVizep
	 bvsGJOVuJ6qDTzLyoF1LXng+oLIef/YyPSJ8gnEsBPcTYOxp8vddXYQxgrxaCqdx/2
	 0hmolkmdhXw0KPG0PHNS9hS6zLGV9tNjJrwMvQC6GZryvgKlnM3p24UW9eKYVr6kgq
	 k6DABjh6+0oow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2110FC395FD;
	Wed,  3 May 2023 08:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] af_packet: Don't send zero-byte data in
 packet_sendmsg_spkt().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310262013.27685.18073876722871845262.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:30:20 +0000
References: <20230501202856.98962-1-kuniyu@amazon.com>
In-Reply-To: <20230501202856.98962-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, willemdebruijn.kernel@gmail.com, shaozhengchao@huawei.com,
 kuni1840@gmail.com, netdev@vger.kernel.org, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 1 May 2023 13:28:57 -0700 you wrote:
> syzkaller reported a warning below [0].
> 
> We can reproduce it by sending 0-byte data from the (AF_PACKET,
> SOCK_PACKET) socket via some devices whose dev->hard_header_len
> is 0.
> 
>     struct sockaddr_pkt addr = {
>         .spkt_family = AF_PACKET,
>         .spkt_device = "tun0",
>     };
>     int fd;
> 
> [...]

Here is the summary with links:
  - [v2,net] af_packet: Don't send zero-byte data in packet_sendmsg_spkt().
    https://git.kernel.org/netdev/net/c/6a341729fb31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



