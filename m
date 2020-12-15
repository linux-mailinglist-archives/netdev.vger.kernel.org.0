Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E1F2DA6E7
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgLODlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgLODkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:40:52 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003608;
        bh=0EcnoPt5Z0U0kW+94RrXtqfhjDHLj4Q1OABwMZhfVZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LumNlUXVb7k8Qmx5iq6dsDlXJCuD28HmkioqvvA10/5EafgBBtIMqPyTz7nTUDK4m
         fwIkugk6eUkjZlg2Hpyc6askIVIFYg2WAInawyXVNMeghRjXh27nqqZTvosdnxb3ut
         H8Ro2gGl3P+9z1QBqZsx1LmRoS0pAdENrnr7/G0dzGlgWgi1EarBhU7wuksCS2RHJD
         ZSyEBmRMzBSKURHpn3PLZPH9tCkj/lJT9IMo0Ag6Z3J6Qc/Vd0cb/jwycc5fHsMOHz
         lrJdm/ObIVLMg5oSw7x6hhpDkAHRjeudEqHwy1rcEGVx8quu57r2zWw8wMgI0KjBOO
         EKLs6cB+hYuTg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800360874.3580.2189141484946329446.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:40:08 +0000
References: <20201213143929.26253-1-tariqt@nvidia.com>
In-Reply-To: <20201213143929.26253-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, moshe@nvidia.com, borisp@nvidia.com,
        ttoukan.linux@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Dec 2020 16:39:29 +0200 you wrote:
> With NETIF_F_HW_TLS_TX packets are encrypted in HW. This cannot be
> logically done when HW_CSUM offload is off.
> 
> Fixes: 2342a8512a1e ("net: Add TLS TX offload features")
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Boris Pismenny <borisp@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,V3] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled
    https://git.kernel.org/netdev/net-next/c/ae0b04b238e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


