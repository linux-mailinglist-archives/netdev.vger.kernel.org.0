Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D504566719
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiGEJwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiGEJvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F3710FD3
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF41161909
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23BD9C341CD;
        Tue,  5 Jul 2022 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657014613;
        bh=k61uqolNxIjeK79iWs8CIegjVDS0PkU2oGRQI7f/I6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CA8QmbccCRa/s/vXGyZkiH41cRFp70sYf9UUcO8ZUgZDkZInPI3IoFduwVexu806R
         BlJxTyLHavB2mQxXdYlA/B14NS89W7E/FgW4NzFP6xXYEcopGcvFYgrTZ3bRmWjmAo
         w/H3CA+c1x9E0Zce4p/nLE83QcjtoeYtXNc2Ex1GLvyt2LaPd5dr03qF1oLPjnBgAp
         9UY2fYTAncsiX2/plJiijFxfqUJQUH6s6MQOTeRTr7pdliWwUKgz8ClJHCdsf4POTb
         qcgHqTnhnwV+6r5Hh8wkJNhrLlszRp2p8IC2yXcBkTZTvsldMGVLaqSjNv0XkqI0rF
         Zvdr7uUbTRO3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B5CAE45BD8;
        Tue,  5 Jul 2022 09:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] af_unix: Fix regression by the per-netns hash
 table series.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701461304.24093.2789797407907036384.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 09:50:13 +0000
References: <20220702154818.66761-1-kuniyu@amazon.com>
In-Reply-To: <20220702154818.66761-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sachinp@linux.ibm.com, cdleonard@gmail.com,
        nathan@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 2 Jul 2022 08:48:16 -0700 you wrote:
> The series 6dd4142fb5a9 ("Merge branch 'af_unix-per-netns-socket-hash'")
> replaced a global hash table with per-netns tables, which caused regression
> reported in the links below. [0][1]
> 
> When a pathname socket is visible, any socket with the same type has to be
> able to connect to it even in different netns.  The series puts all sockets
> into each namespace's hash table, making it impossible to look up a visible
> socket in different netns.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] af_unix: Put pathname sockets in the global hash table.
    https://git.kernel.org/netdev/net-next/c/51bae889fe11
  - [v3,net-next,2/2] selftests: net: af_unix: Test connect() with different netns.
    https://git.kernel.org/netdev/net-next/c/e95ab1d85289

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


