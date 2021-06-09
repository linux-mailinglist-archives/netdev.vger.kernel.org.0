Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A793A2010
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFIWcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7FF8613F4;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277805;
        bh=SjuD7Iv+zSgiH3EQEY9D1jAeRMWUMm/eCIiUuF9aytU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fRszfqjgDQVbpcMWbvG2tYFb5HM0zk9sL3NwHBh640vBr6Z8LV3lB5W1IjbnK0Q77
         RxIPoZmlxG5Ij3FBnuwrf+EPZcydcpGX4/c0M7kekeAv6fkb2RPWxCIXU51fIvFkil
         bO/lSoJK7c//BqteMKp0X161m0jWnCResILgTrfPtGznkxsg1bMrIo5/btV47Q0kNe
         qp8M242EbuRkxwgXTYJeooNK+8IKLIWqleUAOmuQpv8HQaI681XfO8FwsOQVLwn0HX
         DALbuXWJmblTAIeTZgk0U9sUE0gwB09JndLtUtkweNIUqMbjh/j+BmpT2ajAU4pDvE
         iLCDexL5iKv+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE02460A0E;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw-phy-sel: Use
 devm_platform_ioremap_resource_byname()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780590.20375.701598513333093609.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609135138.3192652-1-yangyingliang@huawei.com>
In-Reply-To: <20210609135138.3192652-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 21:51:38 +0800 you wrote:
> Use the devm_platform_ioremap_resource_byname() helper instead of
> calling platform_get_resource_byname() and devm_ioremap_resource()
> separately.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/ti/cpsw-phy-sel.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: ti: cpsw-phy-sel: Use devm_platform_ioremap_resource_byname()
    https://git.kernel.org/netdev/net-next/c/ba539319cce6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


