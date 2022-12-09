Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4F664813D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLILAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiLILAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2294AF02;
        Fri,  9 Dec 2022 03:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 326C962214;
        Fri,  9 Dec 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85AE0C43396;
        Fri,  9 Dec 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670583616;
        bh=xXp4vuwLpI3suBHgkpV6zyB4TnbNjjd4Hbez3ogTUeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SMW+qweFRU2X/gItu/RVykA3rQJgkEM5jRqxrmHxo2yDql18FK4oljy7EcwkYprl/
         dpLqVfJNaxfYOqnB05cMXeueLkKF/4Q5HFKaM7INO2GXiDtq8nCPZg24E8dSeS21Ts
         D4l6/MxPL8sg7cLd4hjamqqHQJAmeinGSItrDOnqEdSDhGDId1IaTGsys2jgwySiwm
         kZS8RuW3poj6mvUqcuO4ohMJW2sAt6PgZgH8EYSWoYFQFEtj5sVXx1s3SwbwzMzds4
         RviAdXWO4cC2vazEt1aBSIRqX7aoNq2b9dIDM1ZhIDsmQB3vGQNBTSKohI9rICR8p1
         HiqwuD+P2j/cA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E22FC00442;
        Fri,  9 Dec 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: selftests: fix potential memleak in
 stmmac_test_arpoffload()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167058361644.21061.2842147258255089605.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 11:00:16 +0000
References: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 7 Dec 2022 16:31:59 +0800 you wrote:
> The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
> some error handling case, which will lead to a memory leak. Fix this up
> by adding kfree_skb() to release skb.
> 
> Compile tested only.
> 
> Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()
    https://git.kernel.org/netdev/net/c/f150b63f3fa5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


