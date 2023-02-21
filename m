Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E269D79D
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjBUAkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjBUAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0091A66E
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B4F8B80E5E
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C0ACC4339B;
        Tue, 21 Feb 2023 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940017;
        bh=WuacwXTZc0CYAGyUs/ZO60b5InfqSEAE576wwATTvLI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i1Rz/DDyOO675QWikaFSO6rMxuRNJuYGIDkE32LkptqloynPszNta2OGXN0224bvF
         ItqGm+y0xn769stWi7AT7JTY+azzgMwO6eODE3smwjW2vNsIUt+QcUPjPAT+0Z76Ue
         /LOalcDzW9k0MLNpgBw+d/mmbUDVz8ZJ1rpyQ4fzxP6P4h3hFHizkjCqYFkN1z6pMw
         ZgpUcwReB0IusUVgP36V8c7uK2fx4RdjOVz4P/SD/xvAQtfVK6HItDUjCxxF2N1MBT
         KP6Mfng2iGgyDLw+xaIIeziSVg9djST0EwPh/hJQeLuQNzf8YF4dWcsH0nilV4GXcg
         PbMy+VkngZZIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E508BE68D20;
        Tue, 21 Feb 2023 00:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next] net/ulp: Remove redundant ->clone() test in
 inet_clone_ulp().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694001693.5796.8423204307653383031.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:40:16 +0000
References: <20230217200920.85306-1-kuniyu@amazon.com>
In-Reply-To: <20230217200920.85306-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Feb 2023 12:09:20 -0800 you wrote:
> Commit 2c02d41d71f9 ("net/ulp: prevent ULP without clone op from entering
> the LISTEN status") guarantees that all ULP listeners have clone() op, so
> we no longer need to test it in inet_clone_ulp().
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/inet_connection_sock.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [v1,net-next] net/ulp: Remove redundant ->clone() test in inet_clone_ulp().
    https://git.kernel.org/netdev/net-next/c/be9832c2e9cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


