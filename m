Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94902306B6E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhA1DLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhA1DKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:10:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 42F0D64DD8;
        Thu, 28 Jan 2021 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611803413;
        bh=o8hz9+jIIE8VpqZ9US/1js3fhdfUxvMa7gY2PiA8+IQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dbO+PL8AYrv/gULWpsNURncG0Pj1nqUc9rOJ9f/vpYLjtb7KjDRBzJOqSqV3SXeps
         6nuL+3Rd3hGFm4Pz3rS8FVqki/YU7oqmDuun16r9myy9pMi+srwJfYnfQKf05q1ZaS
         VjxRYOlD7AgKJSQXgjgPNznkdRd98D0RBi3d1zFt+PfU4odhVIfnCOy5Lx86JDBqGL
         0k/uCa/dyHfVrmnlWcsvVyT34TuqKlFDsCG9STs9zVvIVAwzmFDcU2y7qIrhGQA06x
         kNogc8tg2N8vUpslch1hl1mhQZs9NTXe/i9RHsC10R4diRjekYn5m7spUEuFIqSjcI
         wvILbVxFX8anA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 38CFA65307;
        Thu, 28 Jan 2021 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/12] can: gw: fix typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180341322.2345.2157407211981457833.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:10:13 +0000
References: <20210127092227.2775573-2-mkl@pengutronix.de>
In-Reply-To: <20210127092227.2775573-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 10:22:16 +0100 you wrote:
> This patch fixes a typo found by codespell.
> 
> Fixes: 94c23097f991 ("can: gw: support modification of Classical CAN DLCs")
> Link: https://lore.kernel.org/r/20210127085529.2768537-3-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  net/can/gw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] can: gw: fix typo
    https://git.kernel.org/netdev/net-next/c/12da7a1f3cb6
  - [net-next,02/12] can: flexcan: fix typos
    https://git.kernel.org/netdev/net-next/c/02ee68081791
  - [net-next,03/12] can: dev: export can_get_state_str() function
    https://git.kernel.org/netdev/net-next/c/6fe27d68b456
  - [net-next,04/12] can: length: can_fd_len2dlc(): make legnth calculation readable again
    https://git.kernel.org/netdev/net-next/c/54eca60b1c94
  - [net-next,05/12] can: mcba_usb: remove h from printk format specifier
    https://git.kernel.org/netdev/net-next/c/22d63be91c50
  - [net-next,06/12] can: mcp251xfd: replace sizeof(u32) with val_bytes in regmap
    https://git.kernel.org/netdev/net-next/c/cdc4c698e4be
  - [net-next,07/12] can: mcp251xfd: mcp251xfd_start_xmit(): use mcp251xfd_get_tx_free() to check TX is is full
    https://git.kernel.org/netdev/net-next/c/9845b8f53019
  - [net-next,08/12] can: mcp251xfd: mcp251xfd_tx_obj_from_skb(): clean up padding of CAN-FD frames
    https://git.kernel.org/netdev/net-next/c/561aa5b4ce22
  - [net-next,09/12] can: mcp251xfd: mcp251xfd_hw_rx_obj_to_skb(): don't copy data for RTR CAN frames in RX-path
    https://git.kernel.org/netdev/net-next/c/e20b85c7eb2e
  - [net-next,10/12] can: mcp251xfd: mcp251xfd_tx_obj_from_skb(): don't copy data for RTR CAN frames in TX-path
    https://git.kernel.org/netdev/net-next/c/a68eda203676
  - [net-next,11/12] can: mcp251xfd: add len8_dlc support
    https://git.kernel.org/netdev/net-next/c/86f1e3b1dd9f
  - [net-next,12/12] can: mcp251xfd: add BQL support
    https://git.kernel.org/netdev/net-next/c/4162e18e949b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


