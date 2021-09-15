Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA09740C3A1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhIOKbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232304AbhIOKbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 06:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8407A61264;
        Wed, 15 Sep 2021 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631701813;
        bh=jdmVvPHukyHZKRwq9G234NU2Mc/pWdC6USWlLOKk20E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l8JddP0ugQQGqzeFk9LiE5jTKqyxQdHaQPFUf6BJAJevYqLVtqznqKAYMt/vKYDAW
         svXoYXsGgz171uYcmd9eDlyGY4UZcm7ZansKDK+AQ+wLOz9Lo2uV4AjKWCn1yRlb95
         cFSiSxb3h7MpOMGcRESXzCL62V5pb32u7+2Jmo/x9FZUxGN3+XYYfv+nst9HghQcZi
         BKUl7XmwT/f2Fa5tqQEZYN9L41lYrXZL5X6l3M31ekA4abOGevSSX+iza22yPxBLfq
         YLqIfzSk9gELc+d6GuwWmnez9RPTV898CyLYzIcMzT0SPRzH6I9fzxkw278LvDVdqx
         zXdj8d+2K5rVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7336060BC7;
        Wed, 15 Sep 2021 10:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/8] MIPS: lantiq: dma: add small delay after reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163170181346.3937.14860350740093197209.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 10:30:13 +0000
References: <20210914212105.76186-1-olek2@wp.pl>
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     john@phrozen.org, tsbogend@alpha.franken.de, maz@kernel.org,
        ralf@linux-mips.org, ralph.hempel@lantiq.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hauke@hauke-m.de,
        dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 23:20:58 +0200 you wrote:
> Reading the DMA registers immediately after the reset causes
> Data Bus Error. Adding a small delay fixes this issue.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  arch/mips/lantiq/xway/dma.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - [net-next,1/8] MIPS: lantiq: dma: add small delay after reset
    https://git.kernel.org/netdev/net-next/c/c12aa581f6d5
  - [net-next,2/8] MIPS: lantiq: dma: reset correct number of channel
    https://git.kernel.org/netdev/net-next/c/5ca9ce2ba4d5
  - [net-next,3/8] MIPS: lantiq: dma: fix burst length for DEU
    https://git.kernel.org/netdev/net-next/c/5ad74d39c51d
  - [net-next,4/8] MIPS: lantiq: dma: make the burst length configurable by the drivers
    https://git.kernel.org/netdev/net-next/c/49293bbc50cb
  - [net-next,5/8] net: lantiq: configure the burst length in ethernet drivers
    https://git.kernel.org/netdev/net-next/c/14d4e308e0aa
  - [net-next,6/8] dt-bindings: net: lantiq-xrx200-net: convert to the json-schema
    https://git.kernel.org/netdev/net-next/c/5535bcfa725a
  - [net-next,7/8] dt-bindings: net: lantiq,etop-xway: Document Lantiq Xway ETOP bindings
    https://git.kernel.org/netdev/net-next/c/dac0bad93741
  - [net-next,8/8] dt-bindings: net: lantiq: Add the burst length properties
    https://git.kernel.org/netdev/net-next/c/c68872146489

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


