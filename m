Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27ED6431881
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhJRMMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJRMMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D40461212;
        Mon, 18 Oct 2021 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634559009;
        bh=1KCyayOB2zdBgRAT7JI2uplYhrX4zoVFcQFvN64iynY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pBT/PLjMUfkTM1APd40vn5WZq4KM6AocYqGjMNVeEtgnpFYKWpYMlX19vJ6DOYHvj
         wjQ1vdGMwSfV/ihlz55LwV2meFVu2YJL6QwS7MI67myKefuredkvp0wsVr+N213jn3
         EBu/lsmB+QSU6/3gls8e1oNkfn6mf+mJZ2X2VFwv4VEEwLHxBeo5gYjmmuDldyXdTH
         6eF9QmI0yQoUXUzKsZMU8txCTXPJLvUstzd1i3PAp2jypYXaX+oO930b81+Hiz/Nk1
         blN3EXwmMtIx1gK+urmkcsIXJ61yUPOKv6z+wOeaB0UHgBbrXElm9oxh5aP/ffKywz
         ANtAIoUIEyAHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C007609AD;
        Mon, 18 Oct 2021 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-10-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163455900943.7340.2639738729887818927.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:10:09 +0000
References: <20211017210142.2108610-1-mkl@pengutronix.de>
In-Reply-To: <20211017210142.2108610-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sun, 17 Oct 2021 23:01:31 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 11 patches for net/master.
> 
> The first 4 patches are by Ziyang Xuan and Zhang Changzhong and fix 1
> use after free and 3 standard conformance problems in the j1939 CAN
> stack.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-10-17
    https://git.kernel.org/netdev/net/c/bca69044affa
  - [net,02/11] can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv
    https://git.kernel.org/netdev/net/c/d9d52a3ebd28
  - [net,03/11] can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
    https://git.kernel.org/netdev/net/c/379743985ab6
  - [net,04/11] can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes
    https://git.kernel.org/netdev/net/c/a4fbe70c5cb7
  - [net,05/11] can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
    https://git.kernel.org/netdev/net/c/9acf636215a6
  - [net,06/11] can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()
    https://git.kernel.org/netdev/net/c/43a08c3bdac4
  - [net,07/11] can: rcar_can: fix suspend/resume
    https://git.kernel.org/netdev/net/c/f7c05c3987dc
  - [net,08/11] can: m_can: fix iomap_read_fifo() and iomap_write_fifo()
    https://git.kernel.org/netdev/net/c/99d173fbe894
  - [net,09/11] can: peak_pci: peak_pci_remove(): fix UAF
    https://git.kernel.org/netdev/net/c/949fe9b35570
  - [net,10/11] can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification
    https://git.kernel.org/netdev/net/c/3d031abc7e72
  - [net,11/11] can: peak_usb: pcan_usb_fd_decode_status(): remove unnecessary test on the nullity of a pointer
    https://git.kernel.org/netdev/net/c/553715feaa9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


