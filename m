Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4C652F696
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiEUAKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243537AbiEUAKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:10:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8191A8E14
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEDB461E3C
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B06BC34113;
        Sat, 21 May 2022 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653091811;
        bh=OKg24GpLaUfKvgtJigMuHhrOIZXamizRQ1I7TcDf/aY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TZMLXglUGS2ZxyrsZtyCiX9RhpX1akZeQE4wkM/w4TPAJsJ0tyL4cYCP3VYQReKzp
         m/gWL6lNDdBB9Xsy9hDK195HT5qzCKm5OXU/Y2VGJaNAyfumjKIfR7kEZRoOuuuewJ
         bWuqoWDPlMvipCBh8U1M5joI50AFKYBtkFVY+6DFoiLnGW/GljR57L+HLd55YLBXoK
         P/rZpEF8uafuQuxEvCXSqy2tO1HaY2Qt+KYxQv7+p6bOSOGcha/ZMcyFn03HBvOtjq
         ynGxc7gbnPlXbD7ro74L/xzoJPRYJ5zlS9N48AGaLz3vkJxhC/loi7nzMcqSP1OD1V
         2svCXkNwqj3gQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 234C2F03935;
        Sat, 21 May 2022 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix out-of-bounds access in a selftest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309181114.12839.13478379720115891907.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:10:11 +0000
References: <20220519004305.2109708-1-kuba@kernel.org>
In-Reply-To: <20220519004305.2109708-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 17:43:05 -0700 you wrote:
> GCC 12 points out that struct tc_action is smaller than
> struct tcf_action:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c: In function ‘stmmac_test_rxp’:
> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:1132:21: warning: array subscript ‘struct tcf_gact[0]’ is partly outside array bounds of ‘unsigned char[272]’ [-Warray-bounds]
>  1132 |                 gact->tcf_action = TC_ACT_SHOT;
>       |                     ^~
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix out-of-bounds access in a selftest
    https://git.kernel.org/netdev/net/c/fe5c5fc145ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


