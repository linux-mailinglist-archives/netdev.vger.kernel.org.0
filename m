Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18E12D20D8
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgLHCas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbgLHCar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607394607;
        bh=GvnFi5djifOVGnDNaXKMyxXogtjw2awg/LHAubK7A3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NLVISDdFgJ0YnmzMClDhQaEm2OxpGKcsdH723Rx316KFwko/Yxey64a+ykuWPyTOY
         +oZAQ+lQR176ePPo/x7naXBB/2xKYazsD42kM3MsPFPFnSC4mYalxzPiqy+jHfevEh
         AuRs+mezW6+pSp0IksLF9k4hObwyXlbHwf9wT2Xm811fmwgrSOtdK48QJ9EEMxtiws
         6rUwVlO/y6gbp6TIQ39tPg8RqvwckyPa6aDO/NlmsHHX1/RgvRLxl9gU4e1dDyfjiQ
         NmGBzgiAq8UiW+q9O8oNL6zM0QgKaNzSvpSGs7QLkHt4VIMOEFFs9qCxMZTnsFFB5N
         jIsOY8fuVu0vg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx4: Remove unused #define MAX_MSIX_P_PORT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160739460693.8984.6843800959500603742.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Dec 2020 02:30:06 +0000
References: <20201206091254.12476-1-tariqt@nvidia.com>
In-Reply-To: <20201206091254.12476-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        moshe@nvidia.com, ttoukan.linux@gmail.com, tariqt@mellanox.com,
        moshe@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  6 Dec 2020 11:12:54 +0200 you wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> All usages of the definition MAX_MSIX_P_PORT were removed.
> It's not in use anymore. Remove it.
> 
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx4: Remove unused #define MAX_MSIX_P_PORT
    https://git.kernel.org/netdev/net-next/c/374a96b9600c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


