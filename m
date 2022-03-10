Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64844D5329
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbiCJUlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242722AbiCJUlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:41:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F939114FD8;
        Thu, 10 Mar 2022 12:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B04B82826;
        Thu, 10 Mar 2022 20:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80881C340F6;
        Thu, 10 Mar 2022 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646944810;
        bh=xfQHbaoAF4u120SR34Z2qmU9uJDYA+SUEIKK3v/gzJE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lb50j1+o7sXrB+NeKgElauthiFC4bludZEsp3py2IKT7ZT548ldd9+/Ivx0WR4WaO
         kuGX9a2YkjLUJ871xnQ+SPo8NlCUPtVCOic3FWG1v/qnqGBCkG7QQD9IZs7hVRoKyN
         J1nkMAJsMkvEZLJwJad9h7tUepm1gQeb/rwcKo30pWaEIHJzgaL+Fkyjpl1iiH2igD
         VuccnOSUplfy4yJf95sPWRswxK43027yU0ojFyIFf7zZVHCOj1ZAwClRm5r/J/oxry
         0d2eMFxwWd/LMIW6a7/DEYlD3UU5E8hSd+eSJ3aYfPoxuYzqZ0l50Dyd/Qzr1P5AfX
         3JobI4rFi9n9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65857E6D3DE;
        Thu, 10 Mar 2022 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: DP83822: clear MISR2 register to disable interrupts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164694481041.30429.9732806133242833339.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 20:40:10 +0000
References: <20220309142228.761153-1-clement.leger@bootlin.com>
In-Reply-To: <20220309142228.761153-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        afd@ti.com, dmurphy@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        miquel.raynal@bootlin.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 15:22:28 +0100 you wrote:
> MISR1 was cleared twice but the original author intention was probably
> to clear MISR1 & MISR2 to completely disable interrupts. Fix it to
> clear MISR2.
> 
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> 
> [...]

Here is the summary with links:
  - net: phy: DP83822: clear MISR2 register to disable interrupts
    https://git.kernel.org/netdev/net/c/37c9d66c9556

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


