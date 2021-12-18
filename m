Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9A2479AC3
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhLRMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:40:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34060 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhLRMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BBD460B67;
        Sat, 18 Dec 2021 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96200C36AEF;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639831210;
        bh=qdD3EG/hSwDS/LzVyVWBoJlrOW5+oGyhgZG+a6l/4JQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XF3jEmsB3v2h1f2rfl3DLD4J8U4In6SOfefVb1mUdb3++sWJBU0/Do8+egXFGp3Db
         bd76+KNhpM5Tq6qkJekEa3UPS+mD12nF5ZLhZt+FBGcnnCo5u5bmiOf4pfQXRddY8S
         EdJXE4PlL/fg8cWJTqr005sV78lygScMFyg+O9aukXzor3bePPnimOZl+5szjmowaE
         PCK9Gr09g9gPxUoDBVe+l1ytviLNsG2ufjtc8UpbCmL9nafn93LCQn/YqJeATtWZqL
         +y39vhIBD2SGALMEJ5kW9jHpe2svLdNqCq7vjGz7rdGRHXBkb59lRLm7zr3CXcXbr8
         U9m4EDOssTDHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 861FB60A4F;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xdp: move the if dev statements to the first
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163983121054.1461.2128609584569863556.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 12:40:10 +0000
References: <20211217092545.30204-1-yajun.deng@linux.dev>
In-Reply-To: <20211217092545.30204-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Dec 2021 17:25:45 +0800 you wrote:
> The xdp_rxq_info_unreg() called by xdp_rxq_info_reg() is meaningless when
> dev is NULL, so move the if dev statements to the first.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/xdp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] xdp: move the if dev statements to the first
    https://git.kernel.org/netdev/net-next/c/f85b244ee395

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


