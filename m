Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80CE4615EC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377643AbhK2NP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:15:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56392 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377835AbhK2NN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:13:26 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2984614D4;
        Mon, 29 Nov 2021 13:10:08 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 4EDA560184;
        Mon, 29 Nov 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638191408;
        bh=LbXp/8u1CeGkCAxRN5Nfg4W8o4qGxClR38ODgpiv/kQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioCJIjjWs6s6kxDYH45CfgnKLYoSzAW72I3L6D+uWC66WG5gPxqrbsgA7q7omNtPG
         hs3wfbSUIkir17tS9FSnXFk0JSBobJHDavhoS7vh2LyiqN73Z6eT9CYL7CMCDCbxyb
         ynZmnfCxwUjDF8gfFO//lhhnDUd1c4HvKDfHUuRlHaz/HMHoq7Jh2yGlG40Y+R4G07
         fH7gwscfStaD4Ci7r7jL76Fm1aqqYMSlRe9YlsHy93gHDgtsY/+Rwyk2W/Ki2psMpH
         36nUQg7fZ3WnuGb1k3Fvu7TRee2i9UvJb1G17YXO2du8/CVDOD01f8pqY2Q48QRTd5
         6VW3xZl0cc7+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4095160A4D;
        Mon, 29 Nov 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx4_en: Update reported link modes for 1/10G
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819140825.10588.15476422794960132673.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:10:08 +0000
References: <20211128123712.82096-1-erik@kryo.se>
In-Reply-To: <20211128123712.82096-1-erik@kryo.se>
To:     Erik Ekman <erik@kryo.se>
Cc:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        michael@stapelberg.ch, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 28 Nov 2021 13:37:11 +0100 you wrote:
> When link modes were initially added in commit 2c762679435dc
> ("net/mlx4_en: Use PTYS register to query ethtool settings") and
> later updated for the new ethtool API in commit 3d8f7cc78d0eb
> ("net: mlx4: use new ETHTOOL_G/SSETTINGS API") the only 1/10G non-baseT
> link modes configured were 1000baseKX, 10000baseKX4 and 10000baseKR.
> It looks like these got picked to represent other modes since nothing
> better was available.
> 
> [...]

Here is the summary with links:
  - net/mlx4_en: Update reported link modes for 1/10G
    https://git.kernel.org/netdev/net/c/2191b1dfef7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


