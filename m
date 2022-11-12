Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B504626742
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiKLGA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 01:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiKLGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 01:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740CA12AD7
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 22:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07F3860BBC
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AE31C43146;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668232818;
        bh=rBcgH/pNhv0f/gdePb5gMlSjsIemJHV4pNodNO8bivI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ElAXxPufoIsqtTQf6aAkLOoTJOYBnhRus306VfBIDZlxKVfz7MGKnyuczw6VgnlFA
         tSdwTdQv2AsSWISpbgALFJ2ed9RNkdizBhYWH08hxWqLMHzpS6LAWqZNu7/rif8Rsi
         8zwU1kDZ7qizeDbQSuWrC2PGjnb1dlLgnyBXgNiFQABHNv+pw1sCyBBqn5CoFgv2F1
         YfhvEijgY6v14U9upUt/e/P68CTFurln75+sTHPU6IrmYeUtZtoSz/un1TNNVsDohG
         KPGRz8rRpsI8MWnjcV3S9Pxd/2/PO2mqranSabDorOJJOVu/Me1lyIREL4NVOUY7t9
         siyIxtKr8hE5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A1E4E524C5;
        Sat, 12 Nov 2022 06:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: adopt try_cmpxchg() in tcp_release_cb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166823281816.10181.16054904831907656534.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 06:00:18 +0000
References: <20221110174829.3403442-1-edumazet@google.com>
In-Reply-To: <20221110174829.3403442-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 17:48:29 +0000 you wrote:
> try_cmpxchg() is slighly more efficient (at least on x86),
> and smp_load_acquire(&sk->sk_tsq_flags) could avoid a KCSAN report.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/tcp_output.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] tcp: adopt try_cmpxchg() in tcp_release_cb()
    https://git.kernel.org/netdev/net-next/c/fac30731b9b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


