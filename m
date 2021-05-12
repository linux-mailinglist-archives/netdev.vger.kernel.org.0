Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BC037EE96
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346054AbhELVx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236445AbhELVLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ABD3F613EB;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620853810;
        bh=HvtWbcG+ucUe12rzbH4vDPHTjXcehYy0uSlUjrMc3mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=apXJom+Y/wh2UHu/99i48219iEdGS9DKZSQAEWvZkm2zb+D7AQgO00Al22qWrL+Cc
         GiYiIW7D/Xsi5QexWg0RiOEjdX71F46delw3SV4WXApWrFhrmRLPXwusjrEb+QkMFY
         mgDwm4q0d1hkiVfZaYFbOHyTphZ1Rq/ewmAxUq8KsQa1a08ngF0I2TUcSSexIwvGeY
         78SDiNT6eoqx+C/dPzGBiVL9DiEmji+WZqd5uqbh+7in2ugSA8b2LUyaaZEbruDYqM
         +K103S9Z8LqIEWmV3sgUVB8geD7/HEkiwy/49PQQoiaX/Hh+PaR1dGoKApC4U2YVEH
         xn8pc8JuiIaWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CF1560981;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: fixes for fec driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085381063.5514.1635133591072893262.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:10:10 +0000
References: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 10:43:58 +0800 you wrote:
> Two small fixes for fec driver.
> 
> Fugang Duan (2):
>   net: fec: fix the potential memory leak in fec_enet_init()
>   net: fec: add defer probe for of_get_mac_address
> 
>  drivers/net/ethernet/freescale/fec_main.c | 24 ++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net,1/2] net: fec: fix the potential memory leak in fec_enet_init()
    https://git.kernel.org/netdev/net/c/619fee9eb13b
  - [net,2/2] net: fec: add defer probe for of_get_mac_address
    https://git.kernel.org/netdev/net/c/052fcc453182

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


