Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257983E14E9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbhHEMkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241413AbhHEMkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B17AD61155;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628167206;
        bh=TYiwmQ31ZbY5k9JR1VQ3L7sWVucpuZ6HpEvo38lXDUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W4vA1MSe8zSI0LmQe2psHDLFuvg73M+ONjMFdXVLmjYlsqk0hrCr9101fWMGQUdQi
         Eu36DRxvc/Mr5S4goqJ+ssPNkz09KLYJ3JL3nIZzO1Kb7dw+cDa9UxekfD79qo9E5p
         j7t6vMz5TCKUp4D5YPTPNxRcClUQ2Ka4A1xQhSvKEIcLM8zZnE1zk/FsPLKuoou0tS
         0I+volN8fvztStoTUay9+bs9N+0Cx/sLAcedYFvsF++CR8KPgEss0rBgI1ZOrnLapP
         5vY8ALZ4ClxAJ5GpzzE3/OO8UeEw/LxguEz+Vu2tH7WvbfFErEorUq3WHwzFQonK/d
         mxmZtk2mQgMnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC3D260A7C;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_sja1105: optionally build as module
 when switch driver is module if PTP is enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816720670.10114.17071066582619594123.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:40:06 +0000
References: <20210805113612.2174148-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210805113612.2174148-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        arnd@arndb.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 14:36:12 +0300 you wrote:
> TX timestamps are sent by SJA1110 as Ethernet packets containing
> metadata, so they are received by the tagging driver but must be
> processed by the switch driver - the one that is stateful since it
> keeps the TX timestamp queue.
> 
> This means that there is an sja1110_process_meta_tstamp() symbol
> exported by the switch driver which is called by the tagging driver.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: tag_sja1105: optionally build as module when switch driver is module if PTP is enabled
    https://git.kernel.org/netdev/net-next/c/f8b17a0bd960

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


