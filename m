Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA504475124
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbhLODAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:00:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32894 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhLODAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3104CB81E21
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBCE4C34609;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639537210;
        bh=B41WHbrZNZ+YzVHc/Po/mFqwrMWoRTrsKlPxxjwqA9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uI+j/4docbTrOQmk8He0ds3dEqpLl5IJrTdVN9/B+tuDiFRD3oDDaSEVGtWVeid/e
         T9kOIV32BYzftcr8nUnaAN4Ar0ke5hZCwQUZSVryR929SeOpiTHiaCmX3H+y+evUBB
         ifFyxnbk5KoedL11z4JZVPApT8cqKCrBm4eJp2LoXBM1zj2U4Y6bAD9MWdjYmhwcne
         46vjI9gcTnY6WpaNNbQBCMq4lD2meHQcaJRrxpg6Hjm/MZQJDhFo5c3dnbDKL8iic1
         wbRSoPuxjmyJKvBByTM0TFw8aahd37TdXhiT0nZSejYqJn/4IcPnnGqS4T/rWthH0Q
         PxAxC7l3JFVFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7490609CD;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: dsa: hellcreek: Fix handling of MGMT
 protocols
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163953721074.25069.14421499568542278371.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 03:00:10 +0000
References: <20211214134508.57806-1-kurt@linutronix.de>
In-Reply-To: <20211214134508.57806-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Dec 2021 14:45:04 +0100 you wrote:
> Hi,
> 
> this series fixes some minor issues with regards to management protocols such as
> PTP and STP in the hellcreek DSA driver. Configure static FDB for these
> protocols. The end result is:
> 
> |root@tsn:~# mv88e6xxx_dump --atu
> |Using device <platform/ff240000.switch>
> |ATU:
> |FID  MAC               0123 Age OBT Pass Static Reprio Prio
> |   0 01:1b:19:00:00:00 1100   1               X       X    6
> |   1 01:00:5e:00:01:81 1100   1               X       X    6
> |   2 33:33:00:00:01:81 1100   1               X       X    6
> |   3 01:80:c2:00:00:0e 1100   1        X      X       X    6
> |   4 01:00:5e:00:00:6b 1100   1        X      X       X    6
> |   5 33:33:00:00:00:6b 1100   1        X      X       X    6
> |   6 01:80:c2:00:00:00 1100   1        X      X       X    6
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: dsa: hellcreek: Fix insertion of static FDB entries
    https://git.kernel.org/netdev/net-next/c/4db4c3ea5697
  - [net-next,v2,2/4] net: dsa: hellcreek: Add STP forwarding rule
    https://git.kernel.org/netdev/net-next/c/b7ade35eb53a
  - [net-next,v2,3/4] net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
    https://git.kernel.org/netdev/net-next/c/cad1798d2d08
  - [net-next,v2,4/4] net: dsa: hellcreek: Add missing PTP via UDP rules
    https://git.kernel.org/netdev/net-next/c/6cf01e451599

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


