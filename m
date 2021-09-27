Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70B2419440
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhI0Mbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhI0Mbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1E400610FC;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745808;
        bh=xHTe2YyerwMSq3qI11b0v3X5NSnewGlpPaaAGYImSPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t54oPGZrJzx2HDrrzsjRAN4HIoQCAkysm2isW+vl8dNM/ZdYA7gNW4MlknB7hu5b/
         YdffpoikdYgFfpqKGrNv4WFCC+hgfYySedO26k/3An+IYfqLUjbls2kExwbRbHmIr5
         YG/V8TiXdgQtQypg6oMELYbDbG9witBKTVc9HvHIHgR2YnPGIWg0/rTRawDL/Rl2NL
         Rxs/4i9VOXGotp0vH6E6eL63qA7IiUJPjh5RdfQjn5quBVrWCPyWj6Pvvz9WJPpdOT
         KVVjzOPZrf/6kDvw2FCPOX+xTSHC7KttuvIHhNOuv/5q5aZCUnQCBRBukVAMx50fuw
         2a4/oevbOQeBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1907B60A59;
        Mon, 27 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cisco: Fix a function name in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274580809.1790.15070216648783190469.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:30:08 +0000
References: <20210925124629.250-1-caihuoqing@baidu.com>
In-Reply-To: <20210925124629.250-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     benve@cisco.com, _govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 25 Sep 2021 20:46:28 +0800 you wrote:
> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/cisco/enic/enic_ethtool.c | 4 ++--
>  drivers/net/ethernet/cisco/enic/enic_main.c    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: cisco: Fix a function name in comments
    https://git.kernel.org/netdev/net-next/c/f947fcaffd6a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


