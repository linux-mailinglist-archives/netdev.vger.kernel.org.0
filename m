Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D230357761
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhDGWKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhDGWKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB4C761260;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833411;
        bh=eXMPXBnyAjXl2c0IW90asFttZEBU+jACuz+oduN8hoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YlLRGkkZukFzJi6MxU6TD6B8iiFy9xkHK9UQPLK+ESNYOmvYzXKYKe2mQs+977Mx5
         Molri/9TMLhOEOHpXw0vWkvdGf6QyYxiEZHZudpaV7feulpvSEuGcQAYvJd6g7AQqT
         WQQx4C5HRgLhfZqOzPf0irf01pfFhRxsmJ1y2sKoO/JL4ki57uWAb+tr4dg5o8VclV
         mj9X0oZwwMvuCEBUSWV73UnrxmzIBrGgwYLlHhYpwa6M9t+I46iF0n6xuBsB7LLmx6
         JG28vSYOoYbg5rIq/joG8tU7TZ6GcGZKhdsf429xPaJIGfjwP9H9Lp7Mht8e31OUT2
         yDQrBDI00AwNA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D405260ACA;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-04-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783341186.5631.5150473339101525870.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:11 +0000
References: <20210407080118.1916040-1-mkl@pengutronix.de>
In-Reply-To: <20210407080118.1916040-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 10:01:12 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 6 patches for net-next/master.
> 
> The first patch targets the CAN driver infrastructure, it improves the
> alloc_can{,fd}_skb() function to set the pointer to the CAN frame to
> NULL if skb allocation fails.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-04-07
    https://git.kernel.org/netdev/net-next/c/33b32a298426
  - [net-next,2/6] can: m_can: m_can_receive_skb(): add missing error handling to can_rx_offload_queue_sorted() call
    https://git.kernel.org/netdev/net-next/c/644022b1de9e
  - [net-next,3/6] can: c_can: remove unused enum BOSCH_C_CAN_PLATFORM
    https://git.kernel.org/netdev/net-next/c/8dc987519ae9
  - [net-next,4/6] can: mcp251xfd: add BQL support
    https://git.kernel.org/netdev/net-next/c/0084e298acfe
  - [net-next,5/6] can: mcp251xfd: mcp251xfd_regmap_crc_read_one(): Factor out crc check into separate function
    https://git.kernel.org/netdev/net-next/c/ef7a8c3e7599
  - [net-next,6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register
    https://git.kernel.org/netdev/net-next/c/c7eb923c3caf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


