Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0193F35E869
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhDMVka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232542AbhDMVk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 17:40:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB8F46135C;
        Tue, 13 Apr 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618350009;
        bh=9MZvi8IBDVbsrKJUBKDAgybMuvC/9Cey0IZKP5Rnd7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W5gPlV6vVKZeKdjZuOwHShI6DPMC+0Zp0T3vkoLEcgg7efCgUyldshJy2PJul7yT5
         DTduYzMF6jThNR3FyBBZxOy69Xmmq/6h/6pFCd10Bw95/8J9TMHlg2qL/5QsroIf2F
         /aUUvlHULBtxzrDyCWYvTFEC0AWIOhHdrJCd0CTaUaWHOU7RyilTA88uHjpM+jWW7X
         fAmd95ZWEnNy+YOh8Na3Jdo92Qrey4W5d1IkM8c8ZEqbtg2hKfX9/7/qvqS/z3zMkf
         P1PQM5UHelTqSPiNrMxp45cUM99pAbo6sNAspXfmAh4ZeKzkM5I/qzXU43m1cfJzof
         SE6nK/qZiCrdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C682A60CCF;
        Tue, 13 Apr 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: sit: Unregister catch-all devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835000980.18297.6217515170501790965.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 21:40:09 +0000
References: <20210412174117.299570-1-hristo@venev.name>
In-Reply-To: <20210412174117.299570-1-hristo@venev.name>
To:     Hristo Venev <hristo@venev.name>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 12 Apr 2021 20:41:16 +0300 you wrote:
> A sit interface created without a local or a remote address is linked
> into the `sit_net::tunnels_wc` list of its original namespace. When
> deleting a network namespace, delete the devices that have been moved.
> 
> The following script triggers a null pointer dereference if devices
> linked in a deleted `sit_net` remain:
> 
> [...]

Here is the summary with links:
  - [1/2] net: sit: Unregister catch-all devices
    https://git.kernel.org/netdev/net/c/610f8c0fc8d4
  - [2/2] net: ip6_tunnel: Unregister catch-all devices
    https://git.kernel.org/netdev/net/c/941ea91e87a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


