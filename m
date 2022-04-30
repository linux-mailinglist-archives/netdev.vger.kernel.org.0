Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD11515D2D
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382597AbiD3NDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343716AbiD3NDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8866DFD9;
        Sat, 30 Apr 2022 06:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8493F60C11;
        Sat, 30 Apr 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDE34C385AE;
        Sat, 30 Apr 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651323611;
        bh=Wx7soVe2GwQIKmpkckBFOuN9MRuARvTlfUmWFxAYLO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tjndL9h3TDMlAZeDo0bRnqteICKLnT/uBshK5w46ZidyyIyh2ME5PzdygYsWLn3HK
         XZI+eFhMbuh0xF+YImbicnDW+2P4Wmzsc/lbvstkhRvoge6T72ha+9eWGJR+y8X+5f
         wCZhrtygS7/afvoci+jz1oBdnIc9IlPd8cZTJ/w7BV2d9JyQhXXJiFASJlY+EKsVVa
         LGfxzp5T/AdosXbN5mMJIEtFpWN7EadU9J+j8/u6yjiCYvaMMByt9Gatb6ZqNhmY1I
         ApAWTwM+ZfV64RDlxEdUXPELzonT/dcOGLKvfbUO1dOS0BCdJZYRPIvJPbbT5P/XPQ
         EeEZj2useH2wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B46C9F03841;
        Sat, 30 Apr 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/funeth: simplify the return expression of
 fun_dl_info_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132361173.2405.13440569285124454839.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 13:00:11 +0000
References: <20220429090104.3852749-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220429090104.3852749-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     dmichail@fungible.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn, zealci@zte.com.cn
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 09:01:04 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Simplify the return expression.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net/funeth: simplify the return expression of fun_dl_info_get()
    https://git.kernel.org/netdev/net-next/c/ce7deda0d5cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


