Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDE06749AB
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjATDAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjATDAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:00:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE799EE3F;
        Thu, 19 Jan 2023 19:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8D7ECE2679;
        Fri, 20 Jan 2023 03:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D304FC433EF;
        Fri, 20 Jan 2023 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674183618;
        bh=CPgv1ExYPIpJ2e5oDRHTCWWl38lPtzCf4xU/njqKe3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fFEx47dUuOxTM3cHwUiZLM3mu/BkbOgwYq72orJPFY7VYPkVZ/MBJjFpOjP9jS9Jx
         D+cDS8oKWnSKoIlmBq29RKDKqcekW/rUjAtQjIpT2k5RhHlsj5kWsZo/bpBftyaYhx
         qA5uQiDRh/+VD9pKt8pnJ1dSUwvt87SULvldIVtxvkcw3PH9Yksrs4lygl+MQcxsjm
         5DbsCNRjrQ6g+rPkP1VXdxm7hEaZ1msyJ27M+etsdq/ECDC6Rcpi/ujr+vtXDbP9EV
         Tvmt7IVJGSI3tEG9wNyTbPmHWmYyehgTvqcH55e0MPMZExH09venreQdIkxSpBLaGn
         fizCoZYHOGDwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC499C32795;
        Fri, 20 Jan 2023 03:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: Handle -EPROBE_DEFER
 for Serdes PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167418361870.28289.12896248727436083767.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 03:00:18 +0000
References: <20230118112136.213061-1-s-vadapalli@ti.com>
In-Reply-To: <20230118112136.213061-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        geert@linux-m68k.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Jan 2023 16:51:36 +0530 you wrote:
> In the am65_cpsw_init_serdes_phy() function, the error handling for the
> call to the devm_of_phy_get() function misses the case where the return
> value of devm_of_phy_get() is ERR_PTR(-EPROBE_DEFER). Proceeding without
> handling this case will result in a crash when the "phy" pointer with
> this value is dereferenced by phy_init() in am65_cpsw_enable_phy().
> 
> Fix this by adding appropriate error handling code.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY
    https://git.kernel.org/netdev/net-next/c/854617f52ab4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


