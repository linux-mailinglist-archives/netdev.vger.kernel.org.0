Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB86A7219
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCARaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjCARaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C85E3B23B
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D947E6143D
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F4BEC433EF;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677691818;
        bh=4LEanB9vd5M7GoPdSEbpLNke1YUqAUi8O50RvhJ8sTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tDdEMUgvL3yb0LF2z25cxK+QirYH/VP/z0tL2qI8JWaz9CqnUunu9f9ZaMGt+7jIK
         zNp8v4HxtTDPwNtpQ29e4IgQc8Bpduu0ISFVEER83x4YwdJWipcgKZ1RQrJT+cPkOv
         jxNOgSwrubU+vodRBLyhDiNJduZ+umyMklBdYS/MD1ecixXTqQbAphlYTO5qOZ2sn3
         zXBvcLCsAP16YS5HBkTcTs/EuXE1jFFGuJI7PKsWN/EBDT9JH5Jou6kWkdqjWa6Gum
         RLmgPe1+GZdwDx8vOLhjDY7DZ8QqWQXpRhisB96/O9Tb8DaJo8RtczwES2Z+7EW2Gg
         S/NJJZituZtXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02CF6C73FE7;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: avoid skb end_offset change in
 __skb_unclone_keeptruesize()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167769181800.25108.14474966708029452239.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Mar 2023 17:30:18 +0000
References: <20230227141706.447954-1-edumazet@google.com>
In-Reply-To: <20230227141706.447954-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Feb 2023 14:17:06 +0000 you wrote:
> Once initial skb->head has been allocated from skb_small_head_cache,
> we need to make sure to use the same strategy whenever skb->head
> has to be re-allocated, as found by syzbot [1]
> 
> This means kmalloc_reserve() can not fallback from using
> skb_small_head_cache to generic (power-of-two) kmem caches.
> 
> [...]

Here is the summary with links:
  - [net] net: avoid skb end_offset change in __skb_unclone_keeptruesize()
    https://git.kernel.org/netdev/net/c/880ce5f20033

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


