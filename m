Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF2C46CD7D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhLHGNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:13:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbhLHGNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:13:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11BD4B81FBB;
        Wed,  8 Dec 2021 06:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D21ECC00446;
        Wed,  8 Dec 2021 06:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638943809;
        bh=e2il+u5Jy2tg096aExSNPImViF/HrItOqVHEpRseGj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VW+uydl99T5M8SOuNCyol7Rb7sJ8/5tertmz+OdqZbJrSgRP80jLlBoGebmQPSThF
         HZpYDJgN2FC2sOBo/lRoTGyl7fEx7u7nT4GursgJk9XjoLzzOZ4oMe/GpefKQMNiG2
         Gy21fMHrmc8uYaRSNkUCWc+iQJ4JZ9jeMHVS8c7bHCQh4AQ77CJv8lLrcf8XYz0viN
         FsegCwstlonf7vSFFSjnP7P4joLVlaXAw0/TAJB/KGvk6qdjohOSauLYRI5AHjhEWc
         63KUygbHQi1Bpn7OZZafOivusGL6Cdw/jxhtJxNNK6ZDItdcBPtGJz466Ga9byrYd8
         KQPFummE7kRMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B537260A53;
        Wed,  8 Dec 2021 06:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: felix: use kmemdup() to replace kmalloc + memcpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894380973.19666.10049198307333506096.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 06:10:09 +0000
References: <20211207064419.38632-1-hanyihao@vivo.com>
In-Reply-To: <20211207064419.38632-1-hanyihao@vivo.com>
To:     Yihao Han <hanyihao@vivo.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 22:44:18 -0800 you wrote:
> Fix following coccicheck warning:
> /drivers/net/dsa/ocelot/felix_vsc9959.c:1627:13-20:
> WARNING opportunity for kmemdup
> /drivers/net/dsa/ocelot/felix_vsc9959.c:1506:16-23:
> WARNING opportunity for kmemdup
> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: dsa: felix: use kmemdup() to replace kmalloc + memcpy
    https://git.kernel.org/netdev/net-next/c/e44aecc709ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


