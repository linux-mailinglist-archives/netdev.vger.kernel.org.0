Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6D76ED99F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjDYBKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbjDYBKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5A13C0D
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 572346256A
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB716C433EF;
        Tue, 25 Apr 2023 01:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385018;
        bh=2sZQw/28GbdS/QgcT+Pi9sghugopq2JhZHIuNEk0F/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sv4ukKeB1BCRNjYqT0cYTYFmrWraCuZy1ePfGBTwA4sz7eIiuPSwNH3PgMnU2j66U
         GA3vzbSo1OxemXG2t/op8ENJ4GcwEYjp1tMMdTe5+73+02hYogidnfVthrklq1WEMm
         yKIN+XUS/Y2CXettMupZJqVY+DmmD8dw4bKQEEig4WUW4j9pW7cAOlTLkVCSLuhNxC
         Bv8udGT0v8v33EAwCTzQ4ugMR3E2iDFwOzxdkHITZ39GI5d3MKIByK8oJCqXbwIUBL
         DH2yEszdC9mV8O6GsYmm7EjkjlkSMPW5g4eq5ArgMiYWLQQTmrit56qZR3bOP6xHfh
         OFuHi19TFcIwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8AE7DE5FFC9;
        Tue, 25 Apr 2023 01:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238501856.6495.11277937193414735695.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:10:18 +0000
References: <20230421185255.94606-1-kuniyu@amazon.com>
In-Reply-To: <20230421185255.94606-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kaber@trash.net, pablo@netfilter.org,
        christophe-h.ricard@st.com, johannes.berg@intel.com,
        dsahern@gmail.com, kuni1840@gmail.com, netdev@vger.kernel.org,
        bspencer@blackberry.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Apr 2023 11:52:55 -0700 you wrote:
> Brad Spencer provided a detailed report [0] that when calling getsockopt()
> for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> options require at least sizeof(int) as length.
> 
> The options return a flag value that fits into 1 byte, but such behaviour
> confuses users who do not initialise the variable before calling
> getsockopt() and do not strictly check the returned value as char.
> 
> [...]

Here is the summary with links:
  - [v3,net] netlink: Use copy_to_user() for optval in netlink_getsockopt().
    https://git.kernel.org/netdev/net/c/d913d32cc270

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


