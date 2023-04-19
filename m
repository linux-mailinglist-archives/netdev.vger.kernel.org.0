Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B5D6E798B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjDSMUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjDSMUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0786A66;
        Wed, 19 Apr 2023 05:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C18A63E6C;
        Wed, 19 Apr 2023 12:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D818C433A4;
        Wed, 19 Apr 2023 12:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906819;
        bh=oRWKJqZGtXQhpEUp1SFIs9JNjZRFi/VkKFDRpIPot54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G9HLOrnoHlKZzBddrpSH3/T4EG0tEoUIZeW73Jh1gpsk8Q6p2knQsUCfplPoWWAiS
         OxawlJTEWQIqFnJ6pi6f1alCpiWOIYgwNNICd5+Et/mjGm4+B9Z4XxDrmiE0TFXgju
         OrEU1kZFGHcAEoFBKANjI2VN42isn6Jl0vDm21RNztdwJAdghxNVrrSIw2b0yr2DN6
         i5broajjxnyWbVTi6xUdYeovr2IQlmUbnBFbNZ8qqPyQKMZ3mVapUVOaw11cbqcmKo
         yDOyXJiGYtaAhZNjdviz3cWRkiIlTLMSNUzx4MwrxQnE+Upp1oAEzu1DxZ+7aAK72c
         HIM+DYrrGzXKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50C0DC395EA;
        Wed, 19 Apr 2023 12:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hamradio: drop ISA_DMA_API dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168190681932.14108.5713928630159726637.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 12:20:19 +0000
References: <20230417205103.1526375-1-arnd@kernel.org>
In-Reply-To: <20230417205103.1526375-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 22:50:55 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> It looks like the dependency got added accidentally in commit a553260618d8
> ("[PATCH] ISA DMA Kconfig fixes - part 3"). Unlike the previously removed
> dmascc driver, the scc driver never used DMA.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> [...]

Here is the summary with links:
  - hamradio: drop ISA_DMA_API dependency
    https://git.kernel.org/netdev/net/c/fcd4843a19d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


