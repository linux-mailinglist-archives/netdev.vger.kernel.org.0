Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A803D4936
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 20:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhGXR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 13:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGXR7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 13:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1449D60BD3;
        Sat, 24 Jul 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627152005;
        bh=iTtYTtRzmi24IbC0gYwXZ5XtX4dfA8c930yrnjPsVDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oxp40UpTzYgOvj4cTO6J1WGd1HT05DSb0odkgroh2mUesigJXsQGmbvvwdOp4Rlw6
         rC1gIi9JO6go6eeyp7rjSS1H3x6MQDaldlLU3uOSH2l251P+8kb6n4h0wHNto3M9W9
         FUB+60og4WlKyCchu54qpqWbCaWWxjHE3GuIwe18QFslMUvl7k/VsghLCX2N2VfJRz
         Sr9x5fHNXdnG+TjqBe+PVjeccujabv9MPrnQ3HBO6eYCC92/e7YX1eagcwued8hlw9
         PpTXLJJR+pbGEO7azt9pIJkhgF2ibeUFICSSnKdenVNf1/dpphjgNhTk08LWkRoLgb
         KCXh4IoGBVgcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 084CB60A0C;
        Sat, 24 Jul 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-07-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162715200502.23954.17648964928279230319.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Jul 2021 18:40:05 +0000
References: <20210724171947.547867-1-mkl@pengutronix.de>
In-Reply-To: <20210724171947.547867-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Sat, 24 Jul 2021 19:19:41 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 6 patches for net/master.
> 
> The first patch is by Joakim Zhang targets the imx8mp device tree. It
> removes the imx6 fallback from the flexcan binding, as the imx6 is not
> compatible with the imx8mp.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-07-24
    https://git.kernel.org/netdev/net/c/e394f1e3b139
  - [net,2/6] can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF
    https://git.kernel.org/netdev/net/c/54f93336d000
  - [net,3/6] can: j1939: j1939_session_deactivate(): clarify lifetime of session object
    https://git.kernel.org/netdev/net/c/0c71437dd50d
  - [net,4/6] can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms
    https://git.kernel.org/netdev/net/c/c6eea1c8bda5
  - [net,5/6] can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values
    https://git.kernel.org/netdev/net/c/590eb2b7d8cf
  - [net,6/6] can: mcp251xfd: mcp251xfd_irq(): stop timestamping worker in case error in IRQ
    https://git.kernel.org/netdev/net/c/ef68a7179606

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


