Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7D669CA04
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjBTLk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjBTLkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:40:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7343C1A971;
        Mon, 20 Feb 2023 03:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 266E8B80CA9;
        Mon, 20 Feb 2023 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2DDAC4339C;
        Mon, 20 Feb 2023 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676893217;
        bh=Lbb4c8rYY1G8NRQh1PcXwMvj2xT33stSAPklW6txzCU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LEBnrqHSP6VJXbo7V/8PVWma8JCaX8hQYwPw+DVn5iEte5R33WO4/4nNtDo/pFL25
         sBsj+A6LOYMQVsniRfRAObzQzjKoxQm1TcU9m/b0PwrboJdy/GS1TvMFdk13mAzfqK
         KoJPjpXQXuJqjdmRq9HKNHOoOdbl3sC2LAq38qAVgAB2RgTrJdzx9BxAOtcDgC3nW8
         5LGt3+qADruStY62hrzEhVarbmfWppDgyvF67BR8QJPO8oou0y3SQB/arVhzzkzZDH
         L3YggAbq0FDv4ousnb3FKfXpH1KFPZ6ODaL7a+WOxBhgSZwOTIlqlF+JLZ2BcJCOXw
         24Ocf3kG84HwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B70A6C59A4C;
        Mon, 20 Feb 2023 11:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: lan966x: Use automatic selection of VCAP
 rule actionset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689321773.10349.12898754055808130035.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 11:40:17 +0000
References: <20230217132831.2508465-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230217132831.2508465-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, larysa.zaremba@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 14:28:31 +0100 you wrote:
> Since commit 81e164c4aec5 ("net: microchip: sparx5: Add automatic
> selection of VCAP rule actionset") the VCAP API has the capability to
> select automatically the actionset based on the actions that are attached
> to the rule. So it is not needed anymore to hardcode the actionset in the
> driver, therefore it is OK to remove this.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: lan966x: Use automatic selection of VCAP rule actionset
    https://git.kernel.org/netdev/net-next/c/4d3e050b5488

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


