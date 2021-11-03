Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801F9444077
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhKCLWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231514AbhKCLWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 07:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 34F9261166;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635938409;
        bh=dV4G1vR9a46wxDO+ClKpsM0XoC01urrvt68bMLhDYlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=up2L+7sOpf1E6k3DmBMua5W3knV6dyCHKekJHhtb7QDJQYPHIQi7f2GndydzEcIyS
         x2DamQEbyf86N9oyX8CSiMg6hQ3k7bVbYkm5VUH7TCH990hyGvhqoF1W6jHJn7qb4q
         2qcdiB4oUclLrS5YZCFX/Xs0pWBlxZFG7IMkRm65caM2ergJgZqaKpO7HxBf0/vbGV
         m49CdLVkC17sESlZIIYAaxIcvDQhjOIyjdLLhrmtXDKU/Kco9AcJ6g1UmSMo9yD9Vx
         WlPB9Fgzt+qf6ro2guC3n0tD75nwFATBSN8Fv+LAGyTR68Y8icyRlhzXeq9E7NCWsS
         pFiE3KksgWxUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 272FA60A2E;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: add necessary privilege flags in netlink layer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163593840915.17756.4151326111670832536.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 11:20:09 +0000
References: <20211102081021.32237-1-linma@zju.edu.cn>
In-Reply-To: <20211102081021.32237-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 Nov 2021 16:10:21 +0800 you wrote:
> The CAP_NET_ADMIN checks are needed to prevent attackers faking a
> device under NCIUARTSETDRIVER and exploit privileged commands.
> 
> This patch add GENL_ADMIN_PERM flags in genl_ops to fulfill the check.
> Except for commands like NFC_CMD_GET_DEVICE, NFC_CMD_GET_TARGET,
> NFC_CMD_LLC_GET_PARAMS, and NFC_CMD_GET_SE, which are mainly information-
> read operations.
> 
> [...]

Here is the summary with links:
  - NFC: add necessary privilege flags in netlink layer
    https://git.kernel.org/netdev/net/c/aedddb4e45b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


