Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89752488ABF
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 18:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbiAIRAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 12:00:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48654 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiAIRAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 12:00:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A162E60F73;
        Sun,  9 Jan 2022 17:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 026E6C36AF2;
        Sun,  9 Jan 2022 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641747614;
        bh=rcx0LiYMQHsB0yfFhbGNkxBz3xKL5uXnOk9N867xJXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rn2IkgWoex6EBuBOL+kvEmpoPahE6BYFXzUKqKecdIl3eSHyYy1E5qrx2OIN6YZF4
         9ErvpIkjIwI1OeqMKBXXr7GdfcLIkhWEPiL/6YmhaR+HTAoa2xw88/IHBXPufL0pHr
         viZ383Vr3RAHCRDE7ArsoSPH9SL/nDFZ+QwWi/AfFtCjNk0Lq9NC23+VozQ5/lHH62
         bul78pRmirPE3bBkV+nFvmwyqE1R1EDApwMa3Wcx4uGSpk5uPLpccXOCzAi3y1AKRW
         eyh2m+sBE4yMhQAE6H8/hNQ0+zCGMnZGdTpjxoyyJChYvap+EKiMD/yhoe3mHv1x85
         KrIhDeLiZ6DrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9F8EF79404;
        Sun,  9 Jan 2022 17:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/22] can: janz-ican3: initialize dlc variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164174761387.1736.6969026310472491750.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Jan 2022 17:00:13 +0000
References: <20220108214345.1848470-2-mkl@pengutronix.de>
In-Reply-To: <20220108214345.1848470-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, trix@redhat.com,
        mailhol.vincent@wanadoo.fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sat,  8 Jan 2022 22:43:24 +0100 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this problem
> janz-ican3.c:1311:2: warning: Undefined or garbage value returned to caller
>         return dlc;
>         ^~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next,01/22] can: janz-ican3: initialize dlc variable
    https://git.kernel.org/netdev/net-next/c/c57979256283
  - [net-next,02/22] can: mcp251xfd: remove double blank lines
    https://git.kernel.org/netdev/net-next/c/2d2116691adf
  - [net-next,03/22] can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message
    https://git.kernel.org/netdev/net-next/c/99e7cc3b3f85
  - [net-next,04/22] can: mcp251xfd: add missing newline to printed strings
    https://git.kernel.org/netdev/net-next/c/3bd9d8ce6f8c
  - [net-next,05/22] can: mcp251xfd: mcp251xfd_open(): open_candev() first
    https://git.kernel.org/netdev/net-next/c/e91aae8efc4e
  - [net-next,06/22] can: mcp251xfd: mcp251xfd_open(): make use of pm_runtime_resume_and_get()
    https://git.kernel.org/netdev/net-next/c/d84ca2217b00
  - [net-next,07/22] can: mcp251xfd: mcp251xfd_handle_rxovif(): denote RX overflow message to debug + add rate limiting
    https://git.kernel.org/netdev/net-next/c/58d0b0a99275
  - [net-next,08/22] can: mcp251xfd: mcp251xfd.h: sort function prototypes
    https://git.kernel.org/netdev/net-next/c/cae9071bc5ea
  - [net-next,09/22] can: mcp251xfd: move RX handling into separate file
    https://git.kernel.org/netdev/net-next/c/319fdbc9433c
  - [net-next,10/22] can: mcp251xfd: move TX handling into separate file
    https://git.kernel.org/netdev/net-next/c/09b0eb92fec7
  - [net-next,11/22] can: mcp251xfd: move TEF handling into separate file
    https://git.kernel.org/netdev/net-next/c/1e846c7aeb06
  - [net-next,12/22] can: mcp251xfd: move chip FIFO init into separate file
    https://git.kernel.org/netdev/net-next/c/335c818c5a7a
  - [net-next,13/22] can: mcp251xfd: move ring init into separate function
    https://git.kernel.org/netdev/net-next/c/55bc37c85587
  - [net-next,14/22] can: mcp251xfd: introduce and make use of mcp251xfd_is_fd_mode()
    https://git.kernel.org/netdev/net-next/c/3044a4f271d2
  - [net-next,15/22] can: flexcan: move driver into separate sub directory
    https://git.kernel.org/netdev/net-next/c/bfd00e021cf1
  - [net-next,16/22] can: flexcan: allow to change quirks at runtime
    https://git.kernel.org/netdev/net-next/c/01bb4dccd92b
  - [net-next,17/22] can: flexcan: rename RX modes
    https://git.kernel.org/netdev/net-next/c/34ea4e1c99f1
  - [net-next,18/22] can: flexcan: add more quirks to describe RX path capabilities
    https://git.kernel.org/netdev/net-next/c/c5c88591040e
  - [net-next,19/22] can: flexcan: add ethtool support to change rx-rtr setting during runtime
    https://git.kernel.org/netdev/net-next/c/1c45f5778a3b
  - [net-next,20/22] can: flexcan: add ethtool support to get rx/tx ring parameters
    https://git.kernel.org/netdev/net-next/c/74fc5a452ec3
  - [net-next,21/22] docs: networking: device drivers: add can sub-folder
    https://git.kernel.org/netdev/net-next/c/32db1660ee01
  - [net-next,22/22] docs: networking: device drivers: can: add flexcan
    https://git.kernel.org/netdev/net-next/c/bc3897f79f79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


