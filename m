Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED951E247
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444379AbiEFWyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240959AbiEFWx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:53:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA4F659F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 654E3B839F4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 22:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C987C385AE;
        Fri,  6 May 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651877411;
        bh=AnWrmMl2npC8einUywlq9atFIQnuFhvgukV57/cFciI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o1yBIAxevQiws9O6ZCrT5g789q2sq8D+djo0HJF2xxO48lg5mW+GDYlQm6SX1p9Gl
         T83LTyj2odsq+m0vdoO8kWmBuHEEmyBktC36Dpy4ahRHgKL6nMYWPiwneMAFdeCwNK
         0jJiGXj2T7D53qgoDA1W03/LN6H2SJDTMw/MxjdGFuKDbVD4ZX5KyVSvLrHhNxnhaX
         TLQJSHmiCzMAftxHuPbfxj/OJTXuzggKX02TiMy8wyqB8+gWZCGwn6J2hLha0o2jId
         QW066de37NmS23qQsRzX/NlJlsBPUvZSrh2MbVdQwF+0WzcP21t94jXYE4JeIdAi5K
         8b/4OktilRvbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0068CF03876;
        Fri,  6 May 2022 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: do not reset transport header in
 netlink_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165187741099.22211.15604002427684519312.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 22:50:10 +0000
References: <20220505161946.2867638-1-eric.dumazet@gmail.com>
In-Reply-To: <20220505161946.2867638-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  5 May 2022 09:19:46 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> netlink_recvmsg() does not need to change transport header.
> 
> If transport header was needed, it should have been reset
> by the producer (netlink_dump()), not the consumer(s).
> 
> [...]

Here is the summary with links:
  - [net] netlink: do not reset transport header in netlink_recvmsg()
    https://git.kernel.org/netdev/net/c/d5076fe4049c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


