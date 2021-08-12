Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828323EA321
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 12:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhHLKug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 06:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235696AbhHLKue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 06:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E407161038;
        Thu, 12 Aug 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628765406;
        bh=FSUtACLYiKxoll3t4Ko12AmXZnlvpt1Ac2LswSg3a+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZGUlFh66RczBfcV4YIW9tGrUPH6XcQMmsK9tlKHkbmQqfMc0/ohh9SP/wZ2/OrxKG
         C15oB9jl9lK2TgyNg9pyTtL6JkK89bEX/QSrJZoHy3vNQYPJH//oHb7K87M4w4F5Wd
         uIRYEoH4kinrOZHxpX5crftYRlCpeR9n6Vo+8AzVXISyRELY8AJnuih3OfWk7uNJAy
         ITbooRcwv16fQBWD7OH2ShzDf/8wY2FXvermHEfLHHAgzo2ouYTDuQ41E4B1HLv5qz
         +2fGLpQ5seT9AOZTdWPZmeRjZ5SXt28ABwJTIYXWHIEsl3Kc7FpgRwTZ55M1VrZ9gF
         XZ4I5i+Hgptkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D766060A54;
        Thu, 12 Aug 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Improvements to the DSA tag_8021q cross-chip
 notifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162876540687.30325.3975541979440020703.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 10:50:06 +0000
References: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Aug 2021 16:46:04 +0300 you wrote:
> This series improves cross-chip notifier error messages and addresses a
> benign error message seen during reboot on a system with disjoint DSA
> trees.
> 
> Vladimir Oltean (2):
>   net: dsa: print more information when a cross-chip notifier fails
>   net: dsa: tag_8021q: don't broadcast during setup/teardown
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: print more information when a cross-chip notifier fails
    https://git.kernel.org/netdev/net-next/c/ab97462beb18
  - [net-next,2/2] net: dsa: tag_8021q: don't broadcast during setup/teardown
    https://git.kernel.org/netdev/net-next/c/724395f4dc95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


