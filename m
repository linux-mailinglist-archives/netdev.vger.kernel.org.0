Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFB25AAE27
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 14:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiIBMKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiIBMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 08:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650C82BB31
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF8B0B82A71
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AB90C433D7;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662120616;
        bh=8J8KEmebcmd9bJqIS8o1uvVWF4w55AO/c5rsejpHmHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JGxEQm0t3IwV78LImqt5oSPQBgrX776slHd+ACTYSTEQHfV5TD1n3ExrNTuR2ddft
         xacjvFHfbCmRx34S6angjFqXqYj1PghghWciI/5OXXx18e6nPXo+dNSHlxHk+nDaSd
         zm2YyTefKb306vrjRpXZY5za/T4wOCIrB/GESy9CTaTj2h92+1Kppv5Fx9aOR0WR4V
         PGRatDLhV9e0gkdc9TRwDa0oNq6FGEukrpmvemz4f+eDuhGUDbA5qsKwpHgmy1HlMz
         S64x+uFv8p94XoYhJQfk7mdV1RE3PxNVgdKb6sX+eSjJu+Jbzpw7mRjUIhzq2fbhd9
         fc5yo2W/JeYtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A116E924E6;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: TX zerocopy should not sense pfmemalloc status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166212061629.16201.8132190832044730498.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 12:10:16 +0000
References: <20220831233809.242987-1-edumazet@google.com>
In-Reply-To: <20220831233809.242987-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, shakeelb@google.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 31 Aug 2022 23:38:09 +0000 you wrote:
> We got a recent syzbot report [1] showing a possible misuse
> of pfmemalloc page status in TCP zerocopy paths.
> 
> Indeed, for pages coming from user space or other layers,
> using page_is_pfmemalloc() is moot, and possibly could give
> false positives.
> 
> [...]

Here is the summary with links:
  - [net] tcp: TX zerocopy should not sense pfmemalloc status
    https://git.kernel.org/netdev/net/c/326140063946

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


