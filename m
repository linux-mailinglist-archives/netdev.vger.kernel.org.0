Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CF62C746D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbgK1Vtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730698AbgK0Twe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:52:34 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504836;
        bh=Okm4BivhdxTaLdf0zCzmKzoXvA8OXm1OHkZG3ATLRk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=0cAdeBUOpesL+nObF59w9Pnp66Acu1p6sPPfUTM9wQG5Y5BIx6v3GSfIkJB4TyUvE
         Y8N4i6/U2tyQbwMef8G+5SGzQKKXkjW+vwWDUVr7hh4aEv4w/96ajb49wm9gRY+A5X
         Kzc7oPTVrYsqUsTEaDXvEMOD5+K1Fg9ud7qohN0s=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2020-11-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160650483669.8048.14288454793256894349.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Nov 2020 19:20:36 +0000
References: <20201127100301.512603-1-mkl@pengutronix.de>
In-Reply-To: <20201127100301.512603-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri, 27 Nov 2020 11:02:55 +0100 you wrote:
> Hello Jakub, hello David,
> 
> here's a pull request of 6 patches for net/master.
> 
> The first patch is by me and target the gs_usb driver and fixes the endianess
> problem with candleLight firmware.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2020-11-27
    https://git.kernel.org/netdev/net/c/d0742c49cab5
  - [net,2/6] can: mcp251xfd: mcp251xfd_probe(): bail out if no IRQ was given
    https://git.kernel.org/netdev/net/c/1a1c436bad34
  - [net,3/6] can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags
    https://git.kernel.org/netdev/net/c/865f5b671b48
  - [net,4/6] can: m_can: fix nominal bitiming tseg2 min for version >= 3.1
    https://git.kernel.org/netdev/net/c/e3409e419253
  - [net,5/6] can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0
    https://git.kernel.org/netdev/net/c/5c7d55bded77
  - [net,6/6] can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check
    https://git.kernel.org/netdev/net/c/d73ff9b7c4ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


