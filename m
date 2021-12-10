Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD5C46F991
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhLJDXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbhLJDXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 22:23:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2234C061746;
        Thu,  9 Dec 2021 19:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62F21CE29D5;
        Fri, 10 Dec 2021 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CEC8C341CF;
        Fri, 10 Dec 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639106409;
        bh=V0QKUzINx8qii/ezZq2kh25nmOEY6X0Pvd4MdMt+8J8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pKeIkMYfW6TSwIuNSiyxyK9aJPt+8s5Uh4wQbv+/fFibNjTM/eYdD9SaJtMv2YFEM
         KPq/sAcYqqOSDCxQwDMRj7ur+hcHhFe/PG+ZiYbAueHC482TLwHZA27gFMjhxJYOiv
         7OmAZnWHBXek2kO6V/tGkPPJzC1ouKKTf/96AD5+rgxfFFtkMBO/bxs4xpoGYqwagB
         YSSjGlJp2USa2JxaMH+nNlEpB271NCitjFB+zohOQ67GuDQbjuj317nxx0xGsZQf74
         IzgGphWv1EU/4RjZDKxyGj9xBCd1/LcHZw3zg17T9ZUiw7hqBtkPPh0Md3/tWR+yv2
         w2IyOYkiIq0Bg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4994260A2F;
        Fri, 10 Dec 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sh_eth: Use dev_err_probe() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163910640929.13476.4555588694323530518.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 03:20:09 +0000
References: <2576cc15bdbb5be636640f491bcc087a334e2c02.1638959463.git.geert+renesas@glider.be>
In-Reply-To: <2576cc15bdbb5be636640f491bcc087a334e2c02.1638959463.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 11:32:07 +0100 you wrote:
> Use the dev_err_probe() helper, instead of open-coding the same
> operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - sh_eth: Use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/e5d75fc20b92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


