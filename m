Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25924645307
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLGEaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLGEaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:30:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726CF56D49;
        Tue,  6 Dec 2022 20:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B898DCE1C28;
        Wed,  7 Dec 2022 04:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9583BC433C1;
        Wed,  7 Dec 2022 04:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670387416;
        bh=pqTL0pZzgLPRdKxkVgDr6i9g8saDJUctLZS8X9bUCqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Al3d8mesdzhtsBxzEyN5tv7bjkZ85f3FZdkALF7sv4b3HfcgCIk2Nk3ZouvS5+YHV
         tyCZ5/lSNKBycSsQEOikqSfbxYuArNjMEfUKQlkIPpoItWGqTZoSJ5wP4icNBVUzFB
         PPdJj2ovw5FnRJQeMhfMODQZ//dOMRb1DlXYQgWJQ0BcmoQNwEoSEEA1o953nkKWof
         uNQ24qAVSimCQII2m8kAIE0Hx13MRSQQJryDeQ50wgHItVhT8CaXJxETLXvIaVf81N
         1OQTwPMRhitW1NjYSdGfXf+l6poTYSH72/OPun/t94kal1M1v0O/tgF5qMFCvIya0M
         qFQ+kuaoq9cbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83911E4D02C;
        Wed,  7 Dec 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: properly guard irq coalesce setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038741653.14983.1402009566224601540.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:30:16 +0000
References: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221205204604.869853-1-linux@rasmusvillemoes.dk>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        gregungerer@westnet.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Dec 2022 21:46:04 +0100 you wrote:
> Prior to the Fixes: commit, the initialization code went through the
> same fec_enet_set_coalesce() function as used by ethtool, and that
> function correctly checks whether the current variant has support for
> irq coalescing.
> 
> Now that the initialization code instead calls fec_enet_itr_coal_set()
> directly, that call needs to be guarded by a check for the
> FEC_QUIRK_HAS_COALESCE bit.
> 
> [...]

Here is the summary with links:
  - net: fec: properly guard irq coalesce setup
    https://git.kernel.org/netdev/net/c/7e6303567ce3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


