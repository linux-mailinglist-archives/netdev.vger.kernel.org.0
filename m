Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB39345061
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCVUAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhCVUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA1756198E;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443208;
        bh=4jgTN6ojCCD0JVn9q1wWywSnw2YcEIzNqGndcCOVxqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZB7p3nGoqs8Xp5bsm+vJEHKGE78hmMMtHqYiEGqWd/zRhXfVWyXU0aAGCYx5DzEb5
         4je9ezzMW79ykLuzeZEvI+JnXuieYBbaa6ejIfq8SEeiQcLec+KlZCcNsyzSDpiATI
         EgPq7S54rPyQHZzLGvXBb1Fmy2Wdjrjq+0mJ9yWoi8+zm4Z7qOaW6C4kETZHVlNlYI
         hXnh4Iid7w8P+2o4UvFVLyyHGF2kFFBZLLSWOLmUdpgkH5hjSQzLvb2wSAoPeF3C5G
         VhdEk9yOREoRspPEaY3oYG9VGrPgLlf3+xNIJo/MFjsPlxDjbH9TBsgfu4nHvDaBAY
         LG2Rz99ojJCAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AAC7E609F6;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/3] Add support for Actions Semi Owl Ethernet MAC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644320869.18911.13353114414768088371.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:00:08 +0000
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
In-Reply-To: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        robh+dt@kernel.org, afaerber@suse.de, mani@kernel.org,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 01:29:42 +0200 you wrote:
> This patch series adds support for the Ethernet MAC found on the Actions
> Semi Owl family of SoCs.
> 
> For the moment I have only tested the driver on RoseapplePi SBC, which is
> based on the S500 SoC variant. It might work on S900 as well, but I cannot
> tell for sure since the S900 datasheet I currently have doesn't provide
> any information regarding the MAC registers - so I couldn't check the
> compatibility with S500.
> 
> [...]

Here is the summary with links:
  - [v3,1/3] dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
    https://git.kernel.org/netdev/net-next/c/fd42327f31bb
  - [v3,2/3] net: ethernet: actions: Add Actions Semi Owl Ethernet MAC driver
    https://git.kernel.org/netdev/net-next/c/de6e0b198239
  - [v3,3/3] MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC
    https://git.kernel.org/netdev/net-next/c/b31f51832acf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


