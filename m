Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6B438CF84
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhEUVBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhEUVBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A85AE613F4;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621630810;
        bh=bMj/KDHcFbGcixKv9GMVMC3HxsbX/A0IwIBURwsp0wQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=us2CQvj8tHgiz8TdQxoNESKtegeZFhBk23EVF0yCm2gw7tgrNwVnP0vq9BSHwiy5c
         rq+APmm9OEhUXg8G/nbcwnPz2iyuP3Mg1SFDEQ7SlpLuPp+2nd/XMNkgAz2vsx5IZa
         tDRCgyh2jLAO5zFF9Ut5uOD7DoVPuqkAPK9r1HUSJ6vgFKIU14fcTqOxdBtldVnK9L
         4iUAB5ZVwyrelnsWp0ZLDtuw+RajiCdpSMakRe+wg1z1V7SE84R4O7MaiNWQ/LVoGi
         QjoeMKZSqX5jLz9EyEF/zK0yHDTrW8dQGWpLhHQojqLKUcSNyKIjeUk7439cz8KUXS
         vfw2yRtWUx8aA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 987B560BFB;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] sfc: farch: fix compile warning in
 efx_farch_dimension_resources()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163081061.24690.5378264514355192742.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:00:10 +0000
References: <20210521035721.1015333-1-yangyingliang@huawei.com>
In-Reply-To: <20210521035721.1015333-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, ecree.xilinx@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 11:57:21 +0800 you wrote:
> Fix the following kernel build warning when CONFIG_SFC_SRIOV is disabled:
> 
>   drivers/net/ethernet/sfc/farch.c: In function ‘efx_farch_dimension_resources’:
>   drivers/net/ethernet/sfc/farch.c:1671:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
>     unsigned vi_count, buftbl_min, total_tx_channels;
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next,v2] sfc: farch: fix compile warning in efx_farch_dimension_resources()
    https://git.kernel.org/netdev/net-next/c/31d990cb2628

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


