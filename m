Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846C252E1B8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344330AbiETBLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344402AbiETBKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E151356A6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0ABA61B1D
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BDD2C3411A;
        Fri, 20 May 2022 01:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653009018;
        bh=h6UG0Y2V7co36fvK5/5uZf24CnGSCaSnAskYhAcgDLU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lBGghFR8bL+46CQuQHgQMdKwGDAU6aHCRlDn4Infr6hhxOsd9CxbFf957f7pJSm8e
         zG/ZBtcHTFecL1AHPdLtsSAP9NamDItAhO0p5Ioh/L32u3LXgne0ZgqbtvMXpOnsAN
         rjMTB4Zs0CtjAWiuft8ZKTb5sJX07agBnjnBZ2Oo+dzIgF4+7CEHlFd7nP9gr8dfbO
         /BLnny/Xq/TdYMtqB8Kx9nj/TfcfL8K2/HBSO0QKVze3Iv9jTAVN3P+nnbNEJWHNRF
         XlwL0a0IJa0zHi9QaB5AP4fG6koRjDcN6HGSdZM8fh5ox1UJ3auAe8Af3+GXnYEEpA
         qm0C0CnA5C4lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02062E8DBDA;
        Fri, 20 May 2022 01:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tls: fix messing up lists when bpf enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300901800.19017.12859724239999461864.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:10:18 +0000
References: <20220518205644.2059468-1-kuba@kernel.org>
In-Reply-To: <20220518205644.2059468-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, asavkov@redhat.com, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
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

On Wed, 18 May 2022 13:56:44 -0700 you wrote:
> Artem points out that skb may try to take over the skb and
> queue it to its own list. Unlink the skb before calling out.
> 
> Fixes: b1a2c1786330 ("tls: rx: clear ctx->recv_pkt earlier")
> Reported-by: Artem Savkov <asavkov@redhat.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: tls: fix messing up lists when bpf enabled
    https://git.kernel.org/netdev/net-next/c/1c2133114d2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


