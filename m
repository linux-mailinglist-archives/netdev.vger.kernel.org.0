Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5018550268
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384022AbiFRDUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383831AbiFRDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A1D49F88;
        Fri, 17 Jun 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C4561F9D;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F4169C341C0;
        Sat, 18 Jun 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655522415;
        bh=kbU8y5C1hpk08uPoZ26rIYJ6+NBAK05VQG2DdHD8ePQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IkacHGSU2vo4W/nOWnp2kkLjIim0aoJxw/G48OGI49JB7192KL5GZT9/VuDA9YoVt
         viwqU7bi3rAIKhM24NfIg0XvH0/zB4tIMEwdNr5hGJ6G9UXI/zSaKN7SQcxBaeIC3a
         yedl+s9TRt04vO9fo3RzXP48Mwp/UUzpWyrZ+T3EDd9cEyc35nJgHPEau5LXiv33pM
         it8lLxh42RZTHstHoqO0J2HkloxIdIThRPO3g/kyJUKR3ZQ18QzMLSSI1/KpO/tZa8
         CMIkOkFAdy2jExjCPWmts8eBL98uIzLQ8emiSNpNS7MfS7vJxGKkaxiqQv7toz/43f
         Cs0KmWYz9KLmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDFB9E73856;
        Sat, 18 Jun 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: dsa: ar9331: fix potential dead lock on
 mdio access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552241490.3144.11636115583195482482.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:20:14 +0000
References: <20220616112550.877118-1-o.rempel@pengutronix.de>
In-Reply-To: <20220616112550.877118-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 13:25:50 +0200 you wrote:
> Rework MDIO locking to avoid potential  circular locking:
> 
>  WARNING: possible circular locking dependency detected
>  5.19.0-rc1-ar9331-00017-g3ab364c7c48c #5 Not tainted
>  ------------------------------------------------------
>  kworker/u2:4/68 is trying to acquire lock:
>  81f3c83c (ar9331:1005:(&ar9331_mdio_regmap_config)->lock){+.+.}-{4:4}, at: regmap_write+0x50/0x8c
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: dsa: ar9331: fix potential dead lock on mdio access
    https://git.kernel.org/netdev/net-next/c/7a49f2193063

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


