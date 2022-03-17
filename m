Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CBF4DC72D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiCQNCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiCQNCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:02:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3A320C2E6;
        Thu, 17 Mar 2022 06:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF202B81DA1;
        Thu, 17 Mar 2022 13:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 817B2C340EF;
        Thu, 17 Mar 2022 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647522010;
        bh=yV5Jc/gBBDkmafjLLLBbIHDho+86bn0+HPLxHDuESuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i7kCys/S82opt7twEnwe3E5pOF1Eu0Iu/wGbHYWM4Rr0HCwmCtmIBQZsp6ivfDP4x
         YdCv6GjKp28OwXTIgzfEQT7Rw4z7YxKKIqkblSiYziORuUaK+mtAu7cS5r8i3q1CM3
         lAOXygUkfoLgn2cUEVbDFRQHFyiPS7Axgi2//Ahre7Oy1IORBycxrQnLXMw5q4JboO
         g9PCvscoFF2mbJiYUSGE5OU3KllCctiFc+oYKguyjWwtYJJdmR7Qocjcm61kcKzCUa
         ZFfjOHHoKZuVB3kMZD0U2DJj0kGyPo61cMBLU80naZrjp2qwiLMnHbgeAb8XQL/SYh
         LsMoLeSxTgnrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A76DE6D3DD;
        Thu, 17 Mar 2022 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: clean up impossible condition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164752201035.1459.5576780774534521056.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 13:00:10 +0000
References: <20220316083744.GB30941@kili>
In-Reply-To: <20220316083744.GB30941@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     peppe.cavallaro@st.com, boon.leong.ong@intel.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 16 Mar 2022 11:37:44 +0300 you wrote:
> This code works but it has a static checker warning:
> 
>     drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1687 init_dma_rx_desc_rings()
>     warn: always true condition '(queue >= 0) => (0-u32max >= 0)'
> 
> Obviously, it makes no sense to check if an unsigned int is >= 0.  What
> prevents this code from being a forever loop is that later there is a
> separate check for if (queue == 0).
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: clean up impossible condition
    https://git.kernel.org/netdev/net-next/c/58e06d05d43a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


