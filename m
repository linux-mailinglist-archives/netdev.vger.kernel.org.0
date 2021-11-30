Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE474463445
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbhK3Mdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:33:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42252 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241589AbhK3Mde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:33:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBAB1CE19D4;
        Tue, 30 Nov 2021 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1660CC56747;
        Tue, 30 Nov 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638275412;
        bh=mQweJS5gyLzNUXwAhbkXqZ7Q/q/Ml44PN1m9lAPhzHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tiMnAkAVoGnv4ZgJcze2lCSXb5YeYlzQBtcWVSs7NY2a0Nmz0n9Up/ZZf9heXsLvD
         lFTBjGCMPwFsA1xJnhykvIyL8s4/p1nUNdEaH+YerFKM3Yvzw5bKGt9Ln1dnNaMYcY
         Re/MEFkeJiZ3EAg2oYdAlTatfPykjUXTmxDViTZT7KlvAuM5fW3nG9lPTsLbvl7WAH
         Q7qnHpnp1qQFgYauNw9f3OHpfnbvXJQBPmQs2JKQKeqhcJpguMUN972RydAk+1a4iy
         lA/xMMBvJq95VPzXHHCV1JN2GVzFO8Div15dCwnVgofRKqFr4bfRZ/5TEk3u6wW02L
         /xEjYSnM5/Ulw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E83DC60AA1;
        Tue, 30 Nov 2021 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] devlink: Simplify devlink resources unregister
 call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827541194.1181.1391720284231896683.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:30:11 +0000
References: <b5b984a05fd069ff3b01683440f5461a64e44512.1638267154.git.leonro@nvidia.com>
In-Reply-To: <b5b984a05fd069ff3b01683440f5461a64e44512.1638267154.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, idosch@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 12:16:20 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The devlink_resources_unregister() used second parameter as an
> entry point for the recursive removal of devlink resources. None
> of the callers outside of devlink core needed to use this field,
> so let's remove it.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] devlink: Simplify devlink resources unregister call
    https://git.kernel.org/netdev/net-next/c/4c897cfc46a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


