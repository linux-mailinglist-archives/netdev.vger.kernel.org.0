Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4C4D2EF0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiCIMVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiCIMVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:21:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D0E17582D;
        Wed,  9 Mar 2022 04:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85401B8213E;
        Wed,  9 Mar 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D187C36AE5;
        Wed,  9 Mar 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646828411;
        bh=0XEpp0FKMngNskFh6CWjMaR6cEtFFazS3Zu9FWMFrr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yx0chSj/eaoPC2hfCTW9G2AbAymR32XIPGvqchO7pJF5R+ieU5dM/kulsyOWH+37V
         M63w1SclaePNUN1Kdh2I376zjBZXZ/Kb9xkOLrnadijLyVDP4txMAYEgVWUhIVOYmU
         u0Y2oMAz5SELKxM27fmT5udU3E1wzmbGu9iwX8Xs90flvA9yzalBK23M8I7kHzRgnM
         +MTqQlejdviioAoSbPzctg+wWahhROPqD1eDlnxyQ6E+wsOX4F+cyj+PCPggvhQQtg
         WQhXphK424hos5ObDXLGkIm68PRKGT6JMR2yWUu9qntDS0Qz9a+SLPGr49maqvo0Hv
         4juoLWGrKXsZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9ECDF0383C;
        Wed,  9 Mar 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:mcf8390: Use platform_get_irq() to get the interrupt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682841095.19405.17387917087764965957.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 12:20:10 +0000
References: <20220308064309.2078172-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220308064309.2078172-1-chi.minghao@zte.com.cn>
To:     Lv Ruyi <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
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
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Mar 2022 06:43:09 +0000 you wrote:
> From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> 
> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
> for requesting IRQ's resources any more, as they can be not ready yet in
> case of DT-booting.
> 
> platform_get_irq() instead is a recommended way for getting IRQ even if
> it was not retrieved earlier.
> 
> [...]

Here is the summary with links:
  - net:mcf8390: Use platform_get_irq() to get the interrupt
    https://git.kernel.org/netdev/net/c/2a760554dcba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


