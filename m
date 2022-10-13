Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBEB5FDE75
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJMQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJMQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9271060C91
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1D8B618BC
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B425C43143;
        Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665679816;
        bh=zNDZwS5J1aWx+TDZ73w+Y3JCYDo/sx/K+r4zU78izCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4hX3y134w6/yMsOmPJDaacOXRFpUU8VOiKfs8svjqq16ToytwNxwcdIdenk9wZKY
         QLxf4unOGaBv6zIFMzkh1Ihc0m2axYGqZyqujvFQnTFb57VoAoI1v4qrezfuIn6p0g
         +5pGhfdW1MV01RC5fcXMG+C9FUpw5LrCB+xTGCZ1Rq+TImjUgihm21NL49RmVRDGeW
         dJ9s0hCFtq6XsNVgk/gTXzhRcMnLoZwy15QwwLr4h7QsCJUe1GgNWcDCE4wsWiZz3l
         WPiXGLfxzzb96+W2/F76shF/IwsZeSxcdo13HWMV07DCoi7jhSBl5uJP+UP0oE8gXs
         25hgqHNeL9aTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1057AE50D95;
        Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] tcp: Clean up kernel listener's reqsk in
 inet_twsk_purge()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166567981605.2135.16734103655927008557.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 16:50:16 +0000
References: <20221012145036.74960-1-kuniyu@amazon.com>
In-Reply-To: <20221012145036.74960-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuni1840@gmail.com, netdev@vger.kernel.org,
        syzkaller@googlegroups.com
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

On Wed, 12 Oct 2022 07:50:36 -0700 you wrote:
> Eric Dumazet reported a use-after-free related to the per-netns ehash
> series. [0]
> 
> When we create a TCP socket from userspace, the socket always holds a
> refcnt of the netns.  This guarantees that a reqsk timer is always fired
> before netns dismantle.  Each reqsk has a refcnt of its listener, so the
> listener is not freed before the reqsk, and the net is not freed before
> the listener as well.
> 
> [...]

Here is the summary with links:
  - [v1,net] tcp: Clean up kernel listener's reqsk in inet_twsk_purge()
    https://git.kernel.org/netdev/net/c/740ea3c4a0b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


