Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167005A19F0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiHYUBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243487AbiHYUA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9ED792FC;
        Thu, 25 Aug 2022 13:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A4BE61139;
        Thu, 25 Aug 2022 20:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF43CC433C1;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661457617;
        bh=+tLJwX5Ai9+aWhfeCS8gce9EP+w0aJZTEkR861h9knA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LOWYurPrwemVYt2BprImDScyxyJmEiMC98fgjI0/0XIAs+3i94I6Ads4sOysn00m6
         SI/mb7+hUdqFrHATI0HW8ir+YCOJLH5cohNTwXHfyycBF8de193drx82haVfwCRVtQ
         gNHmEsQ1jhHef6V4BQ7z05vUbiQ7fxLFWeaKIIBI9zjBl1e+vQXma/o1tyAAH5f7FK
         IJJ9Cc5IsDyJH47bN9XbPr2EC/GnHSQcM84ZGGScjL8yqzlgBHKQ07vEZTuenPKpZ1
         fJYv/liK0ESEZiNXpawCtiStwazZe4FYISojof7pqEfWpUda7vU5e2bRU5xRtA2i3g
         qyyWNo1f4UiGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B74FCC4166E;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix locking in rxrpc's sendmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145761774.4210.6304609883412894569.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 20:00:17 +0000
References: <166135894583.600315.7170979436768124075.stgit@warthog.procyon.org.uk>
In-Reply-To: <166135894583.600315.7170979436768124075.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        marc.dionne@auristor.com, yin31149@gmail.com,
        khalid.masum.92@gmail.com, dan.carpenter@oracle.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 17:35:45 +0100 you wrote:
> Fix three bugs in the rxrpc's sendmsg implementation:
> 
>  (1) rxrpc_new_client_call() should release the socket lock when returning
>      an error from rxrpc_get_call_slot().
> 
>  (2) rxrpc_wait_for_tx_window_intr() will return without the call mutex
>      held in the event that we're interrupted by a signal whilst waiting
>      for tx space on the socket or relocking the call mutex afterwards.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix locking in rxrpc's sendmsg
    https://git.kernel.org/netdev/net/c/b0f571ecd794

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


