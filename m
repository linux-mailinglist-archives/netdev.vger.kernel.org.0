Return-Path: <netdev+bounces-10087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE3772C1E6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC6041C20B13
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B505171BB;
	Mon, 12 Jun 2023 11:00:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C13134DD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46AFFC4339C;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686567624;
	bh=4GV/KJ8Nibwke28zwfqjD0Pfw+DYje+J2klmzuKRbbM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=vRFI1Os+Cyl2SFvxJZ3DCB/+2JWzMgl/HQNq6MC3UlgAZaIAYJKLjWgdzEaYQzEjm
	 ZWiTQgFxMtGLSFklr0xRn3A1GiG1oleS75Tda+zPVwt0kLFxeLcwkgBTRMCtexr0jZ
	 KOi8LpbBkObFLilapKycM7e5VauVajrTcm4f08ccP/g9tswAw1GNeZKqj3Jzzst0o2
	 D0HELhXGeknwmQCW4WpIhrCWW8nPpKJ4fWi3jwPM9K2lxXbLkVmVeiwJEoR7yD45/P
	 /2yXsMs11HD5l3QRDqrCcPsCopUzvkRwaZ9Zr4fu0WpV8Xb1Z0xKpOrcK4/Q/7Iyfr
	 ey4Gq9WjIv3xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23A97E21EC0;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] tcp: tx path fully headless
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656762414.2644.15171420897223940335.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 11:00:24 +0000
References: <20230609204246.715667-1-edumazet@google.com>
In-Reply-To: <20230609204246.715667-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 20:42:43 +0000 you wrote:
> This series completes transition of TCP stack tx path
> to headless packets : All payload now reside in page frags,
> never in skb->head.
> 
> Eric Dumazet (3):
>   tcp: let tcp_send_syn_data() build headless packets
>   tcp: remove some dead code
>   tcp: remove size parameter from tcp_stream_alloc_skb()
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] tcp: let tcp_send_syn_data() build headless packets
    https://git.kernel.org/netdev/net-next/c/fbf934068f6b
  - [net-next,2/3] tcp: remove some dead code
    https://git.kernel.org/netdev/net-next/c/b4a24397139c
  - [net-next,3/3] tcp: remove size parameter from tcp_stream_alloc_skb()
    https://git.kernel.org/netdev/net-next/c/5882efff88aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



