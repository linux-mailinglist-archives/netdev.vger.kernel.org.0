Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF4F573831
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbiGMOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiGMOAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7BC2DA9C;
        Wed, 13 Jul 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8406861D98;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2BD9C3411E;
        Wed, 13 Jul 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720814;
        bh=0PczgnRAsUni8FhdXd7dUovVQEbHB53hDhpjR6g6koA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FY6Xi7+vjU+PQ0Hj18jJFFzU+nOFduhKr/HnZ+wtwUCJqQEsaQI3fwf+T/W1BCxJI
         cj8EW+WX8lLE2cXLKdqjautuf6xRJW763HEnOxwLDvNiMFhc6u3kAUI0RuK0zhfTkZ
         Ba0MyAjQ7TRCx7XRiOG2qhkgrllJBx4FgueA1xmoVFha/weuSP7rU2SHKqh9yShyW2
         1Jmc0XzaGUu8crOKFcieyRK3h62BcgQDb92XbFv8xYMt9rMB7Sus/dv3Ri/GA33Nnk
         mJlRNUL/1YbPoXw0bpgG3XRQCfKLI5lvTAlTmHJzALc9RFAe4lsZ+h+u/Mt7mxbNzM
         FvYXdIcaJ6R1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B030DE45227;
        Wed, 13 Jul 2022 14:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix leaks in probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081471.13863.9875407606261109151.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:14 +0000
References: <Ys2IUUhvm2sfLEps@kili>
In-Reply-To: <Ys2IUUhvm2sfLEps@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, zhouyanjie@wanyeetech.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Jul 2022 17:42:25 +0300 you wrote:
> These two error paths should clean up before returning.
> 
> Fixes: 2bb4b98b60d7 ("net: stmmac: Add Ingenic SoCs MAC support.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> From static analysis, not tested.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix leaks in probe
    https://git.kernel.org/netdev/net/c/23aa6d5088e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


