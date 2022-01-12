Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2258948C679
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354306AbiALOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:50:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49910 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354287AbiALOuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:50:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76285B81F4C;
        Wed, 12 Jan 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29EA6C36AEC;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641999010;
        bh=8fsjYL5GElPNc2Wpnns50AVfa6CS5KJbCCEroNMbQZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OzB3hSdTYR8MdCOvSS5SFdsVXdVjGJAFGuKBWpfy0DF1I4rzQTdeLYkEoN3t8EbBe
         lXJLaDvYF9OxQdlKrssFctp4AOsVlKisvOSkL2srsBIocxrhl5gFow2jDtnQ7tlDzj
         bquv5dynKJ4fayLo3RLnoYDdT2tAIsKU6J6w+/SD7Ml2yVWZMAJnGdPErR/kQdCXAo
         q8AYWRuuePu7iRNKBx3V5HZYcn25qJ4kxO4Go05duQWe70n99Df8Ho89qUJMuGwEEn
         W3KiDK8JPuNNKHvcWycHshPyqjthlBSCpoabgTNPqYWYg9QWaanFQBOjWZTtZphG7w
         3jqRg/v/bBmfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 147E0F6079A;
        Wed, 12 Jan 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bonding: fix bond_xmit_broadcast return value error
 bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199901007.15011.9104408276637809062.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:50:10 +0000
References: <20220112125418.55118-1-huangguangbin2@huawei.com>
In-Reply-To: <20220112125418.55118-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 20:54:18 +0800 you wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> In Linux bonding scenario, one packet is copied to several copies and sent
> by all slave device of bond0 in mode 3(broadcast mode). The mode 3 xmit
> function bond_xmit_broadcast() only ueses the last slave device's tx result
> as the final result. In this case, if the last slave device is down, then
> it always return NET_XMIT_DROP, even though the other slave devices xmit
> success. It may cause the tx statistics error, and cause the application
> (e.g. scp) consider the network is unreachable.
> 
> [...]

Here is the summary with links:
  - [net] net: bonding: fix bond_xmit_broadcast return value error bug
    https://git.kernel.org/netdev/net/c/4e5bd03ae346

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


