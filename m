Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14DA4AAEEF
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 12:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiBFLKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 06:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiBFLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 06:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F5CC043182;
        Sun,  6 Feb 2022 03:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48C1AB80DAB;
        Sun,  6 Feb 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9B61C340F1;
        Sun,  6 Feb 2022 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644145809;
        bh=9DnAaA54D2U8FgFr+Le60PYyPQ5oSY9JqsZU6+t8T3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C3seOVieluEfeBtKZ7ukwLw2FiJWUxXIHSCn1mn9xF994dNMURr6vTvF5w1G3Z4zX
         ZamTPPIlqlLhmKzwQ+KeBabVfPWW1dIUYX8dAFWqoZSSf1ry2wFwmnCJ+u0G+WApH1
         VoL6wb2qhkhzZaSJ68V5qddIOO0/J5vQK0+ULa/tZHPRLkIK3cONux4LDaAFbYR8j5
         UWSLgr/WW2OSyzYJfW4Wixd6+DqBBLY2ikNZT7XJLleZJbDfWHYB0CD+Vku6fn96gs
         0E9biPAh9ZnFr9IK51OMVnwdJhnQ8Qqq47zIrBXlAwPYFh5mZ7q7AZDP500LCo5YW2
         qw4D8vbJePKxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFAEFE6D44F;
        Sun,  6 Feb 2022 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: marvell: Fix MDI-x polarity setting in
 88e1118-compatible PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164414580884.29882.11773038139519237231.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Feb 2022 11:10:08 +0000
References: <20220205214951.60371-1-Pavel.Parkhomenko@baikalelectronics.ru>
In-Reply-To: <20220205214951.60371-1-Pavel.Parkhomenko@baikalelectronics.ru>
To:     Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, ron_madrid@sbcglobal.net,
        Alexey.Malahov@baikalelectronics.ru,
        Sergey.Semin@baikalelectronics.ru, fancer.lancer@gmail.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun, 6 Feb 2022 00:49:51 +0300 you wrote:
> When setting up autonegotiation for 88E1118R and compatible PHYs,
> a software reset of PHY is issued before setting up polarity.
> This is incorrect as changes of MDI Crossover Mode bits are
> disruptive to the normal operation and must be followed by a
> software reset to take effect. Let's patch m88e1118_config_aneg()
> to fix the issue mentioned before by invoking software reset
> of the PHY just after setting up MDI-x polarity.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs
    https://git.kernel.org/netdev/net/c/aec12836e719

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


