Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BCB3F2051
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhHSTAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSTAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9369610A3;
        Thu, 19 Aug 2021 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629399609;
        bh=zw4ujQ46bsTtshYgakJ6fongP0flED2cWf2trMzifQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sJt27xatTe8wMbyWFZYguwnm9UpV8Awf8LY6pdEl77KVloNZCiWDItHmz0XV5Fi+R
         6W1eeWK9mC8XaHF4B1XFNggxIuGVU7sU5nASzVDIEKYaosPMkXU3Z9233CYnuvtYA+
         Tg4AaRNa02k+rcckXzNOkHkx4FgRfBns/tN6Dgv82gOeib2DsHY7XL2fW9lt2NoT/v
         fqnm45696F2iM7fGUnS5i2ejR72C/rGAeryXPoBxy9fhsx2EcZLgi53PEmd12+8Cy1
         4zDJMrra2Kx/BSdgQ8EbNJOUu08O13OBdQab6qQck2QaFaTKyhidX5iJL06a63zrqL
         l5LO5PtT8PBtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D7AC60A48;
        Thu, 19 Aug 2021 19:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-08-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162939960964.18233.15653984142298230559.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 19:00:09 +0000
References: <20210819133913.657715-1-mkl@pengutronix.de>
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 15:38:51 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 22 patches for net-next/master.
> 
> The first patch is by me, for the mailmap file and maps the email
> address of two former ESD employees to a newly created role account.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-08-19
    https://git.kernel.org/netdev/net-next/c/185f690f2989
  - [net-next,02/22] dt-bindings: can-controller: add support for termination-gpios
    https://git.kernel.org/netdev/net-next/c/ef82641d6802
  - [net-next,03/22] dt-bindings: can: fsl,flexcan: enable termination-* bindings
    https://git.kernel.org/netdev/net-next/c/fe7edf2482e1
  - [net-next,04/22] can: dev: provide optional GPIO based termination support
    https://git.kernel.org/netdev/net-next/c/6e86a1543c37
  - [net-next,05/22] can: netlink: allow user to turn off unsupported features
    https://git.kernel.org/netdev/net-next/c/e43aaa0fefce
  - [net-next,06/22] MAINTAINERS: add Vincent MAILHOL as maintainer for the ETAS ES58X CAN/USB driver
    https://git.kernel.org/netdev/net-next/c/7a4573cf3ae8
  - [net-next,07/22] can: etas_es58x: clean-up documentation of struct es58x_fd_tx_conf_msg
    https://git.kernel.org/netdev/net-next/c/c734707820f8
  - [net-next,08/22] can: mcp251xfd: mark some instances of struct mcp251xfd_priv as const
    https://git.kernel.org/netdev/net-next/c/b2fcc7079936
  - [net-next,09/22] dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
    https://git.kernel.org/netdev/net-next/c/1aa5a06c0a5d
  - [net-next,10/22] can: rcar_canfd: Add support for RZ/G2L family
    https://git.kernel.org/netdev/net-next/c/76e9353a80e9
  - [net-next,11/22] can: tcan4x5x: cdev_to_priv(): remove stray empty line
    https://git.kernel.org/netdev/net-next/c/fede1ae2d357
  - [net-next,12/22] can: m_can: fix block comment style
    https://git.kernel.org/netdev/net-next/c/5020ced4455b
  - [net-next,13/22] can: m_can: Disable IRQs on FIFO bus errors
    https://git.kernel.org/netdev/net-next/c/e39381770ec9
  - [net-next,14/22] can: m_can: Batch FIFO reads during CAN receive
    https://git.kernel.org/netdev/net-next/c/1aa6772f64b4
  - [net-next,15/22] can: m_can: Batch FIFO writes during CAN transmit
    https://git.kernel.org/netdev/net-next/c/812270e5445b
  - [net-next,16/22] dt-bindings: net: can: c_can: convert to json-schema
    https://git.kernel.org/netdev/net-next/c/06fc143b2ede
  - [net-next,17/22] can: c_can: c_can_do_tx(): fix typo in comment
    https://git.kernel.org/netdev/net-next/c/236de85f6a11
  - [net-next,18/22] can: c_can: rename IF_RX -> IF_NAPI
    https://git.kernel.org/netdev/net-next/c/05cb2ba4b231
  - [net-next,19/22] can: c_can: remove struct c_can_priv::priv field
    https://git.kernel.org/netdev/net-next/c/5064e40596f4
  - [net-next,20/22] can: c_can: exit c_can_do_tx() early if no frames have been sent
    https://git.kernel.org/netdev/net-next/c/a54cdbba9dee
  - [net-next,21/22] can: c_can: support tx ring algorithm
    https://git.kernel.org/netdev/net-next/c/28e86e9ab522
  - [net-next,22/22] can: c_can: cache frames to operate as a true FIFO
    https://git.kernel.org/netdev/net-next/c/387da6bc7a82

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


