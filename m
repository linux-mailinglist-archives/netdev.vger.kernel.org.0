Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91D43CE247
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346693AbhGSP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347970AbhGSPXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 11:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E40DE613C3;
        Mon, 19 Jul 2021 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626710405;
        bh=aAS5VaTYlDoKXDItOnub31r+qJE9O98U5SSa+LmHBIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=csXr7ugcVP8MRq1QPtXcuyFelnfg00hfUEMxwJz1rwvwUa0oE61Q0XTvg9NuKu12f
         4hkuL5ZL0iIPH2LOVmFgPTeQhsmwzCqbcSeJ4bu4zhTTA6J+EpHq+U4o58sq+zxJqI
         zasjwlRA8pbw13x2hQ6XTCwBmtrqcUd/Gu3zquK7bbh6fKFCud9HnsR9Cnb5rTOKba
         HWeudPPl2c/tGgx+V62nE/y+2dKZxC+BI9tI7ekkczO4E9fP14I5CAk5Rl+Q3uEUN7
         9dI9qi4I9fvhZcltCL2wBtZJgHSsHvC+7bg/npby2HwwgKxYcZs/EVuTEUtQL6wm4Z
         TO/aKRGqHLYDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9ED460CD3;
        Mon, 19 Jul 2021 16:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/9] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162671040588.7341.9692213654820103180.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Jul 2021 16:00:05 +0000
References: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 18 Jul 2021 15:36:24 -0400 you wrote:
> Most of the fixes in this series have to do with error recovery.  They
> include error path handling when the error recovery has to abort, and
> the rediscovery of capabilities (PTP and RoCE) after firmware reset
> that may result in capability changes.
> 
> Two other fixes are to reject invalid ETS settings and to validate
> VLAN protocol in the RX path.
> 
> [...]

Here is the summary with links:
  - [net,1/9] bnxt_en: don't disable an already disabled PCI device
    https://git.kernel.org/netdev/net/c/c81cfb6256d9
  - [net,2/9] bnxt_en: reject ETS settings that will starve a TC
    https://git.kernel.org/netdev/net/c/c08c59653415
  - [net,3/9] bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()
    https://git.kernel.org/netdev/net/c/2c9f046bc377
  - [net,4/9] bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()
    https://git.kernel.org/netdev/net/c/6cd657cb3ee6
  - [net,5/9] bnxt_en: fix error path of FW reset
    https://git.kernel.org/netdev/net/c/3958b1da725a
  - [net,6/9] bnxt_en: Validate vlan protocol ID on RX packets
    https://git.kernel.org/netdev/net/c/96bdd4b9ea7e
  - [net,7/9] bnxt_en: Check abort error state in bnxt_half_open_nic()
    https://git.kernel.org/netdev/net/c/11a39259ff79
  - [net,8/9] bnxt_en: Move bnxt_ptp_init() to bnxt_open()
    https://git.kernel.org/netdev/net/c/d7859afb6880
  - [net,9/9] bnxt_en: Fix PTP capability discovery
    https://git.kernel.org/netdev/net/c/de5bf19414fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


