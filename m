Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC60733FAA3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCQVub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhCQVuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 17:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 970B164F30;
        Wed, 17 Mar 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616017809;
        bh=KeB9yrscBANRcHaKxVZ2tQmQgP9cEKw099xg0qrw9sc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XoorWbkvstdplA34coGkDTkOV+8N0MpWtgC5FRNwnGdFZ5X5UjK7ugtFK7QHjZN+t
         HP3iensWpYnyJ5SmGcsAqvDeiA8w48Xn2T1VjV/81F1pL3uJMLyTWUHpUmWGrvt+PE
         KU64YqDuH/pGXMJqtWt2ibpbH1XfJanfOBM0GhogwlfJQhhp7c9IAFpJ5RL6U6Yovd
         jtR32V/GIwHVgkjILW7jRPFWXvMFKXmPhjTsEy9hlaLZqz+Wu1pdRviKaUKnzVeKkq
         M5oYGXxwyTTeQ0S8QNorPL8TytgvJL2XzZcPZjnO4IbHPFb79DWPNmLiTgTVxXugN+
         57fLSRrTVVqlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 891DC60A45;
        Wed, 17 Mar 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v17 0/4] Add support for mv88e6393x family of Marvell
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601780955.9052.1653629798204328180.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 21:50:09 +0000
References: <20210317134643.24463-1-kabel@kernel.org>
In-Reply-To: <20210317134643.24463-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        linux@armlinux.org.uk, olteanv@gmail.com, andrew@lunn.ch,
        ashkan.boldaji@digi.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 14:46:39 +0100 you wrote:
> Hello,
> 
> after 2 months I finally had time to send v17 of Amethyst patches.
> 
> This series is tested on Marvell CN9130-CRB.
> 
> Changes since v16:
> - dropped patches adding 5gbase-r, since they are already merged
> - rebased onto net-next/master
> - driver API renamed set_egress_flood() method into 2 methods for
>   ucast/mcast floods, so this is fixed
> 
> [...]

Here is the summary with links:
  - [net-next,v17,1/4] net: dsa: mv88e6xxx: change serdes lane parameter type from u8 type to int
    https://git.kernel.org/netdev/net-next/c/193c5b2698e3
  - [net-next,v17,2/4] net: dsa: mv88e6xxx: wrap .set_egress_port method
    https://git.kernel.org/netdev/net-next/c/2fda45f019fd
  - [net-next,v17,3/4] net: dsa: mv88e6xxx: add support for mv88e6393x family
    https://git.kernel.org/netdev/net-next/c/de776d0d316f
  - [net-next,v17,4/4] net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst
    https://git.kernel.org/netdev/net-next/c/6584b26020fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


