Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955876595CF
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiL3Hlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiL3Hkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:40:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB821581B;
        Thu, 29 Dec 2022 23:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60A22B81B1C;
        Fri, 30 Dec 2022 07:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC68EC433A4;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386018;
        bh=WEo8xkDxa9nhMESdTFzz57LLN4ArMyHjyq+ZzlotsG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IfOmhLEN6WlOnpsWg9NOZzN+TQuvf6Zavzs+diibjgOPy5IworMTGimVWwxfoNNHM
         MvXwUiNuqvtrHZvuRNT46zbWvcXzM5i9TDOZIPPi5ZMSedIewcdhUy6+N28hsoe80/
         JSEx9fgH5SSGIlNtxKNfUda9BCTGqIk6drfOTuxpgUCoC8OuoGAtT4Pr7TcKlptgKX
         SLyhNbe4imiBokKgyKFIIK8iuh1KLsG4gdxds0s66dJ4SvdVMpWa72HTavrfc+gKII
         mgpjOrNpQ1LUXdg/xXqjHQsAvlw7PPsm4Tn5Nthre2TAg4QL6lOkLU5trxGcPk+6Hb
         gClUXAn6K9XwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86E96FE0855;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: amd-xgbe: add missed tasklet_kill
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238601854.1408.859674316998286723.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:40:18 +0000
References: <20221228081447.3400369-1-jiguang.xiao@windriver.com>
In-Reply-To: <20221228081447.3400369-1-jiguang.xiao@windriver.com>
To:     None <jiguang.xiao@windriver.com>
Cc:     thomas.lendacky@amd.com, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Prashant.Chikhalkar@windriver.com,
        zhaolong.zhang@windriver.com, Rick.Ilowite@windriver.com,
        Jiguang.Xiao@windriver.com
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

On Wed, 28 Dec 2022 16:14:47 +0800 you wrote:
> From: Jiguang Xiao <jiguang.xiao@windriver.com>
> 
> The driver does not call tasklet_kill in several places.
> Add the calls to fix it.
> 
> Fixes: 85b85c853401 (amd-xgbe: Re-issue interrupt if interrupt status
> not cleared)
> Signed-off-by: Jiguang Xiao <jiguang.xiao@windriver.com>
> 
> [...]

Here is the summary with links:
  - net: amd-xgbe: add missed tasklet_kill
    https://git.kernel.org/netdev/net/c/d530ece70f16

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


