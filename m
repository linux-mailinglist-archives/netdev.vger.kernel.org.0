Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EACD465C79
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344788AbhLBDNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:13:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34558 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhLBDNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:13:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE43B821E3;
        Thu,  2 Dec 2021 03:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78D2BC53FAD;
        Thu,  2 Dec 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638414609;
        bh=zPEZRFtuMmjA0VGuSD+pY/RqcTQxKhoEevsXgAFdXGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BhoNMft/ifsdXPgSxTAwc585k9MF2EAzzHAK+7rB7PZ/qwqirj/25GEL2Gx9A5LIK
         Xl9xbhVINHKAdRDEa8O+y1IgNR5P8EHplZiZOTc2BLJF4sw29TNlW7sJ1MkKaPhXFC
         uwttcBruv1G9sgHizzVl7FPKGsivT38jv9YOwWR+e6OZRmJZn6H5ngOsKQ7euTLLmh
         ub1HECz59gNVIt8dgEGTD+utb0Y51LG+hCLBOy94Xh3676jOt/aeM6b6sTZk8VVX83
         9sfMQRC2irPxWsVNxGzFS7XcMslh3xEzZLi8NZM0eF9E97QMqZy6BxiqsVFOCtWGwp
         qMgOd+VgrRflg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5752160A59;
        Thu,  2 Dec 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4_en: Fix an use-after-free bug in
 mlx4_en_try_alloc_resources()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841460935.28228.11406100673207089188.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:10:09 +0000
References: <20211130164438.190591-1-zhou1615@umn.edu>
In-Reply-To: <20211130164438.190591-1-zhou1615@umn.edu>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, tariqt@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, eugenia@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Dec 2021 00:44:38 +0800 you wrote:
> In mlx4_en_try_alloc_resources(), mlx4_en_copy_priv() is called and
> tmp->tx_cq will be freed on the error path of mlx4_en_copy_priv().
> After that mlx4_en_alloc_resources() is called and there is a dereference
> of &tmp->tx_cq[t][i] in mlx4_en_alloc_resources(), which could lead to
> a use after free problem on failure of mlx4_en_copy_priv().
> 
> Fix this bug by adding a check of mlx4_en_copy_priv()
> 
> [...]

Here is the summary with links:
  - net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()
    https://git.kernel.org/netdev/net/c/addad7643142

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


