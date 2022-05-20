Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C46252E42B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345507AbiETFAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345503AbiETFAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FF514AF55
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 22:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E52DC61D47
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48620C34116;
        Fri, 20 May 2022 05:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653022813;
        bh=ZYjiKLP3Mxj4eUGI6Iu/7hjUADnBOFTb5bkE5/o3AN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d9C1VmAsKWS6trbkSdrvGNqDAFZAz5YBh8LWm/hxfoGvVm9zuu2YpbPYnegBDpFnW
         BO0CJ1/L6d0zHdzOBXvI4pfcPipKWb9EQ5cVg6f8FJS4R2Cezdfmn1xgD8VzSs8kwL
         l+B0Uf+hTEsnFWX8mxDha8OllH1z24gqhzLXUt6TDm/5IsEfwulfKSg2uL4CY+dAiS
         uCCF2I9nDD/krGOxuI0dAN41wUU3ZURh1VX+oIZEj7w2hscENVF/JTZGKf5R60+/NY
         6/9+n9/m6EGjvOfikUx6a9V5SVJKP/UZBIVYK/clen8s5BDuwE/mISX+bD23+RKcDY
         RZRC8j/IxP4BA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BB0CF03937;
        Fri, 20 May 2022 05:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: mtk_ppe: fix up after merge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165302281317.27183.14553289694638893534.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 05:00:13 +0000
References: <20220520012555.2262461-1-kuba@kernel.org>
In-Reply-To: <20220520012555.2262461-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 18:25:55 -0700 you wrote:
> I missed this in the barrage of GCC 12 warnings. Commit cf2df74e202d
> ("net: fix dev_fill_forward_path with pppoe + bridge") changed
> the pointer into an array.
> 
> Fixes: d7e6f5836038 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] eth: mtk_ppe: fix up after merge
    https://git.kernel.org/netdev/net-next/c/16ea52c44e7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


