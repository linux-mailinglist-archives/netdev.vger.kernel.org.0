Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D42334C67
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhCJXUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhCJXUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:20:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 48EA664FC3;
        Wed, 10 Mar 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615418410;
        bh=/aySVRGGHFcjyel/aLlvc9lnpPdioIdJTWPDOYQSFzs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XKc5GSkjONINxcH2qCiVFsDKataD/9s+7T4yetHN6mSh4Rqb+GaBPMEqOYHcWd54E
         2ejrCUgXcVSBS5LalXoeJAbTYKB7gm46DGbTcoLUjCEFH+Yh980NiogXc/mP+2OHxd
         p9cl+J9Jdh6J3Q+TvRWXDv6KYkPFoZqjlxe+5BbrhWieUSEZsYNgCqGXHHuKOsdCsV
         N8bpeO4EwFx2LgaYdJjeELigAeKVWK1Zj9btNMjd9YDEFOK2Yl/5hiFIG9dN85gHli
         eNDnmy6Qzciy5YjRYVROJomUVXCXExuBTIGfbJ0YVFZcq72TFnK5zRw+cmkNlCz+h6
         CUFxQR1fDeuNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 372496096F;
        Wed, 10 Mar 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and move
 out of staging
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541841022.621.18218848353081370220.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:20:10 +0000
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 14:14:37 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set adds support for Rx/Tx capabilities on DPAA2 switch port
> interfaces as well as fixing up some major blunders in how we take care
> of the switching domains. The last patch actually moves the driver out
> of staging now that the minimum requirements are met.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] staging: dpaa2-switch: remove broken learning and flooding support
    https://git.kernel.org/netdev/net-next/c/93a4d0ab1e44
  - [net-next,02/15] staging: dpaa2-switch: fix up initial forwarding configuration done by firmware
    https://git.kernel.org/netdev/net-next/c/282d47de29c7
  - [net-next,03/15] staging: dpaa2-switch: remove obsolete .ndo_fdb_{add|del} callbacks
    https://git.kernel.org/netdev/net-next/c/5dda9a7921c7
  - [net-next,04/15] staging: dpaa2-switch: get control interface attributes
    https://git.kernel.org/netdev/net-next/c/26d419f36a23
  - [net-next,05/15] staging: dpaa2-switch: setup buffer pool and RX path rings
    https://git.kernel.org/netdev/net-next/c/2877e4f7e189
  - [net-next,06/15] staging: dpaa2-switch: setup dpio
    https://git.kernel.org/netdev/net-next/c/04abc97d3ef7
  - [net-next,07/15] staging: dpaa2-switch: handle Rx path on control interface
    https://git.kernel.org/netdev/net-next/c/0b1b71370458
  - [net-next,08/15] staging: dpaa2-switch: add .ndo_start_xmit() callback
    https://git.kernel.org/netdev/net-next/c/7fd94d86b7f4
  - [net-next,09/15] staging: dpaa2-switch: enable the control interface
    https://git.kernel.org/netdev/net-next/c/613c0a5810b7
  - [net-next,10/15] staging: dpaa2-switch: properly setup switching domains
    https://git.kernel.org/netdev/net-next/c/539dda3c5d19
  - [net-next,11/15] staging: dpaa2-switch: move the notifier register to module_init()
    https://git.kernel.org/netdev/net-next/c/16abb6ad6abc
  - [net-next,12/15] staging: dpaa2-switch: accept only vlan-aware upper devices
    https://git.kernel.org/netdev/net-next/c/d671407fccbb
  - [net-next,13/15] staging: dpaa2-switch: add fast-ageing on bridge leave
    https://git.kernel.org/netdev/net-next/c/685b480145c1
  - [net-next,14/15] staging: dpaa2-switch: prevent joining a bridge while VLAN uppers are present
    https://git.kernel.org/netdev/net-next/c/1c4928fc2929
  - [net-next,15/15] staging: dpaa2-switch: move the driver out of staging
    https://git.kernel.org/netdev/net-next/c/f48298d3fbfa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


