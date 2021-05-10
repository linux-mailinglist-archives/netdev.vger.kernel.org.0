Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DB0379972
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhEJVvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhEJVvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2DF0661554;
        Mon, 10 May 2021 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620683410;
        bh=JL63ffTaVqfD1Ut8MSH21HvXsH2wqkLPLLHv6gbmQbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RCudMGoEM21OhN1h8pMF7UXn7J7k3bUKyspHbXJlD1c+jPbeNzm2QHT3Cxl2ocB78
         UrdrD6dR46FaVec254orAafm6AhM6JJtvFU9SsRmwOmuPGMc4K67JQJ3jwhinEuoSv
         0YkkZ2DX3KsFFBLrOUML7OB0KVorHzP9vOXRQRUiZC9VWBgYewbobu7JRZN1RmlNEE
         ZktavtVZ11AeeAH2nRzMeqb/0wgrRXjsXXAjgz5zjY3qFuAd5a9KRgBGaXUuZ25zw1
         gNmobnyBfZ67IUJUIKbz9kr8c8MB4uJ9EBolp5c+OVKdDfkMsATw2X3xVFgnAcuid1
         eWck9dEEM+KUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 239C260A48;
        Mon, 10 May 2021 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: re-enable TAS guard band mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068341014.4733.5616214407177373815.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:50:10 +0000
References: <20210510110708.11504-1-michael@walle.cc>
In-Reply-To: <20210510110708.11504-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, xiaoliang.yang_1@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 10 May 2021 13:07:08 +0200 you wrote:
> Commit 316bcffe4479 ("net: dsa: felix: disable always guard band bit for
> TAS config") disabled the guard band and broke 802.3Qbv compliance.
> 
> There are two issues here:
>  (1) Without the guard band the end of the scheduling window could be
>      overrun by a frame in transit.
>  (2) Frames that don't fit into a configured window will still be sent.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: re-enable TAS guard band mode
    https://git.kernel.org/netdev/net/c/297c4de6f780

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


