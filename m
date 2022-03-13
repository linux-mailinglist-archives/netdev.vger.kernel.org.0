Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FE24D743F
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiCMKbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 06:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiCMKbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 06:31:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B495A92D2C;
        Sun, 13 Mar 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04BD8CE0F7F;
        Sun, 13 Mar 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0106C340F4;
        Sun, 13 Mar 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647167413;
        bh=yZRakI9TBNyMLlv9s/p5GfN7xSbI6G1mtsA3O7abnzU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M5ZbfX7EcFuhEPKjJktSg5sAqriRIOL640X6NXn/tvtupO3n41TIrXgHm2yntFqqw
         coRAJ9cRjFxoPDjwir59m86qnZRveLLkZVlhhyRStMcnEPuiCFeAOfKe+5K+St91/o
         SH4DeqHvodXja6l14niUS5iYSPKiGxn+lZVfVIkppJFWwONN9aUEfFYOqI62jjRXVo
         TqYWg7RcW8Qj+9fVvNW36a8D0g63i140FS2jU7461JbjfkrfavrADiJal0CSR0CCKH
         GvwFGp1vzZn9/8NlWYb0XazOQD1Mb7TGVBPdBGPKdpvjFJzywguOD/S6u0z7y8RmBS
         MXQJ0NttnyXXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3A41E6D3DD;
        Sun, 13 Mar 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/13] can: vxcan: vxcan_xmit(): use kfree_skb()
 instead of kfree() to free skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164716741286.31331.17220555710715399821.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Mar 2022 10:30:12 +0000
References: <20220313085138.507062-2-mkl@pengutronix.de>
In-Reply-To: <20220313085138.507062-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, lkp@intel.com, dan.carpenter@oracle.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sun, 13 Mar 2022 09:51:26 +0100 you wrote:
> This patch fixes the freeing of the "oskb", by using kfree_skb()
> instead of kfree().
> 
> Fixes: 1574481bb3de ("vxcan: remove sk reference in peer skb")
> Link: https://lore.kernel.org/all/20220311123741.382618-1-mkl@pengutronix.de
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] can: vxcan: vxcan_xmit(): use kfree_skb() instead of kfree() to free skb
    https://git.kernel.org/netdev/net-next/c/fc7dcd05f4c2
  - [net-next,02/13] can: mcp251xfd: mcp251xfd_ring_init(): use %d to print free RAM
    https://git.kernel.org/netdev/net-next/c/c47675b11ba1
  - [net-next,03/13] can: mcp251xfd: ram: add helper function for runtime ring size calculation
    https://git.kernel.org/netdev/net-next/c/a1439a5add62
  - [net-next,04/13] can: mcp251xfd: ram: coalescing support
    https://git.kernel.org/netdev/net-next/c/b8123d94f58c
  - [net-next,05/13] can: mcp251xfd: ethtool: add support
    https://git.kernel.org/netdev/net-next/c/d86ba8db6af3
  - [net-next,06/13] can: mcp251xfd: ring: prepare support for runtime configurable RX/TX ring parameters
    https://git.kernel.org/netdev/net-next/c/0a1f2e6502a1
  - [net-next,07/13] can: mcp251xfd: update macros describing ring, FIFO and RAM layout
    https://git.kernel.org/netdev/net-next/c/c9e6b80dfd48
  - [net-next,08/13] can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters
    https://git.kernel.org/netdev/net-next/c/9263c2e92be9
  - [net-next,09/13] can: mcp251xfd: add RX IRQ coalescing support
    https://git.kernel.org/netdev/net-next/c/60a848c50d2d
  - [net-next,10/13] can: mcp251xfd: add RX IRQ coalescing ethtool support
    https://git.kernel.org/netdev/net-next/c/846990e0ed82
  - [net-next,11/13] can: mcp251xfd: add TX IRQ coalescing support
    https://git.kernel.org/netdev/net-next/c/169d00a25658
  - [net-next,12/13] can: mcp251xfd: add TX IRQ coalescing ethtool support
    https://git.kernel.org/netdev/net-next/c/656fc12ddaf8
  - [net-next,13/13] can: mcp251xfd: ring: increase number of RX-FIFOs to 3 and increase max TX-FIFO depth to 16
    https://git.kernel.org/netdev/net-next/c/aa66ae9b241e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


