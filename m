Return-Path: <netdev+bounces-1389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEC66FDAC6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB36D28133A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE9E63E;
	Wed, 10 May 2023 09:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD0F811
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCCF5C433A1;
	Wed, 10 May 2023 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683711021;
	bh=BWaT6w7+cleNIrW0WKhDMKEGvKm+j6n/q6TFCZ+XkIk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gSRVyLTP4OIQ0M1Gmt6ahZ874sbqcWuzCY6GjFTNqRUxuxA0ab8kEUNhpWEhOhmIr
	 t4gIVia4hLc8c7trd2MsFj669LGPh1vzIc9aaNyXkUN8Bk4QR/3d/ePeCNIiUYs7Pk
	 guKcxALjtmU6b332u3W7X5Axp9M16FGa3vJWcfur1R50u5KqT3lUWo9oJJgudRraCz
	 0J7RO63pn+BYpgJUrmXJwJRV71lHg//KDjTL77DziBynWbfBe38zl8BbS9bt7L5SXL
	 l3Yro1WmR++vZpltPro6wqK1NNTRsAt2oFAf3QzdlMLj/8+vv8YU9SbbSgLXFujiOz
	 7sZGbcatNvPxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A829FE270C4;
	Wed, 10 May 2023 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: add vlan_get_protocol_and_depth() helper
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371102167.23581.3702029637827125454.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:30:21 +0000
References: <20230509131857.2947439-1-edumazet@google.com>
In-Reply-To: <20230509131857.2947439-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com,
 toke@redhat.com, willemb@google.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 13:18:57 +0000 you wrote:
> Before blamed commit, pskb_may_pull() was used instead
> of skb_header_pointer() in __vlan_get_protocol() and friends.
> 
> Few callers depended on skb->head being populated with MAC header,
> syzbot caught one of them (skb_mac_gso_segment())
> 
> Add vlan_get_protocol_and_depth() to make the intent clearer
> and use it where sensible.
> 
> [...]

Here is the summary with links:
  - [net] net: add vlan_get_protocol_and_depth() helper
    https://git.kernel.org/netdev/net/c/4063384ef762

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



