Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C838640DBB3
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhIPNv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235923AbhIPNv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ECB6261212;
        Thu, 16 Sep 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631800207;
        bh=f0RCDBkeuLybOsenKyyTG2LmY1uaDHsvLuk75cwzZFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DXplfQpQyy6HGH/TFmeoyEibGlNTnAy2c4gZZVpIhJJsYhTi9CXnMnFakLObljcvf
         cTzV9tGRHu6X6gZPUXN5/2GrkEVgA4HYc37xd1L+2+ozpqQCTT0bR2kzFjCuQuQz34
         W+LgtXEbT9G9gP3EReJZpDbUDmIawhoM5bAd4lvgE0AL4qLjbjnEWAnOPxps6QVBmp
         EESQ7tZB/hQL+lAK30cZB3FPEsAz7ab3l0NPoOcykd9+k+YiGIMARpsEH+iiuO8oEA
         wzAD5cYMwQjVqGcqATTBWgzB5+ji03aHQSMGD2YxZp0/MZhZqBpeIfJ6B20iekWbYC
         DA0RSQtaRed+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D89B660A9E;
        Thu, 16 Sep 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-af: Hardware configuration for inline
 IPsec
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163180020688.23290.16343906865989562587.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:50:06 +0000
References: <20210916094114.1538752-1-schalla@marvell.com>
In-Reply-To: <20210916094114.1538752-1-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        hkelam@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        vvelumuri@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 15:11:14 +0530 you wrote:
> On OcteonTX2/CN10K SoC, the admin function (AF) is the only one
> with all priviliges to configure HW and alloc resources, PFs and
> it's VFs have to request AF via mailbox for all their needs.
> This patch adds new mailbox messages for CPT PFs and VFs to configure
> HW resources for inline-IPsec.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> Signed-off-by: Vidya Sagar Velumuri <vvelumuri@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Hardware configuration for inline IPsec
    https://git.kernel.org/netdev/net-next/c/4b5a3ab17c6c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


