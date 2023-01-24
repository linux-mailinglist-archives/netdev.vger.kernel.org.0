Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C817267969F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbjAXLaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjAXLaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670914488;
        Tue, 24 Jan 2023 03:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 669D8B8117A;
        Tue, 24 Jan 2023 11:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C1FFC433EF;
        Tue, 24 Jan 2023 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674559817;
        bh=aqhPfNSJCvE036s6Wn2GGUEN9lsdj/GZC1YsIBumS5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L1idvWTcUBmh23SXhVrnoiet6k2ooLpcjlrhNPTkw0Ae1Q4+7IZTS0x9hhFeNeGre
         doqfT2Zp4WazZNhLZJkMm89vOkVzza8z9Xu1SzeeBLwgoxcveeGcAegFQJIbpm+cds
         yK5fFekSRShMgowtuOi2XgCtR8WbFr2KrSBrA4pxwK3NCTpbCLOldWFGeUbZlTReee
         ulkWMJ6ejsWk7hakN6DnnKfBsszrQZcr/FhQ/GdE7NIyJk158yn6Kni2MXDnJyT9rv
         Nem1S/q5nX8s1ulL3NxFK9XH1S64QTk1pUy5bjtGhCJClxv0RrD05qRKcWCF7JrRVa
         izvn5QcIu1A2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF917E52508;
        Tue, 24 Jan 2023 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] netrom: Fix use-after-free of a listening socket.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167455981697.20043.16136032100144497483.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 11:30:16 +0000
References: <20230120231927.51711-1-kuniyu@amazon.com>
In-Reply-To: <20230120231927.51711-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, phind.uet@gmail.com,
        kuni1840@gmail.com, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org,
        syzbot+5fafd5cfe1fc91f6b352@syzkaller.appspotmail.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 20 Jan 2023 15:19:27 -0800 you wrote:
> syzbot reported a use-after-free in do_accept(), precisely nr_accept()
> as sk_prot_alloc() allocated the memory and sock_put() frees it. [0]
> 
> The issue could happen if the heartbeat timer is fired and
> nr_heartbeat_expiry() calls nr_destroy_socket(), where a socket
> has SOCK_DESTROY or a listening socket has SOCK_DEAD.
> 
> [...]

Here is the summary with links:
  - [v1,net] netrom: Fix use-after-free of a listening socket.
    https://git.kernel.org/netdev/net/c/409db27e3a2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


