Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B555BEA61
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiITPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiITPkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439093F328
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D46AC624FB
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43F8CC433D6;
        Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663688416;
        bh=V95J6v6i7MGVKGvgrvW1AbwkP82EUgfeJVPG/aWcc/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lt3mWwtCs6spuLzbZp0keGHHpG7IbBuCmVxECNLx7KIgaK5l8YX68SdqAtk1RFAaB
         0oHw1IV7j8v6mUBO1ajygaKGgLGcBkjdCf+espYLz9dIzJymRyTsc6aKCe+LUI8vNS
         WHhxKeQG+uYN2a9fhMfb1OPUMzHbngrlFahCfQ/gBclQ8exXAS6NGv4tbuU6UXzICG
         uqkAl/FISchNYr+XMsDbXoru70iX1vUyPB09ANKtIeGlPqyyOTVM9Ygiq7Koz70uPN
         vsOJNPD/t/JqUIkXc69e4l3poQMPfhOzC4ouAYUBW15JLnqve29XTYyPu9CA1d4Lcd
         EWchIq/ULXFPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2332DC43141;
        Tue, 20 Sep 2022 15:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: clear msg_get_inq in __get_compat_msghdr()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368841613.10369.12677272015843838401.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:40:16 +0000
References: <d06d0f7f-696c-83b4-b2d5-70b5f2730a37@I-love.SAKURA.ne.jp>
In-Reply-To: <d06d0f7f-696c-83b4-b2d5-70b5f2730a37@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, axboe@kernel.dk, netdev@vger.kernel.org
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

On Wed, 14 Sep 2022 18:51:54 +0900 you wrote:
> syzbot is still complaining uninit-value in tcp_recvmsg(), for
> commit 1228b34c8d0ecf6d ("net: clear msg_get_inq in __sys_recvfrom() and
> __copy_msghdr_from_user()") missed that __get_compat_msghdr() is called
> instead of copy_msghdr_from_user() when MSG_CMSG_COMPAT is specified.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: 1228b34c8d0ecf6d ("net: clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()")
> 
> [...]

Here is the summary with links:
  - net: clear msg_get_inq in __get_compat_msghdr()
    https://git.kernel.org/netdev/net/c/d547c1b717fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


