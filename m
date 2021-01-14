Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3392F6AFE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbhANTat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbhANTat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 14:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D95C23B54;
        Thu, 14 Jan 2021 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610652608;
        bh=aQljlHyrnf6iRHq+7JysV19JYEvHsea3/CYvbg9l2ow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kkkZSn0bKqE6bZ7amUGx1qHa9jkr6kxEUo36ZzG2tnNJFQHMb6dNOYNEVrr42dJF0
         xvDNzQjdfE5rSrUJymAHjzIfxXsAIuTKVX/D6Cjd/lR5ykTzcLalNejbFzC047rofr
         NvU0VOtyM0TxS0TG20FyjVGb+4+7vJDfVutNa6ZOSdSksSZgXaLMOvhr9HtgRkh+nA
         3DXkgQ+zpMDwDr36VCmdVNM3LBf6Ya41EO5ywxK3eFnU+5Rft+rALraBhcFKW2iij/
         s2AP86PXTvMf2bgMcH4penXuKgc+oy1GF1GNy9JQeKzlgGujAARoe2zBDsuGpJjoWb
         pclK5MTkmSHPA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7C46960156;
        Thu, 14 Jan 2021 19:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: Allow NETIF_F_HW_TLS_TX if IP_CSUM && IPV6_CSUM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161065260850.1502.2083679952734163715.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 19:30:08 +0000
References: <20210114151215.7061-1-tariqt@nvidia.com>
In-Reply-To: <20210114151215.7061-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        netdev@vger.kernel.org, ttoukan.linux@gmail.com,
        alexander.duyck@gmail.com, rohitm@chelsio.com, maximmi@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 14 Jan 2021 17:12:15 +0200 you wrote:
> Cited patch below blocked the TLS TX device offload unless HW_CSUM
> is set. This broke devices that use IP_CSUM && IP6_CSUM.
> Here we fix it.
> 
> Note that the single HW_TLS_TX feature flag indicates support for
> both IPv4/6, hence it should still be disabled in case only one of
> (IP_CSUM | IPV6_CSUM) is set.
> 
> [...]

Here is the summary with links:
  - [net] net: Allow NETIF_F_HW_TLS_TX if IP_CSUM && IPV6_CSUM
    https://git.kernel.org/netdev/net/c/25537d71e2d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


