Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBEA6DDCD0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjDKNuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjDKNuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:50:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B675588
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56E4A626D5
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B491FC4339B;
        Tue, 11 Apr 2023 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681221017;
        bh=xDCrDo1fUGCday6OrnqRA3TpoQnx9D1K7CBdn5hWJMo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tfQPK42Cwj1DsIJvIWTi+wKaYhNmrh5kwwqeC/9Wy3eArEIb+rZEmqtaN68kAtcsC
         8H7F4AVSTtNIaUd7x1u4IUwmkTFyqvlLD4u/X7gHWlMrSE6QNAZW/si2u/vHxNP6m4
         QcEYNTGQhH6iA7gJnG/MdPbp89dg2kaYLRuSbyZyaAfmfbjkcSBFhyvujoetAUBVKQ
         JicM01Jix80wJSNVRitRNv0Fv1UqPrNw7iRkJIHgvZ9DHBJP6zFwBw2zXjJS/ir0A9
         pNyzKZbBlogXqhF52CFlQ14bEEc8fMKDBoscsJIQZp0uc4ejlCwmRX61nL1JWPz310
         g+LgM0O/YgzwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BC96E52444;
        Tue, 11 Apr 2023 13:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: Unify duplicate GQ min pkt desc size constants
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168122101763.24369.1757947056571027740.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 13:50:17 +0000
References: <20230407184830.309398-1-shailend@google.com>
In-Reply-To: <20230407184830.309398-1-shailend@google.com>
To:     Shailend Chand <shailend@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  7 Apr 2023 11:48:30 -0700 you wrote:
> The two constants accomplish the same thing.
> 
> Signed-off-by: Shailend Chand <shailend@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h    | 2 --
>  drivers/net/ethernet/google/gve/gve_tx.c | 4 ++--
>  2 files changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] gve: Unify duplicate GQ min pkt desc size constants
    https://git.kernel.org/netdev/net-next/c/4de00f0acc72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


