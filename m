Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0B463E8FB
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 05:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLAEud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 23:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLAEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 23:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2081C9950F;
        Wed, 30 Nov 2022 20:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29158B81DEE;
        Thu,  1 Dec 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D021AC433D7;
        Thu,  1 Dec 2022 04:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669870215;
        bh=sJFIlgZaORisP1BinGOZXuz9JkboagVSLtOeWTmRkQw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nUqyFmwuHyr2ocUjBtFA6Pd1HwzFISVrnO47La00M35Hq5YQFUXzA16CQolrad++s
         6x5l5ZgeczPHUpNb9G69feMlB0Xh4ediDaNahSbBC+lJpZBghgx36FROVGBF1NUo1w
         DrMoWZ9KV8G+m6eNyFc30o3f8WSCWcWPH/vQo1D7zIYpbWb11A0nvNuutBMIxX8/w9
         cEGBjtelheB5p06PWakj3zD8ILtuVfKbpUyykNO+5rgzSoAyuFafx/L3q0Vu/E+Wt6
         bHcdT/FCvBq57SKgTcO9mkWQJMj/lrU76+6dkB9CclxN54Ejy0tW8fInkyXMDam8hO
         diUO3SuVA1NhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B38E5E21EF7;
        Thu,  1 Dec 2022 04:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for
 BCMGENET under ARCH_BCM2835
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987021573.2850.16613320394493121347.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 04:50:15 +0000
References: <20221125115003.30308-1-yuehaibing@huawei.com>
In-Reply-To: <20221125115003.30308-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@broadcom.com, arnd@arndb.de,
        naresh.kamboju@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Nov 2022 19:50:03 +0800 you wrote:
> commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
> that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
> leads to a link failure. However this may trigger a runtime failure.
> 
> Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
> of BROADCOM_PHY down to BCMGENET.
> 
> [...]

Here is the summary with links:
  - net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
    https://git.kernel.org/netdev/net/c/421f8663b3a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


