Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4218341AE80
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240515AbhI1MLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240426AbhI1MLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E6DC611CA;
        Tue, 28 Sep 2021 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831007;
        bh=23rdd0WogsR7w+UI5pIpK5WZ2pDnWsYLusLtnQ83bYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZSpM7aG1iqto065pUCSSLsoEvhhj2djL762brf8VSj671jlV5NxFGsyO9+FFqOtbk
         zx8idlW6guXuhk/+XAG3Sue+tDxNyp0h3wrT/LtoNU/7W5aKqqFihpLv80Lb5ClDZH
         S3jzLtWbDf/9ISfrn6MCcNgm54XL+H/yM6lzyd/boyWYKtuv2LVZhnjnASpvg2dXzE
         EmwC63/qHby+zAIpKKkHkpv2Da3LWsivLU92OBqsBqLmRdBfNtpcD8uRBup8RpaqXS
         GJtRkH7tOMODCrJ1QqQE+Ehmpo99nNkuRkH3VXRgQyVXL2HXWDOxVhV17ocoJ0jwlo
         52XpAGSfje7ag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F05C60A69;
        Tue, 28 Sep 2021 12:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] check return value of rhashtable_init in
 mlx5e, ipv6, mac80211
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283100725.29415.17214439381941428620.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:10:07 +0000
References: <20210927033457.1020967-1-shjy180909@gmail.com>
In-Reply-To: <20210927033457.1020967-1-shjy180909@gmail.com>
To:     MichelleJin <shjy180909@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net, saeedm@nvidia.com,
        leon@kernel.org, roid@nvidia.com, paulb@nvidia.com,
        ozsh@nvidia.com, lariel@nvidia.com, cmi@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 27 Sep 2021 03:34:54 +0000 you wrote:
> When rhashtable_init() fails, it returns -EINVAL.
> However, since error return value of rhashtable_init is not checked,
> it can cause use of uninitialized pointers.
> So, fix unhandled errors of rhashtable_init.
> The three patches are essentially the same logic.
> 
> v1->v2:
>  - change commit message
>  - fix possible memory leaks
> v2->v3:
>  - split patch into mlx5e, ipv6, mac80211
> v3->v4:
>  - fix newly created warnings due to patches in net/ipv6/seg6.c
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net/mlx5e: check return value of rhashtable_init
    https://git.kernel.org/netdev/net-next/c/d7cade513752
  - [net-next,v4,2/3] net: ipv6: check return value of rhashtable_init
    https://git.kernel.org/netdev/net-next/c/f04ed7d277e8
  - [net-next,v4,3/3] net: mac80211: check return value of rhashtable_init
    https://git.kernel.org/netdev/net-next/c/f43bed7193a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


