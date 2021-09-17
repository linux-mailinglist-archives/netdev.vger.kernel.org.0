Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED20740F926
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbhIQNbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236153AbhIQNba (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:31:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CA55611C3;
        Fri, 17 Sep 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631885408;
        bh=jiyppn0XPjKTJk/ezB2pcJ20LVqGEZsfAQ8ZF1OrUhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kCPpJha5lzp/0nKQG99dt+j0TmRexSPCJWp555kjaOFbnVx+H8kO3KiLKg2i0ka9u
         bAOf7AklINKOjUuy/8NhyE+rXAFSeEyM0vyp5qkFSUneDOJKbQ0pkoUjPmtNq12H/k
         xH7MXvfvElJF7TyXIK/pb8ncu5TfetfDabovWNXV8v382czEKzQX1I+tJSiGMFugEB
         zNDHC3zkS0F65gqKaZuE/Bf7XBUL1F8xzmm4KJUBbGbknAYv2LKRK0X2WAUCA60Tpx
         uLtztwVvysO3/vs+XUusXlImRziBcSyoGZDoN1zlBQeH/7xIbkkQXpTUQH2e6DFjva
         SXHVELvl8kV6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3CFB60726;
        Fri, 17 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: microchip: encx24j600: drop unneeded MODULE_ALIAS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188540799.4005.10704744935830447493.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:30:07 +0000
References: <20210916170508.137820-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210916170508.137820-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 19:05:08 +0200 you wrote:
> The MODULE_DEVICE_TABLE already creates proper alias for spi driver.
> Having another MODULE_ALIAS causes the alias to be duplicated.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/net/ethernet/microchip/encx24j600.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: microchip: encx24j600: drop unneeded MODULE_ALIAS
    https://git.kernel.org/netdev/net-next/c/5ef8a0291513

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


