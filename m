Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36494471186
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 05:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345945AbhLKEnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 23:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbhLKEns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 23:43:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FB6C061714;
        Fri, 10 Dec 2021 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31D18B82AC1;
        Sat, 11 Dec 2021 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA3D0C341CD;
        Sat, 11 Dec 2021 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639197609;
        bh=DWR0/w5CaP/I49QmUT2Z3vXOQxE2TD1Ff7XsrjySqz8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X9D1/VjtSwrZBOUa4sd7w2IE+RrTLOH+aMuK1lIbXtbuYiQaaJLovVyQoz3gc5rGh
         86+pyPiOzP10zNeMyVfcqh7W5eyEkryattgpDZDz8rM7A5SyKIqRxdyrrRU0f64BA8
         WHhA83BYkYsjVnvS/7fXF8nXGP/fTIc9Nd8HVyh0BS+JiUlWclEhSXxdUFlllmbuHd
         z9inCxnCH+myWFKSUOuU/re+4ZTFyIqNqx2Sr+V3n6h38+AV6dJJDYAus4R/6LJBGi
         HMA+gE7iivJCwDLqVkxHajL4Soyg9zXMFOT44ADSR4dNr8gXLPy0eg/u+HOwqmtb4H
         d3YMCQKJp0FhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C48D160A36;
        Sat, 11 Dec 2021 04:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ocelot: fix missed include in the
 vsc7514_regs.h file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163919760979.24757.10249852929237407652.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 04:40:09 +0000
References: <20211209074010.1813010-1-colin.foster@in-advantage.com>
In-Reply-To: <20211209074010.1813010-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 23:40:10 -0800 you wrote:
> commit 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a
> separate file") left out an include for <soc/mscc/ocelot_vcap.h>. It was
> missed because the only consumer was ocelot_vsc7514.h, which already
> included ocelot_vcap.
> 
> Fixes: 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a separate file")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ocelot: fix missed include in the vsc7514_regs.h file
    https://git.kernel.org/netdev/net-next/c/840ece19e9f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


