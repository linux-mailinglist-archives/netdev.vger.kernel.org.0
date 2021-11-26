Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCA845E6A7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352117AbhKZDzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344964AbhKZDxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:53:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 147D460231;
        Fri, 26 Nov 2021 03:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637898611;
        bh=td7Ul/MLWd+0okRCxMK7e4Ao2DeEknqQrI7bM1vjCcg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DvzC0PW9VYAtNPTG96J0v04tnbrksI3Z1tIu1/t/0MerH0iUzKRMwDSY7yct/QPb5
         S23S15l+iptrcb2BAhax/c+MQ5fpjGnPwZf4jgQzfHPYMBzOUcQxV6eElxm0g/78jG
         Gc/0e6bokGL6SbVerLc9FRUyNejdPThEOOtyxrUim0my9VMjlIyfC4f7t6jKAOBiI7
         1paZxR/mqSlBio5/6aGV7KTnWn3H/oXDMdoU3ALYkCcAp31jHhGs0m+CwVhO2GxYql
         F63eVQfA8TrapkiDhSAPhIKnOq8O8/+TaBY6WtFDoFaLAAxr5x6OzV617qcB+8cAIo
         leDEd1I1EFWFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F423F60A6D;
        Fri, 26 Nov 2021 03:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 1/2] net: ocelot: remove "bridge" argument from
 ocelot_get_bridge_fwd_mask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789861099.16578.4992780057828274770.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:50:10 +0000
References: <20211125125808.2383984-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211125125808.2383984-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        xiaoliang.yang_1@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 14:58:07 +0200 you wrote:
> The only called takes ocelot_port->bridge and passes it as the "bridge"
> argument to this function, which then compares it with
> ocelot_port->bridge. This is not useful.
> 
> Instead, we would like this function to return 0 if ocelot_port->bridge
> is not present, which is what this patch does.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] net: ocelot: remove "bridge" argument from ocelot_get_bridge_fwd_mask
    https://git.kernel.org/netdev/net-next/c/a8bd9fa5b527
  - [v3,net-next,2/2] net: dsa: felix: enable cut-through forwarding between ports by default
    https://git.kernel.org/netdev/net-next/c/8abe19703825

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


