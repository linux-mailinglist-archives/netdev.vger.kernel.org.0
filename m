Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0BA33F8A7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhCQTA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232907AbhCQTAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32B9E64F57;
        Wed, 17 Mar 2021 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616007611;
        bh=9EhX63ORelXK63RiVqvtbbW1ZglAn2dEYYsY5yAdFNI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dFbs7ZbPLlcy7EL4UlAgrBmpRtE3zHAKjgQbkLD4ezaagVOYk5Q9XZyJFoJRgjeQz
         vNyUgHkngC805XcJxf7/rg8KXk4tZdSWUudGntqJWTfCSg+X+tghALQdf5xBv0pbl5
         2hQuIVFM2yc0DO7YQLnWhEf8pcaTfnDbbn7r+wXm7AgPBbZO/TaFLNYuD2FNP9aTgg
         BF8Bepx206XgTEKxvP4rLSOvJs2njw4sgV0sQf3Nx9gedKLF5oSWW0owbPefCS1Fwn
         FuEoCg3yx22uEhqbBZ8WylQ2nlpKcJjn8cjWqRT0c/6zYR7muHrJpcfBGZlw1GCsXO
         pBNZ+5uUKPQHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2CCDA60997;
        Wed, 17 Mar 2021 19:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 00/16] tipc: cleanups and simplifications
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600761117.6499.6305586975378624608.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:00:11 +0000
References: <20210317020623.1258298-1-jmaloy@redhat.com>
In-Reply-To: <20210317020623.1258298-1-jmaloy@redhat.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 22:06:07 -0400 you wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> We do a number of cleanups and simplifications, especially regarding
> call signatures in the binding table. This makes the code easier to
> understand and serves as preparation for upcoming functional additions.
> 
> Jon Maloy (16):
>   tipc: re-organize members of struct publication
>   tipc: move creation of publication item one level up in call chain
>   tipc: introduce new unified address type for internal use
>   tipc: simplify signature of tipc_namtbl_publish()
>   tipc: simplify call signatures for publication creation
>   tipc: simplify signature of tipc_nametbl_withdraw() functions
>   tipc: rename binding table lookup functions
>   tipc: refactor tipc_sendmsg() and tipc_lookup_anycast()
>   tipc: simplify signature of tipc_namtbl_lookup_mcast_sockets()
>   tipc: simplify signature of tipc_nametbl_lookup_mcast_nodes()
>   tipc: simplify signature of tipc_nametbl_lookup_group()
>   tipc: simplify signature of tipc_service_find_range()
>   tipc: simplify signature of tipc_find_service()
>   tipc: simplify api between binding table and topology server
>   tipc: add host-endian copy of user subscription to struct
>     tipc_subscription
>   tipc: remove some unnecessary warnings
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] tipc: re-organize members of struct publication
    https://git.kernel.org/netdev/net-next/c/998d3907f419
  - [net-next,02/16] tipc: move creation of publication item one level up in call chain
    https://git.kernel.org/netdev/net-next/c/b26b5aa9cebe
  - [net-next,03/16] tipc: introduce new unified address type for internal use
    https://git.kernel.org/netdev/net-next/c/7823f04f34b8
  - [net-next,04/16] tipc: simplify signature of tipc_namtbl_publish()
    https://git.kernel.org/netdev/net-next/c/50a3499ab853
  - [net-next,05/16] tipc: simplify call signatures for publication creation
    https://git.kernel.org/netdev/net-next/c/a45ffa68573e
  - [net-next,06/16] tipc: simplify signature of tipc_nametbl_withdraw() functions
    https://git.kernel.org/netdev/net-next/c/2c98da079063
  - [net-next,07/16] tipc: rename binding table lookup functions
    https://git.kernel.org/netdev/net-next/c/66db239c4894
  - [net-next,08/16] tipc: refactor tipc_sendmsg() and tipc_lookup_anycast()
    https://git.kernel.org/netdev/net-next/c/908148bc5046
  - [net-next,09/16] tipc: simplify signature of tipc_namtbl_lookup_mcast_sockets()
    https://git.kernel.org/netdev/net-next/c/45ceea2d403b
  - [net-next,10/16] tipc: simplify signature of tipc_nametbl_lookup_mcast_nodes()
    https://git.kernel.org/netdev/net-next/c/833f867089e5
  - [net-next,11/16] tipc: simplify signature of tipc_nametbl_lookup_group()
    https://git.kernel.org/netdev/net-next/c/006ed14ef82b
  - [net-next,12/16] tipc: simplify signature of tipc_service_find_range()
    https://git.kernel.org/netdev/net-next/c/13c9d23f6ac3
  - [net-next,13/16] tipc: simplify signature of tipc_find_service()
    https://git.kernel.org/netdev/net-next/c/6e44867b01e6
  - [net-next,14/16] tipc: simplify api between binding table and topology server
    https://git.kernel.org/netdev/net-next/c/09f78b851ea3
  - [net-next,15/16] tipc: add host-endian copy of user subscription to struct tipc_subscription
    https://git.kernel.org/netdev/net-next/c/429189acac53
  - [net-next,16/16] tipc: remove some unnecessary warnings
    https://git.kernel.org/netdev/net-next/c/5c8349503d00

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


