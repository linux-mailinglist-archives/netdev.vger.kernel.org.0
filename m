Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5733044752B
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhKGTMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhKGTMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:12:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B23F360EBB;
        Sun,  7 Nov 2021 19:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636312208;
        bh=wZR7a6HrkbX4Ku9WZ4G4CNA6D5gqWJIXCQMCCZ2A4jk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mm36nEeOjzhbELI7T36gtDabrEJ7G/qFn8a2LIP95NKnzAoiNixnstuCRnuxxvq1j
         bPzLpdfzLpOY1MVP3N5gP4Pgso91inve50jNQ6J0JTKFfvCEt/foWA7AFBq+lc4LWg
         uXv9+zsWP3eJf0V20WAFJ5PIww83Bv0GlVCJGgw70/cn93r3SMOYLpGJpeP8PPhgPk
         g5LiMPpPrheD/CcY7g3HLun5qAqzxesi4g3i3K0dyLOkXiXr7Hb8fkQCDHt9JSkEam
         hTHmw2y1GcM7Ytshj4ceBowdmOBa5nbN6LFCiZ6pvwuyJ7qbSc29XmTsL4JYmxTocX
         71e+4sHaE2UWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4C7E609F7;
        Sun,  7 Nov 2021 19:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-11-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631220867.2857.10166147031340186904.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:10:08 +0000
References: <20211106215449.57946-1-mkl@pengutronix.de>
In-Reply-To: <20211106215449.57946-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sat,  6 Nov 2021 22:54:41 +0100 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 8 patches for net/master.
> 
> The first 3 patches are by Zhang Changzhong and fix 3 standard
> conformance problems in the j1939 CAN stack.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-11-06
    https://git.kernel.org/netdev/net/c/f05fb508ec3b
  - [net,2/8] can: j1939: j1939_can_recv(): ignore messages with invalid source address
    https://git.kernel.org/netdev/net/c/a79305e156db
  - [net,3/8] can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM
    https://git.kernel.org/netdev/net/c/164051a6ab54
  - [net,4/8] can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path
    https://git.kernel.org/netdev/net/c/d9447f768bc8
  - [net,5/8] can: peak_usb: always ask for BERR reporting for PCAN-USB devices
    https://git.kernel.org/netdev/net/c/3f1c7aa28498
  - [net,6/8] can: peak_usb: exchange the order of information messages
    https://git.kernel.org/netdev/net/c/6b78ba3e51f9
  - [net,7/8] can: mcp251xfd: mcp251xfd_irq(): add missing can_rx_offload_threaded_irq_finish() in case of bus off
    https://git.kernel.org/netdev/net/c/691204bd66b3
  - [net,8/8] can: mcp251xfd: mcp251xfd_chip_start(): fix error handling for mcp251xfd_chip_rx_int_enable()
    https://git.kernel.org/netdev/net/c/69c55f6e7669

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


