Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885B96206C6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiKHCaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiKHCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805C512764;
        Mon,  7 Nov 2022 18:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B01261408;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67EF6C433D6;
        Tue,  8 Nov 2022 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874615;
        bh=5I+qLxelnQc9+Dt74i8eiuYnf2LdJcrJJ/xyAfkjn/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZA3usmLJIE7MlCzNHZVFIopAjXSBjrZnDEPC750gTKxzJ/AKtufvXzvZmB2mrrCdz
         LczcxYDreWgWBX7UkzXduhL+c7hpFC22tw3e/j9C9z4OjSLQMQhfaqsyIcENUoVLGP
         s9oIblgEbcRVYA6swbQ0xUwmALlSF07wIBGFB+T3HjLYKcuPPk9StRTe3bhDCqvPUC
         UzjkWwhQUcE+mnd9qFisiBbHtU/oWYAyAyadIRH0C53zIozRa1hp57IhSxQIQynJdO
         5wtOeuydVAKLKvEA6spx1ySu4htzmQbTL7ht6bJ71FSUw5lSbrll/tjCKJr8usMWQ6
         UhBA4kpq3rRwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C777C4166D;
        Tue,  8 Nov 2022 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: Fix BCMGENET Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787461531.16737.17622797697029750600.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:30:15 +0000
References: <20221105090245.8508-1-yuehaibing@huawei.com>
In-Reply-To: <20221105090245.8508-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Sat, 5 Nov 2022 17:02:45 +0800 you wrote:
> While BCMGENET select BROADCOM_PHY as y, but PTP_1588_CLOCK_OPTIONAL is m,
> kconfig warning and build errors:
> 
> WARNING: unmet direct dependencies detected for BROADCOM_PHY
>   Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
>   Selected by [y]:
>   - BCMGENET [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && HAS_IOMEM [=y] && ARCH_BCM2835 [=y]
> 
> [...]

Here is the summary with links:
  - net: broadcom: Fix BCMGENET Kconfig
    https://git.kernel.org/netdev/net/c/8d820bc9d12b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


