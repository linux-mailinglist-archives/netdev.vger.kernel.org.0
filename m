Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21630466367
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357817AbhLBMXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53562 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357802AbhLBMXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C63DB82349;
        Thu,  2 Dec 2021 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DFADC56749;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=a0p2faoGKHmR4FoecwfPVz3P74JfB03UJvPvWBxBJw4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NlyYO2XBWc1euIUHiymgeixMXTYhAKcyQtanhKRhHIPgZahVQoQC0gi4Eat288LTs
         PotzoZ/GHafJym30mTgT8JCb4m/LDn5uFlyw2IPikbbk64MgEwwUTiM/Bv2AyAvboB
         W4LS/oCGBSI2UwPvFed4UNnlMaBMXld5WvP28efvm0zRrpMQnkzujC+czK1oPC/UWR
         9+yj8fn2eA9Ue4/ygyenslNzf4PYwxXEeEK6bQMgT3EFqRmhFv3hq3Edrk+yw2R7V/
         mh4elMHFcooD74L7mG2wEw3pUq2EL6z6DXSTrHEOQxMomnERxHLq1Ay2ApjfgBWDYa
         GV/3Ifz9j3iYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E9C0460C75;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net/rds: correct socket tunable error in rds_tcp_tune()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761095.9736.7800070669020070744.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:10 +0000
References: <20211201144522.557669-1-william.kucharski@oracle.com>
In-Reply-To: <20211201144522.557669-1-william.kucharski@oracle.com>
To:     William Kucharski <william.kucharski@oracle.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 07:45:22 -0700 you wrote:
> Correct an error where setting /proc/sys/net/rds/tcp/rds_tcp_rcvbuf would
> instead modify the socket's sk_sndbuf and would leave sk_rcvbuf untouched.
> 
> Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
> Signed-off-by: William Kucharski <william.kucharski@oracle.com>
> ---
> V2: Add Fixes tag to refer to original commit that introduced the issue
> 
> [...]

Here is the summary with links:
  - [V2] net/rds: correct socket tunable error in rds_tcp_tune()
    https://git.kernel.org/netdev/net/c/19f36edf14bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


