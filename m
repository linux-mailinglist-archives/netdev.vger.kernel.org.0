Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1163D1969
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhGUVJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhGUVJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 17:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 742AD6120C;
        Wed, 21 Jul 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626904204;
        bh=Kic6Z2WqQnPYpronTr8E7G6Pbl56tTXVwdL34xrRoZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fjGu0IQ0x7/yjFNvv5HVmE2biDw/lyAQ7hy7geJuSe6PJh3fcIIQwVqxh0id+1GQy
         wb0iUCTs8rC7ncpFwebu/odpAB1lA+KxaU1FJp9lvDPytDX4WrNdhwrQpNwWsHXmmS
         RSNSM0ChaoRSQUbKO28/pjm7/W2GvYs6dzF91Uc5j8qHzKi2RSi872lbyaxFc9f+sA
         dqA3aj7CetZLmUg+4sDM7h7rMKr77Sad+1t2evq5pDnT6VA26SV852uZQk+tbQKek6
         /p/F3FMa/6+Lw7PoGHR1cQ0VE0lqOZ/CGApiJfMpgj+dVcwDDgGYguTI7o1XOKDOpb
         7VzmwM5mYA6aA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64ADD609B0;
        Wed, 21 Jul 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ionic: cleanly release devlink instance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162690420440.1414.7018903583171488691.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 21:50:04 +0000
References: <956213a5c415c30e7e9f9c20bb50bc5b50ba4d18.1626870761.git.leonro@nvidia.com>
In-Reply-To: <956213a5c415c30e7e9f9c20bb50bc5b50ba4d18.1626870761.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, snelson@pensando.io,
        leonro@nvidia.com, drivers@pensando.io,
        linux-kernel@vger.kernel.org, moshe@nvidia.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 15:39:44 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The failure to register devlink will leave the system with dangled
> devlink resource, which is not cleaned if devlink_port_register() fails.
> 
> In order to remove access to ".registered" field of struct devlink_port,
> require both devlink_register and devlink_port_register to success and
> check it through device pointer.
> 
> [...]

Here is the summary with links:
  - [net-next] ionic: cleanly release devlink instance
    https://git.kernel.org/netdev/net-next/c/c2255ff47768

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


