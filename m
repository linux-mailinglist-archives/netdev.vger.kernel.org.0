Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269C434D95F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhC2VAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 17:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230322AbhC2VAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 530696196E;
        Mon, 29 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051609;
        bh=c2y7cP8VI8VI0dNAAzPt+gv3HPp3+HewUev707Sqvr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbquZ3tmeG5BKxrPuWrfc34XmLlWw0a8Qb2eQyObwSgxx5C2Ebk/rYvraIKe+Y3Un
         I2wXi1Ty5thPWv6p9zlzxMPv3VgUI8Q0zPaM76E0CKNcfdi246Rs5oocC6DsOveTcN
         ze8XrU/A+6TrgjLWIYosUW87PF7ukat7sPFYpq+aJ3tc5oxs3MQp9y2igl/kVGR5mD
         6DpvN349wenivPbE2CT2xKcfVP5Ziy7MNk+d3eVP/3FXnYSkPUCulJap+250z9vTD9
         tjZo2mYA2bKMFLlpbq6+olCA5RWqPqGW573/155/MY0DLjWiAuHwfE3Lqp2nofclv/
         7eLNcV8ChuRhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 448E860A49;
        Mon, 29 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: dsa: Fix type was not set for devlink port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705160927.24062.3667922737277765851.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 21:00:09 +0000
References: <20210329153016.1940552-1-fido_max@inbox.ru>
In-Reply-To: <20210329153016.1940552-1-fido_max@inbox.ru>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 18:30:16 +0300 you wrote:
> If PHY is not available on DSA port (described at devicetree but absent or
> failed to detect) then kernel prints warning after 3700 secs:
> 
> [ 3707.948771] ------------[ cut here ]------------
> [ 3707.948784] Type was not set for devlink port.
> [ 3707.948894] WARNING: CPU: 1 PID: 17 at net/core/devlink.c:8097 0xc083f9d8
> 
> [...]

Here is the summary with links:
  - [1/1] net: dsa: Fix type was not set for devlink port
    https://git.kernel.org/netdev/net/c/fb6ec87f7229

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


