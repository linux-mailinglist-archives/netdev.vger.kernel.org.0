Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0188419399
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhI0Lvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234042AbhI0Lvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FBE460F6D;
        Mon, 27 Sep 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632743408;
        bh=JGB1eAYQ/kvAoFqp4eNNf77voegSp6h6HOaCyXKMwlE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FizIvdwT7NCTapzqQTvFHpzzYkH/Z6bFCU7GEa1uXqM8dnQE9ujN7b4LlNR3cIyyO
         Vbe4BvxdSXFFt1P8emJKMs3se9VPEEKLdK7jqH+hI/F60WNZ00Trx6cDMZm0drYAoI
         Qa005vvdhTTO8FbE74i3dQCvZ8YY92q58DELk5AGEZzLQ3KGqd1hCgMe3ytrPtXrQM
         B9oieFv1WoIhzOYwC04uYVRUDq0LARQfI1onYPzHDdecz5EoxrNZ+ievCaX9zBcpvW
         nCw2bxtA2qQEv/qKASIMvtYi6iqynQ/N7uj+BCKirJAYxgf4z0AQ+AF3ZYHit0001v
         uu8kYUrZH2Tcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 22C9060A59;
        Mon, 27 Sep 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/4] net: atl1c: Fix a function name in print messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274340813.15641.14226282330751565276.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:50:08 +0000
References: <20210925134014.251-1-caihuoqing@baidu.com>
In-Reply-To: <20210925134014.251-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        michael.chan@broadcom.com, romieu@fr.zoreil.com,
        steve.glendinning@shawell.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 25 Sep 2021 21:40:10 +0800 you wrote:
> Use dma_map_single() instead of pci_map_single(),
> because the pci function wrappers are not called here.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [v2,1/4] net: atl1c: Fix a function name in print messages
    https://git.kernel.org/netdev/net-next/c/8d04c7b96424
  - [v2,2/4] net: broadcom: Fix a function name in comments
    https://git.kernel.org/netdev/net-next/c/8b58cba44e6b
  - [v2,3/4] net: sis: Fix a function name in comments
    https://git.kernel.org/netdev/net-next/c/e7e9d2088d9c
  - [v2,4/4] net: smsc: Fix function names in print messages and comments
    https://git.kernel.org/netdev/net-next/c/005552854fe6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


