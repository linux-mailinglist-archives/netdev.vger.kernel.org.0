Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046036D7239
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbjDECA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjDECAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9373ABC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 19:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06D8463AD8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3ACEDC433EF;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680660019;
        bh=LsoVzAzLfEBYp1Q2GxjDeQmgGjGX+pWyKpEp/RT0bko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jw4rtnfiQxjcEH+uYWRGW8sxuodM0XAHiOviALXwwSbiq8LaUMfAy1noL4Gh9IuOn
         bDsmlH507CZ5gi+IfHjKdL56XEUp8HWXcSUxw4K2Vt69vUBoJUuDNo9DXNPisZrBJo
         3J7FmqDChUoefUMq+081wKo866jT+BoN4psDadDppSKPZyRiccPf+mWOJ1VQ3+MkK4
         /P+oSx8GFzAKCsetGrhw2RSUB3ZwQOAds/4ECb4A38zXRCPeP3Sti6nWU0SpfLDAGy
         lGOpJ2NMhiFFv9Vf8ofXgFVi/t7VsKyNRdEnjYhTGdE7E1EHsSPuU0p0BL8c/Xmf/Y
         jEczLPa2gxoJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11790E524E4;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: annotate lockless accesses to
 nlk->max_recvmsg_len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066001906.10193.14861063393618891502.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:00:19 +0000
References: <20230403214643.768555-1-edumazet@google.com>
In-Reply-To: <20230403214643.768555-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  3 Apr 2023 21:46:43 +0000 you wrote:
> syzbot reported a data-race in data-race in netlink_recvmsg() [1]
> 
> Indeed, netlink_recvmsg() can be run concurrently,
> and netlink_dump() also needs protection.
> 
> [1]
> BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg
> 
> [...]

Here is the summary with links:
  - [net] netlink: annotate lockless accesses to nlk->max_recvmsg_len
    https://git.kernel.org/netdev/net/c/a1865f2e7d10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


