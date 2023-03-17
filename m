Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7EB6BE21A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCQHuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCQHuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4969D769DD
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C02E6B82478
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 652E8C433A4;
        Fri, 17 Mar 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679039419;
        bh=SELkzVtM2EpV2d68ACxHhnnBQRFkZZBER101B8RaPw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YHw+aOdH+B3WJpVLKkKIBt0ZYLWCqTI+EzGmEP61L04Rv/dNGe7ldxsJpDyqF5FCV
         p6u5DIdo+XE0rqGJo5tCDT1Hfc2mgCY29FB+u+x5OsDo4/VOvPre1LndVaIzLPf7nm
         lAvTxRrTitA2JpufbwPYi3zN4hHbObNtzrdpw34afhR0hd4q5QE6UyH6XI5z3plHgk
         sy+sD6O8sRwqOx+fndg0Hd7tenACHSImWzsmzKSbwkwGMaOJmbUL8XF75Mx2LsfPaJ
         BT8Bxp3f5CToI04KwsMza+qLcAydSlyxxJHwcFdMGj0G7CP+dujdUbk7QGi6RF40rt
         dOphXowCouoFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FD75E66CBF;
        Fri, 17 Mar 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] net: dsa: realtek: rtl8365mb: add change_mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167903941932.23387.12802929985808093804.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 07:50:19 +0000
References: <20230315034921.30984-1-luizluca@gmail.com>
In-Reply-To: <20230315034921.30984-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com, alexanderduyck@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 00:49:22 -0300 you wrote:
> The rtl8365mb was using a fixed MTU size of 1536, which was probably
> inspired by the rtl8366rb's initial frame size. However, unlike that
> family, the rtl8365mb family can specify the max frame size in bytes,
> rather than in fixed steps.
> 
> DSA calls change_mtu for the CPU port once the max MTU value among the
> ports changes. As the max frame size is defined globally, the switch
> is configured only when the call affects the CPU port.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] net: dsa: realtek: rtl8365mb: add change_mtu
    https://git.kernel.org/netdev/net-next/c/c36a77c33db3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


