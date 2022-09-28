Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75FE5ED20C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiI1Aa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiI1AaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A58F112FCA;
        Tue, 27 Sep 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB38D61CCB;
        Wed, 28 Sep 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1231AC433C1;
        Wed, 28 Sep 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664325015;
        bh=Ctfu79cjyl7XhDno0CcHF0G/Jwk0+MIz5Kq5ikCqY9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhxtPe3dHBYMO7olb9QwkwkAeQ7FviLxDdiu8yLz0WHaC3Gw6eFvMr0NDuLYMNAVk
         ZKVy8E01Nv4vTRfCNUvlTVVSi8Qys9qIwRJhAnrOZ6SJPien2b0WNopoG3nCmC74UG
         cZPP9CuFnM6rRbEAU4n9lJ2q8lSG7ZKKjfZMtW4LpoIorZNTkLmH6GM5YRbbgwNU2U
         TF19V4N6Ots0QE06VV1+w389lDtFJ5cJP3byDKBRCusQCT0F3C0JYiRULuqH+UpeuX
         qd6NimSTf5TxefZD24piNcqRzbKbv1SSX6xQAfOn8MjbXLvWI25O3ENZ7uLCudMXlV
         FE4w5Mn3B1EBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E772EE21EC6;
        Wed, 28 Sep 2022 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: Minor spell fix related to
 'stmmac_clk_csr_set()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166432501494.19774.3663768296307691962.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 00:30:14 +0000
References: <20220924104514.1666947-1-bhupesh.sharma@linaro.org>
In-Reply-To: <20220924104514.1666947-1-bhupesh.sharma@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, biao.huang@mediatek.com,
        davem@davemloft.net
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 24 Sep 2022 16:15:14 +0530 you wrote:
> Minor spell fix related to 'stmmac_clk_csr_set()' inside a
> comment used in the 'stmmac_probe_config_dt()' function.
> 
> Cc: Biao Huang <biao.huang@mediatek.com>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: Minor spell fix related to 'stmmac_clk_csr_set()'
    https://git.kernel.org/netdev/net-next/c/c64655f32fef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


