Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4853841D964
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349066AbhI3MLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348155AbhI3MLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 72007619E0;
        Thu, 30 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633003808;
        bh=nMzn8rGDwe7YPHqlnRaS+GfARlasERn7uiVyOZ6En9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gMc19xdcKLCa6bVhQH7PBauFvBcKBaRMlIZ2+4BONgvh5bRNj0RPYXeTHBQuETF+6
         IG8w4hKdTDs58Yrg4uMyW3qXXqpYnnuaU8azz7PUrPJXmm8ibCgWbyTlNnjYjKofCU
         LhZnKcyy4fTAaysgbkzmeuV1XhvN0f6U3Fdsw30KADQm53eEWXFfCD+HuWJTupe1fY
         LV9Lv1GHURYWKTcfoTXRKZR46/FEAEmxNdEV8/+YtBii2GvLIwPuVlwpy03hnweCmq
         8L50xji2NqF/cZXSmV/XyG3U5wEuvxmO23ji1WZ1bL8eCUTGbI32PzNvGStrnP3t5m
         ijo575fvy9m+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68CBA60A3C;
        Thu, 30 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Adjust LA pointer for cpt parse header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300380842.14665.3784830709189972257.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:10:08 +0000
References: <20210929055831.991726-1-kirankumark@marvell.com>
In-Reply-To: <20210929055831.991726-1-kirankumark@marvell.com>
To:     <kirankumark@marvell.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 11:28:31 +0530 you wrote:
> From: Kiran Kumar K <kirankumark@marvell.com>
> 
> In case of ltype NPC_LT_LA_CPT_HDR, LA pointer is pointing to the
> start of cpt parse header. Since cpt parse header has veriable
> length padding, this will be a problem for DMAC extraction. Adding
> KPU profile changes to adjust the LA pointer to start at ether header
> in case of cpt parse header by
>    - Adding ptr advance in pkind 58 to a fixed value 40
>    - Adding variable length offset 7 and mask 7 (pad len in
>      CPT_PARSE_HDR).
> Also added the missing static declaration for npc_set_var_len_offset_pkind
> function.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Adjust LA pointer for cpt parse header
    https://git.kernel.org/netdev/net-next/c/85212a127e46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


