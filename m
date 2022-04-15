Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1058750282A
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352240AbiDOKXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352285AbiDOKWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD59BB090;
        Fri, 15 Apr 2022 03:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6660B82DF0;
        Fri, 15 Apr 2022 10:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ED6EC385A9;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018014;
        bh=l2KznDaCtzmx1/xgHYyx6zS/0bXDVgbRWJyNftfqi2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W/2mqORsjBpfW3MXFBys8jg5717nbr4KP4f8pQ42Uu94qwVPhOgcQvChYXVd263CY
         5SIqv3ZCBW5n6R4zwDm2SFCC+3/801Uk9MrXm38Zs1PyYT9TaJLD1t7gZiFY6xQow4
         mAPuNE/LzlFmXmkB0TnUtRhYJsc2gaRt/xBr/XFgOtipMcMehHIHX3sV96eYQjIC98
         m1ihrfqkpUPG9cO1v0m86dpQZbe7m1wyqFh/Yt9JrKZxCCJfXqfg0ngVdvMprC3eUo
         jvxeQ5XD5pjgAU4dNRz/sFkwWPYt2PsNMCNzap+26oQDoNekt1wTDGEJTgsuT4S4O+
         JAqz4eyJ+evbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 534E3EAC09C;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpsw_priv: using pm_runtime_resume_and_get
 instead of pm_runtime_get_sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801433.12692.8817498230724778911.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:14 +0000
References: <20220413093836.2538690-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220413093836.2538690-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, toke@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn, zealci@zte.com.cn
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 09:38:36 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpsw_priv: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/be52d266d293

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


