Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A839E843
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhFGUWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhFGUVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E51C611C0;
        Mon,  7 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623097204;
        bh=ulVIm9VsWFOTmR3rlMKU8YtDWTDdGNSRRefrCg2/Vxs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y7ix8oSbT/yljKdqR1PT0//zKzgh72QP5+0NXUaa2D6QKVIG+1/+Put+IKPK2ePBh
         PKo136rGS0Vulu32jv+hosoFF7WQvSGwnjTskWeasB3zoKGo70DPxy/28XpgjJI7MV
         MRQGCjsZRbqcLkj3vpUiB1LmU0d2afJiEJ94WwpXzAhHEtRxqmOHOm0rjiWelDDzX/
         u6OqgsOkjGQGgoUZWKKP7CRrJVKQFbOeJBDWmKd912PUXEZ5NlhLR7IvxboOfEdX7v
         DtCcL2sACsWfXACs4jGliihIbF38ZxmvM5kRlwaxa/QPSgVoHZuDJc4UrVlj1xo0rr
         rVRYFJ+9pj0nA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2828C60BE1;
        Mon,  7 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: dsa: hellcreek: Use is_zero_ether_addr() instead
 of memcmp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309720416.9512.9308224561664728090.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:20:04 +0000
References: <1623034629-30384-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1623034629-30384-1-git-send-email-zou_wei@huawei.com>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     kurt@linutronix.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 10:57:09 +0800 you wrote:
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is all
> zeros.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: dsa: hellcreek: Use is_zero_ether_addr() instead of memcmp()
    https://git.kernel.org/netdev/net-next/c/3f07ce8e5287

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


