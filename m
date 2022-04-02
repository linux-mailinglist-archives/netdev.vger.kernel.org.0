Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC244EFEB3
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 06:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349514AbiDBEmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 00:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353660AbiDBEmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 00:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658B0C9B64
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 21:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668D960AE4
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 04:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2C44C340F2;
        Sat,  2 Apr 2022 04:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648874411;
        bh=GxU8gHn8T9689B2HQ8UUi7uVaJIlQ2qVRoG364hz8cc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JTvtIVBdEUHTCm9LQxesmzLR/Q/sT+MRW4sbepYykuVIIKaxGkl2BQqMdZT4Y1GIX
         c5dEiFIPEmxHV+nxEIVkyJl/KxNQKab3c7dGW5lj5tKeIgCdEwiX/TEfWBLqja7VE9
         njrns3Hkx0RAfDZxQisw4OrPzUXkcI7L0/M1pmjhFdG5HUDg1tAJmdpxN0JX2uqY0L
         XVAxWPxO/SZd4wgo/cekNPHvifysSnzpj0RjaH/59Z5cvzJKtpooE4mN8aEBl39G5p
         x9URI0+G9lykUfx8jE29yJ8WZv96AqibrBfXpg5SxFVVrm/M6BLMxdilMX6j/3No4G
         cmhwdGHJt6sCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 787F0EAC09B;
        Sat,  2 Apr 2022 04:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/fungible: Fix reference to __udivdi3 on 32b builds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164887441148.2105.8004050941902926921.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Apr 2022 04:40:11 +0000
References: <20220401232411.313881-1-dmichail@fungible.com>
In-Reply-To: <20220401232411.313881-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  1 Apr 2022 16:24:11 -0700 you wrote:
> 32b builds with CONFIG_PHYS_ADDR_T_64BIT=y, such as i386 PAE,
> raise a linker error due to a 64b division:
> 
> ld: drivers/net/ethernet/fungible/funcore/fun_dev.o: in function
> `fun_dev_enable':
> (.text+0xe1a): undefined reference to `__udivdi3'
> 
> [...]

Here is the summary with links:
  - [net] net/fungible: Fix reference to __udivdi3 on 32b builds
    https://git.kernel.org/netdev/net/c/31ac3bcee47b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


