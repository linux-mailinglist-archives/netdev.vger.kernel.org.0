Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DB839386A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbhE0Vvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 17:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhE0Vvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 17:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03C46613DA;
        Thu, 27 May 2021 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622152207;
        bh=S36GH2Q8C47XQMgo17B/GDwSJB9O2tStxWlxmDTlfE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gYL9qxOYx1sB6AD6Su7vHdPVxh1VFkpsMT9/bfw4acHE2+RBifcFfvOIQSZd5cXZi
         cgYUaiO6gcBr/TeGKhicVKJxwK+Lw+7Rnrh8zND/iu+OcfB9zE1BCzwHWu+89ah3n5
         3hnRDpuiM9QraSGofetjPhozDnyVPiXHGJI3VwuQybQsYrGG8bpAYslaCZGg7PVTc7
         7ct6THdcFwV+vKbfuQ0rgBxdrgaFDhV7AXFN8OLeO+6RK0g2FUX1HcCk3wWOeg5mqT
         sb1fKdqenftbtgmN8RY64U808/4iMSLhgoadmxYYong13hQ08ECpQkMjGz4JCfVtpA
         rvGg5V7SffrKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBADE60BE2;
        Thu, 27 May 2021 21:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-05-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215220696.21706.14264910157873912468.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 21:50:06 +0000
References: <20210527084532.1384031-1-mkl@pengutronix.de>
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 10:45:11 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 21 patches for net-next/master. I hope
> that's OK, as http://vger.kernel.org/~davem/net-next.html still says
> closed.
> 
> The first 2 patches are by Geert Uytterhoeven and convert the rcan_can
> and rcan_canfd device tree bindings to yaml.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-05-27
    https://git.kernel.org/netdev/net-next/c/b14b27fffa2e
  - [net-next,02/21] dt-bindings: can: rcar_canfd: Convert to json-schema
    https://git.kernel.org/netdev/net-next/c/8a5e7d19c8c7
  - [net-next,03/21] can: uapi: update CAN-FD frame description
    https://git.kernel.org/netdev/net-next/c/7e97d274db92
  - [net-next,04/21] can: uapi: introduce CANFD_FDF flag for mixed content in struct canfd_frame
    https://git.kernel.org/netdev/net-next/c/025468842212
  - [net-next,05/21] can: proc: remove unnecessary variables
    https://git.kernel.org/netdev/net-next/c/24a774a4f975
  - [net-next,06/21] can: isotp: change error format from decimal to symbolic error names
    https://git.kernel.org/netdev/net-next/c/46d8657a6b28
  - [net-next,07/21] can: isotp: add symbolic error message to isotp_module_init()
    https://git.kernel.org/netdev/net-next/c/6a5ddae57884
  - [net-next,08/21] can: isotp: Add error message if txqueuelen is too small
    https://git.kernel.org/netdev/net-next/c/c69d190f7bb9
  - [net-next,09/21] can: softing: Remove redundant variable ptr
    https://git.kernel.org/netdev/net-next/c/9208f7bf053a
  - [net-next,10/21] can: hi311x: hi3110_can_probe(): silence clang warning
    https://git.kernel.org/netdev/net-next/c/83415669d8d8
  - [net-next,11/21] can: mcp251x: mcp251x_can_probe(): silence clang warning
    https://git.kernel.org/netdev/net-next/c/10462b3558d4
  - [net-next,12/21] can: mcp251xfd: silence clang warning
    https://git.kernel.org/netdev/net-next/c/b558e200d626
  - [net-next,13/21] can: at91_can: silence clang warning
    https://git.kernel.org/netdev/net-next/c/4318b1aa22b7
  - [net-next,14/21] can: kvaser_usb: Rename define USB_HYBRID_{,PRO_}CANLIN_PRODUCT_ID
    https://git.kernel.org/netdev/net-next/c/893974d9b565
  - [net-next,15/21] can: kvaser_usb: Add new Kvaser hydra devices
    https://git.kernel.org/netdev/net-next/c/ee6bb641bc70
  - [net-next,16/21] can: c_can: remove unused variable struct c_can_priv::rxmasked
    https://git.kernel.org/netdev/net-next/c/c7b0f6887d90
  - [net-next,17/21] can: c_can: add ethtool support
    https://git.kernel.org/netdev/net-next/c/2722ac986e93
  - [net-next,18/21] can: m_can: use bits.h macros for all regmasks
    https://git.kernel.org/netdev/net-next/c/20779943a080
  - [net-next,19/21] can: m_can: clean up CCCR reg defs, order by revs
    https://git.kernel.org/netdev/net-next/c/38395f302f4d
  - [net-next,20/21] can: m_can: make TXESC, RXESC config more explicit
    https://git.kernel.org/netdev/net-next/c/0f3157166891
  - [net-next,21/21] can: m_can: fix whitespace in a few comments
    https://git.kernel.org/netdev/net-next/c/50fe7547b637

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


