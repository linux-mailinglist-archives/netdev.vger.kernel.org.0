Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4777F3427EE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhCSVkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhCSVkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D80661951;
        Fri, 19 Mar 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190009;
        bh=P8AqvxQbuEgGjCaZSs2oFGcE8lXhhBmAeuW5RNp61M0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LSUTsNWb8XpmpNGsxYYjf4DGNKB36XIWOezuUlljF1XIl46yPARoMzEVyMbUBsyxf
         ZXTSUPxMv8NPuKUPNksAA5bn6F213AdTk2z2bgFO4q0dxux1Eccn0t9+H0cG1lAUNr
         Acz1RyD2xYzGT+6TQVM8o+xOr+Mj3JDznNh5pYZpHNY2328eQUIehWjgDy85DQRXyx
         5ZXCil4G7OooGsRVFL67Crrli8sruRBA5x1Hvk6xoQvpjY/tjxyIeU4e2PThfI1sb9
         7ASFZfnSUmA729gG+2+y+55O6B82yT6wTchpHNjN22L1Yts0R/i15GczZkdUIDTwc1
         zJK6Of5IFn5YQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2040626EC;
        Fri, 19 Mar 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-03-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161619000898.28269.16113175719326103011.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 21:40:08 +0000
References: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210319211723.1488244-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 14:17:18 -0700 you wrote:
> This series contains updates to igc and e1000e drivers.
> 
> Sasha removes unused defines in igc driver.
> 
> Jiapeng Zhong changes bool assignments from 0/1 to false/true for igc.
> 
> Wei Yongjun marks e1000e_pm_prepare() as __maybe_unused to resolve a
> defined but not used warning under certain configurations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] igc: Remove unused MII_CR_RESET
    https://git.kernel.org/netdev/net-next/c/a4e39b999a58
  - [net-next,2/5] igc: Remove unused MII_CR_SPEED
    https://git.kernel.org/netdev/net-next/c/1fa81e259b49
  - [net-next,3/5] igc: Remove unused MII_CR_LOOPBACK
    https://git.kernel.org/netdev/net-next/c/a5d86bd969ea
  - [net-next,4/5] igc: Assign boolean values to a bool variable
    https://git.kernel.org/netdev/net-next/c/501f23092ddb
  - [net-next,5/5] e1000e: Mark e1000e_pm_prepare() as __maybe_unused
    https://git.kernel.org/netdev/net-next/c/f2d75b178532

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


