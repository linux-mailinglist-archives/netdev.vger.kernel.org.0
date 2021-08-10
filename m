Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B223E8459
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhHJUaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhHJUa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 16:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D915A61008;
        Tue, 10 Aug 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628627405;
        bh=2lDrpN5sVgt5Al+6FtFDkfLPd2yIOq9/MTsVWaprtBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aMxK/lnKxAxzyHW1M86Q4h5jZQ7QsE1PI+9bepMwe5zmMTR0f8ZiaActaaAEgOdDh
         WWIv1lmv4pZQ600DjYEKD/7ML71RBMQzKwQ+iq/uKKnI3hQhepAWUr6ay4Zd7wzMwz
         lrZ8nRsZ0FAr7RH/GW+0Q8BE1T30JO5lMPHGf8qNYiNHO0Vmg/NQlOklLHp91sPykc
         p7e0xM+vdQ8s6Vwoshr3KfByV7QXS/R/XNFau+sq4R3PA30G7h3vraSrUxTt4uIRos
         CyEX5ScZxkbKV0++IOA3J9JO7qrs9BMkuqjJhxLrlqlznT4r1jtZOuqimMFOgD8fHq
         2teZsmGlvc20A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C958D60A3B;
        Tue, 10 Aug 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162862740581.16281.10031076649352815360.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 20:30:05 +0000
References: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, vkochan@marvell.com, tchornyi@marvell.com,
        saeedm@nvidia.com, leon@kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        grygorii.strashko@ti.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        jianbol@nvidia.com, vladbu@nvidia.com,
        bjarni.jonasson@microchip.com, vigneshr@ti.com,
        tobias@waldekranz.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@armlinux.org.uk, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 14:50:24 +0300 you wrote:
> The blamed commit a new field to struct switchdev_notifier_fdb_info, but
> did not make sure that all call paths set it to something valid. For
> example, a switchdev driver may emit a SWITCHDEV_FDB_ADD_TO_BRIDGE
> notifier, and since the 'is_local' flag is not set, it contains junk
> from the stack, so the bridge might interpret those notifications as
> being for local FDB entries when that was not intended.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: switchdev: zero-initialize struct switchdev_notifier_fdb_info emitted by drivers towards the bridge
    https://git.kernel.org/netdev/net/c/c35b57ceff90

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


