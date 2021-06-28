Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03F83B6980
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhF1UMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237254AbhF1UMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:12:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4105B61CC9;
        Mon, 28 Jun 2021 20:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624911005;
        bh=G84eIvCb4yoPGwFdfp/WtlgNsLNBkGbVSvQfoaTF5lc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=udsiuzFax7O1NJdLXjwKDtXQqUEhh4pUSQc63Opds51FAzfpaMXTPN7rSTmPQ1iZc
         7YEwQkiAmm/qPPYnOr0GHlYKFE4jyc6Co+76zMx+0VhBMD+k7ILitsJYRxaglKCG7j
         kI6Mtt2LSt3EDt/o/GBNHCxFstj2xPZK7lEz9GHiGUlVmDN/NeQn4yi/q2SHR6/W8K
         UecGrTwzdqvVlgu6+1AUbgDmks8OPSf+9MdGk4qu8nprXY1zGf/nMy3pPbCWshVDuO
         XKtwh6+tWVZVGOFKxa6uy2lyNNZ5aAUdPp/oXVwTCNDByBg5r5mci2ZmW7UVI4J4oj
         sF7DJCcuBoWtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A5FD60CD0;
        Mon, 28 Jun 2021 20:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: reset MAC header consistently across L3
 virtual devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491100523.2562.3585552064216473782.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:10:05 +0000
References: <cover.1624572003.git.gnault@redhat.com>
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        simon.horman@netronome.com, martin.varghese@nokia.com,
        elic@nvidia.com, jbenc@redhat.com, tom@herbertland.com,
        pablo@netfilter.org, laforge@gnumonks.org, aschultz@tpip.net,
        jonas@norrbonn.se
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 25 Jun 2021 15:32:59 +0200 you wrote:
> Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
> reset the MAC header pointer after they parsed the outer headers. This
> accurately reflects the fact that the decapsulated packet is pure L3
> packet, as that makes the MAC header 0 bytes long (the MAC and network
> header pointers are equal).
> 
> However, many L3 devices only adjust the network header after
> decapsulation and leave the MAC header pointer to its original value.
> This can confuse other parts of the networking stack, like TC, which
> then considers the outer headers as one big MAC header.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] bareudp: allow redirecting bareudp packets to eth devices
    https://git.kernel.org/netdev/net-next/c/99c8719b7981
  - [net-next,2/6] ipip: allow redirecting ipip and mplsip packets to eth devices
    https://git.kernel.org/netdev/net-next/c/7ad136fd288c
  - [net-next,3/6] sit: allow redirecting ip6ip, ipip and mplsip packets to eth devices
    https://git.kernel.org/netdev/net-next/c/730eed2772e7
  - [net-next,4/6] gre: let mac_header point to outer header only when necessary
    https://git.kernel.org/netdev/net-next/c/aab1e898c26c
  - [net-next,5/6] ip6_tunnel: allow redirecting ip6gre and ipxip6 packets to eth devices
    https://git.kernel.org/netdev/net-next/c/da5a2e49f064
  - [net-next,6/6] gtp: reset mac_header after decap
    https://git.kernel.org/netdev/net-next/c/b2d898c8a523

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


