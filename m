Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544E84395B3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhJYMMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231512AbhJYMMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E828360F9B;
        Mon, 25 Oct 2021 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163814;
        bh=W2h5Q1o7cirea6jpDKxXDkn1U4ZWiueFqOXYM5m7Qck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QBMY98u+qlTDhBUcag9EzsEf0IiXuUBfgctP1Iq2DMBLdzqBN4sUaVZ/VTqLc9CVD
         HFZjLcPRgBWIbpoCbBCu0Ps+Vx5DAVl7VT6Amv8E0PGExN1pPbeBPjkUV+OnVd/7hn
         deptDV4abILJXRq5dXlaHa4TE4TXDN1aZUOzCtiqzxEaPv0PIof1E8YRsn0RlVPgtG
         3CrDLiHmtzK4BH4lpdGcNhSsgJoyr56hLqiTSMoXY0K63C36PKEYz3XBGjJMAdwChU
         0sidBi/M1fHVgeSLkl6dohtbAZsCXoC0lqINvMjqJ2BK0a9+nkNNNmGbg4d46uDimb
         2fmTnekoru2aA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF48760A17;
        Mon, 25 Oct 2021 12:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/15] can: bcm: Use hrtimer_forward_now()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516381490.1029.18024695570384102149.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 12:10:14 +0000
References: <20211024204325.3293425-2-mkl@pengutronix.de>
In-Reply-To: <20211024204325.3293425-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        tglx@linutronix.de, socketcan@hartkopp.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sun, 24 Oct 2021 22:43:11 +0200 you wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> hrtimer_forward_now() provides the same functionality as the open coded
> hrimer_forward() invocation. Prepares for removal of hrtimer_forward() from
> the public interfaces.
> 
> Link: https://lore.kernel.org/all/20210923153339.684546907@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: linux-can@vger.kernel.org
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: netdev@vger.kernel.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] can: bcm: Use hrtimer_forward_now()
    https://git.kernel.org/netdev/net-next/c/9b44a927e195
  - [net-next,02/15] can: bittiming: can_fixup_bittiming(): change type of tseg1 and alltseg to unsigned int
    https://git.kernel.org/netdev/net-next/c/e34629043960
  - [net-next,03/15] can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
    https://git.kernel.org/netdev/net-next/c/63dfe0709643
  - [net-next,04/15] can: bittiming: change unit of TDC parameters to clock periods
    https://git.kernel.org/netdev/net-next/c/39f66c9e2297
  - [net-next,05/15] can: bittiming: change can_calc_tdco()'s prototype to not directly modify priv
    https://git.kernel.org/netdev/net-next/c/da45a1e4d7b9
  - [net-next,06/15] can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)
    https://git.kernel.org/netdev/net-next/c/d99755f71a80
  - [net-next,07/15] can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from device
    https://git.kernel.org/netdev/net-next/c/e8060f08cd69
  - [net-next,08/15] can: dev: add can_tdc_get_relative_tdco() helper function
    https://git.kernel.org/netdev/net-next/c/fa759a9395ea
  - [net-next,09/15] can: at91/janz-ican3: replace snprintf() in show functions with sysfs_emit()
    https://git.kernel.org/netdev/net-next/c/7bc9ab0f42b3
  - [net-next,10/15] can: rcar: drop unneeded ARM dependency
    https://git.kernel.org/netdev/net-next/c/39aab46063ed
  - [net-next,11/15] can: mscan: mpc5xxx_can: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/28616ed180c3
  - [net-next,12/15] can: gs_usb: use %u to print unsigned values
    https://git.kernel.org/netdev/net-next/c/108194666a3f
  - [net-next,13/15] can: peak_usb: CANFD: store 64-bits hw timestamps
    https://git.kernel.org/netdev/net-next/c/28e0a70cede3
  - [net-next,14/15] can: xilinx_can: remove repeated word from the kernel-doc
    https://git.kernel.org/netdev/net-next/c/c92603931bfd
  - [net-next,15/15] can: xilinx_can: xcan_remove(): remove redundant netif_napi_del()
    https://git.kernel.org/netdev/net-next/c/b9b8218bb3c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


