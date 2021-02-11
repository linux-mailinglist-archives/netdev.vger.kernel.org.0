Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339FC3194DB
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhBKVKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhBKVKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 16:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2095E64E3E;
        Thu, 11 Feb 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613077810;
        bh=qjdKdw1EiDNvN+to2iN4Vtry16P9YftuAiaRvAK0R/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c/OqsfPveQG42iaVff+vN9RQn9JTteCf31RZ9SsSvcQCXLKB1IQumbndh50BsPpcG
         GjLIA2FtABx0OTbUp3QWLiR5i+WjSSl2RB1f8s+bkKv7fAco0EPLwrMYCEYLdtu+xo
         pucS2bQe63lzF8YyozbGqEWflT6HF+aG81EStFklHIJWCrqPKAeMBPZUVjJSZU+Tc9
         Q6ESz2QriAvCOI7LPbk/wU52gMDPGdIA4nTSxFZCCvEPdzkqZErz+ym9Km2sjK/TlR
         xwBHc6srFRI7k7je9+ASk1H+0Slasb7iw3xd3ZbvwtT73gaAwY3Lpd/oFE4tB7wgC+
         KU4UPkMVZJhYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1060760A0F;
        Thu, 11 Feb 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Fix dmac_filter trap name,
 align to its documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161307781006.4804.10061110711546511131.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 21:10:10 +0000
References: <1612868395-22884-1-git-send-email-ayal@nvidia.com>
In-Reply-To: <1612868395-22884-1-git-send-email-ayal@nvidia.com>
To:     Aya Levin <ayal@nvidia.com>
Cc:     davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        saeedm@nvidia.com, netdev@vger.kernel.org, tariqt@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Feb 2021 12:59:55 +0200 you wrote:
> %s/dest_mac_filter/dmac_filter/g
> 
> Fixes: e78ab164591f ("devlink: Add DMAC filter generic packet trap")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reported-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Fix dmac_filter trap name, align to its documentation
    https://git.kernel.org/netdev/net-next/c/e13e4536f092

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


