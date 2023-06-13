Return-Path: <netdev+bounces-10288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7361972D8F7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E226280F10
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 05:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F54E17F2;
	Tue, 13 Jun 2023 05:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A10361
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4E5EC433A1;
	Tue, 13 Jun 2023 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686633022;
	bh=NHdCIb1zv2Arlk5ZHNC+WxvFRKd8YhAHkgky6zU714g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EYYc3q/wMH0BEElR4x/aWfNiKnE71+w4S+tZLwcSdvjo1qGvXoaD/aG88sVhkjMHi
	 n+gGLe9BWmjKmKaLk8YKHBwPoV9VOu96aLes+jNv6RM6W34JpNbR76odLODm8h5evn
	 pAV08PHhJh3Jy0hpQRPuObLNH1miq6RhccmMFeHF/vIX4ERUOLbZxfoGKjhcO8Pyak
	 rrkODPSW/ch6e+/A6GLRZ878944LH6FSSwHYPk/Qgwq9PwnMTOKeOXamk98pUJR9qs
	 F5SVa8qZBGLrguJ4ekYlKP1OHRuLNY0UrbmNKq5jUCkxmnMUg+KNNkmaxx8vIJjl/z
	 MVGsuoSADZW/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7DEFE21EC0;
	Tue, 13 Jun 2023 05:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] splice,
 net: Some miscellaneous MSG_SPLICE_PAGES changes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168663302181.19155.9169104916425356557.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 05:10:21 +0000
References: <20230609100221.2620633-1-dhowells@redhat.com>
In-Reply-To: <20230609100221.2620633-1-dhowells@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com,
 dsahern@kernel.org, willy@infradead.org, axboe@kernel.dk, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Jun 2023 11:02:15 +0100 you wrote:
> Now that the splice_to_socket() has been rewritten so that nothing now uses
> the ->sendpage() file op[1], some further changes can be made, so here are
> some miscellaneous changes that can now be done.
> 
>  (1) Remove the ->sendpage() file op.
> 
>  (2) Remove hash_sendpage*() from AF_ALG.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] Remove file->f_op->sendpage
    https://git.kernel.org/netdev/net-next/c/a3bbdc52c38f
  - [net-next,2/6] algif: Remove hash_sendpage*()
    https://git.kernel.org/netdev/net-next/c/345ee3e8126a
  - [net-next,3/6] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
    https://git.kernel.org/netdev/net-next/c/5df5dd03a8f7
  - [net-next,4/6] tcp_bpf: Make tcp_bpf_sendpage() go through tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
    https://git.kernel.org/netdev/net-next/c/de17c6857301
  - [net-next,5/6] kcm: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
    https://git.kernel.org/netdev/net-next/c/264ba53fac79
  - [net-next,6/6] kcm: Send multiple frags in one sendmsg()
    https://git.kernel.org/netdev/net-next/c/c31a25e1db48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



