Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267725499EE
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiFMR0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiFMRZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:25:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FA727FF4
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF941B80D5F
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 12:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65EB6C341C0;
        Mon, 13 Jun 2022 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655124013;
        bh=nVLrhCXWbNuUKcAnGRhsFtytrA0zzi3sD11GVmzeByg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Swufy4kuoAKQnDg3HkJsowaF18bk2CCuDDQIpsxfNL0EHbY4ZA6zgGd1movEOPcYM
         2oYAGTxhGbyXS1E2njv8L6ZN679d68JSS76lA0mFA1Lv3yZ3EvyCBZ4xZDwe3jBIUj
         kbWKMwE0uFpHu0P1lief4H9hb/MeGnMsCbJ2AZvagTHOlJ4wmIUZ2/hC2rL25merWi
         8u5mzlA5je+IeFa5mxCl1VJCPxxp7AxJFy4RTFpLkbUe0hLkXg8M/rXpopU8LXMbyj
         D/y8rX8twN9Dn6k0bVQNpcDK2bxqMUUjxG5AhkYnfj8G/DC7ldk44VSoLze3mSvOaw
         UlhZJW9eCioyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AD21E736B8;
        Mon, 13 Jun 2022 12:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: sk_forced_mem_schedule() optimization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165512401330.9046.15384552224463511218.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 12:40:13 +0000
References: <20220611033016.3697610-1-eric.dumazet@gmail.com>
In-Reply-To: <20220611033016.3697610-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, soheil@google.com, weiwan@google.com,
        shakeelb@google.com, ncardwell@google.com, edumazet@google.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 10 Jun 2022 20:30:16 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sk_memory_allocated_add() has three callers, and returns
> to them @memory_allocated.
> 
> sk_forced_mem_schedule() is one of them, and ignores
> the returned value.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: sk_forced_mem_schedule() optimization
    https://git.kernel.org/netdev/net-next/c/219160be496f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


