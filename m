Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2BF3DE221
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhHBWKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232130AbhHBWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94B9660F9C;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942206;
        bh=i669jGsrQQkFldfXrwStoUbgBRD+Oa6wkNWDnfm7j8g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F0WbQu5GOQTnosuoJnkRfmVUeoQ/tbulSFSRdJatlUDrxBJYHSrEmn6hZj82q+3Na
         s+L5rpKpirPhvE4YvK48w1Yb9MtHLuvtItU6DhhavUjfVWSFVuTeVNenGydySgHaz8
         2nIZmmRtbrMbWNSM9zRXPfCYbViKD0LOSKCH+KJMe2DbqVz2vIk7kIeeh00XJyEGrx
         kCRkZLZ833z6AaRA7Zi6ipoeFwKd+9h7EgatM3gxiFP5ZmxL56Aqhd4EWaKecWIPtR
         Coi5ep1Gc0KX95AGrmwSP7Nb165z5gWbQVJmjZJ/ZR1+yo8rpXE8KaGAaid96ykn0j
         jSmC/F/VpWArg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90073609D2;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4: make the array states static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162794220658.7989.5405724350145855237.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 22:10:06 +0000
References: <20210801153742.147304-1-colin.king@canonical.com>
In-Reply-To: <20210801153742.147304-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 16:37:42 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array states on the stack but instead it
> static const. Makes the object code smaller by 79 bytes.
> 
> Before:
>    text   data   bss    dec    hex filename
>   21309   8304   192  29805   746d drivers/net/ethernet/mellanox/mlx4/qp.o
> 
> [...]

Here is the summary with links:
  - net/mlx4: make the array states static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/7cdd0a89ec70

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


