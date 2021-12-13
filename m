Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9D47302A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240011AbhLMPKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:10:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33622 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhLMPKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:10:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87FE06114A
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 15:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9E29C34608;
        Mon, 13 Dec 2021 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639408209;
        bh=dg5sd+ohnGAVAj8wjQ9M4vt9CnvDIyLEH0vFplju5hk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IgLFeSeoHmhvjgOHQfvm1B2t5FCkzoQDeica/vpqQuoUfwsai+tLjVRCJ7BL5AfVN
         74W/ZvyXzqeZtKehrMJj4TOEFVb15yjDfSY+TKus+06x2YtuILaHPa4IPJMSbPtA62
         wYWqRARp1wk5slRFBpoz1c/p1VUS+smpUJSQGJqVvSJxmngmflYMmhlqwORqU2B4Pe
         F6ZBUAM/w7tZ8aXLcsF9EydSiAcs7Sy+dH49D7SnSCn1mbxV3+GwFjnRr48czB90a+
         vEjotcOLL8l/4gv6nx0n5ZeLcdzHFPMajZksCRIIVY3JTq/ExOMlpCZ9NXDlSL2ntl
         bZyMLu3VbWj7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D6EA1609CD;
        Mon, 13 Dec 2021 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mtk_eth: add COMPILE_TEST support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940820887.31162.94347076363115868.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:10:08 +0000
References: <208b18f9e48e1ebddaee4baf28721bd3f9715046.1639394268.git.lorenzo@kernel.org>
In-Reply-To: <208b18f9e48e1ebddaee4baf28721bd3f9715046.1639394268.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        mark-mc.Lee@mediatek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 12:23:22 +0100 you wrote:
> Improve the build testing of mtk_eth drivers by enabling them when
> COMPILE_TEST is selected. Moreover COMPILE_TEST will be useful
> for the driver development.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: mtk_eth: add COMPILE_TEST support
    https://git.kernel.org/netdev/net-next/c/a3c62a042237

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


