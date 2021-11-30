Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3C9463443
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241604AbhK3Mdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241585AbhK3Mdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:33:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6493AC061746;
        Tue, 30 Nov 2021 04:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D724B819A3;
        Tue, 30 Nov 2021 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5E0EC53FCD;
        Tue, 30 Nov 2021 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638275411;
        bh=kk8PnyN7+skkAQRhU8HQiZTX2lEyNUjX2lD+10PXoRk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TVol+f6/aDfhftt/93IuD7zSnCA9iJky5yt2cYgaPlycQ+A47w05OzYUWamkT5u12
         Dm2bltZtiyGHZV8Wgx2PnzeItrij0ra7OL5j3MG3rYbSwo8yC551rdzu98yE4K17zE
         YBl+iO3f+ugmKi20NIBeNC1hVNWscM8X3XwGUdtggr3Y7UUb7FgyT7GJqbwwDufAmD
         eEoZxY/AFnI/kSQJrHAzaFljKf5Ch4juitevx++kY/oK168ZJYzdWMqQrOiZ96UVEQ
         xaFsv+y2H3AEViJRCg1DKmaBOO452W9XlbuAn4n5sb+rYWEAYx2Roz/5DahRXFKl2f
         2qYXfnJd/ksFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFF0860A7E;
        Tue, 30 Nov 2021 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: mscc-miim: Set back the optional
 resource.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827541184.1181.1713025018989110410.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:30:11 +0000
References: <20211130095745.163287-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211130095745.163287-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        colin.foster@in-advantage.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 10:57:45 +0100 you wrote:
> In the blamed commit, the second memory resource was not considered
> anymore as optional. On some platforms like sparx5 the second resource
> is optional. So add it back as optional and restore the comment that
> says so.
> 
> Fixes: a27a762828375a ("net: mdio: mscc-miim: convert to a regmap implementation")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: mscc-miim: Set back the optional resource.
    https://git.kernel.org/netdev/net-next/c/c448c898ae89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


