Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62027536CB9
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355871AbiE1LuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 07:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355855AbiE1LuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 07:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0955310544
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 04:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9403DB826FC
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 11:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52036C36AE7;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738612;
        bh=Y3N+L9jfXQx2qWsgWLO/XpE0XKgeoFhKtvq6/orq6ek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uQBPC4z+lPLjd5eA2gFKcC0dQr2EKc3qF58Dd3zxXd0aiSS2ISER65I+RDzyYCG/Y
         0u5n541KckWOeJ/CIiTHW34vGkN2KqhY7IiEMxo2wZa6OOo+HpxuLf7Ber5lLdfkao
         B+9fdidjPObFgClA0rw9lbv1asGecpNDi9wmmGtl7XnrG/nmPLgeckp+eIa7QHkTEH
         9yrik6irw9IQDRyNzX242TEiOA9WzP78V5yXf6R/BuM2wPMFk7CpoS6kK3HHqLYEdr
         sH+etVOqIYNaPcp8FkeWWgpHA5iJqTIAb+HCsm3gYhcYDyoIzYEM3aXgVWN3S1sGVF
         Z8CZSt29//ccQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3AB69F0394E;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165373861223.5820.6939519573639996122.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 11:50:12 +0000
References: <20220527212829.3325039-1-eric.dumazet@gmail.com>
In-Reply-To: <20220527212829.3325039-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ncardwell@google.com, ycheng@google.com,
        edumazet@google.com, syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 14:28:29 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot got a new report [1] finally pointing to a very old bug,
> added in initial support for MTU probing.
> 
> tcp_mtu_probe() has checks about starting an MTU probe if
> tcp_snd_cwnd(tp) >= 11.
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
    https://git.kernel.org/netdev/net/c/11825765291a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


