Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184C73FC66C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbhHaLLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241366AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 245DA6101B;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=Uqu049uIOcb9M8GBl4e4UiN9feInfuwC8uGBtr6/QbY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VQNewKUPfhWhppe3CB2U3JYTKbX/ODOMaRpl34xbzid41u2LTmKps0rnRpqC5f+kD
         Gybb5/Eh8PtsWy+eLOnbDd8pAjoF5gzpmWrm0VF2HgI4dPxP1sSQe52DkTFW2+j7Zp
         1hY+dvuYePObyWobc7JiRzs8kd/uJyO9UZp0a+d7hRAamcGrPue9sd/YlYkxzDRvq5
         2/HinR0mR9Pa2lPydIW/J/phnG+m/LPBx0u6gYnF0G9OV+hEdZQU4Kvprhb80xA7BE
         slN5hYIAOJ5l6h50By1Rhj25ePSwYDV1jVB8qZKSSpxEYlDbDzXn/wfbpAsiY9bWmB
         kt2JTxytvkseg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C73A60A9D;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio: mscc-miim: Make use of the helper function
 devm_platform_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820811.5377.8294383823835053431.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210831075818.833-1-caihuoqing@baidu.com>
In-Reply-To: <20210831075818.833-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 31 Aug 2021 15:58:18 +0800 you wrote:
> Use the devm_platform_ioremap_resource() helper instead of
> calling platform_get_resource() and devm_ioremap_resource()
> separately
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/mdio/mdio-mscc-miim.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Here is the summary with links:
  - net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/672a1c394950

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


