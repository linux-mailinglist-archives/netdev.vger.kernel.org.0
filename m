Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3877C6B375D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCJHaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCJHaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E904EDB4F;
        Thu,  9 Mar 2023 23:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5EA6B821D1;
        Fri, 10 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BE2CC433EF;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433419;
        bh=FhOcMwU0lMsnpzxGsWrWmb1yCZmPIsj4bsi+rOTc0mU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jYSyBn8vHIv1VlTAa7uvVu7MOgUj2vtxsjXcsr760HJpRQ7wOh6x3iP9r2+otl+Gy
         S1FkijrnlRpzD2h9xodtTIGXeIH+2jvCSjmO6IKkrc4E4qrv4nWNBf6I4KyBLlRBgf
         03PNc7EecWNLu4YheFPnd4Dhk+IDG+VVGxQjCRv9VLGRi6A62JTqzzikgT/7TcAhj5
         qiih+RIFu0mGc8fwT+vq9+DeRGuPSRiGsHK7ll2ZpkQ7WinEK7uZjzyL8W7wn8U+JC
         R5H5DToCHiKL/XBQp1BxmaCJDomBWJIW9t+b7kemKe/fa4LBw2SGwZlpiHHPRgJDhp
         d0Rq43JK556Xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59F54E61B66;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: ethernet: ti: am65-cpsw: Convert to
 devm_of_phy_optional_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843341936.20837.15710287655317793865.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:30:19 +0000
References: <01605ea233ff7fc09bb0ea34fc8126af73db83f9.1678280599.git.geert+renesas@glider.be>
In-Reply-To: <01605ea233ff7fc09bb0ea34fc8126af73db83f9.1678280599.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, s-vadapalli@ti.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 14:04:52 +0100 you wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
> v3:
>   - Add Reviewed-by,
> 
> [...]

Here is the summary with links:
  - [v3] net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
    https://git.kernel.org/netdev/net-next/c/b3a8df9f27c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


