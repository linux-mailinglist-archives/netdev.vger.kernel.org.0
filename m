Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE6560FD9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiF3EAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiF3EAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ADE2871C
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 308D8B8282E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9FC5C341C8;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561613;
        bh=DPc/Zep/l66oNV6+IE+3X2/pJEtNSMTyNv9nb97cxmk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f/GVQ4CqCq0+25YhwpBFsecFPUB92G1SVECAZcOnA7Fjny5JSelwiwtDydZ2q27MI
         0+peISqdY4x6YVXvcKWd0AvIU7JVuHK9ZvrV3WsbIzDekYZR8fO04mGlUeLPfu8CP+
         Y3p77Dr/nQRX3nYt2rErgGt2Hu++p85sDNQY8jkXdHddm+QhsqMyZvFt9q9l5E2405
         5SNfhQsmeBEbFK1/cvLDTfS029KqvP5GGDiS7KBi9QD5p8Rov5AtZC5tytsY2Dn9c9
         +iv2qY2712QJFo3B1nCme73WUJT/2Xw6QJKhyYpIXccdA0iwtg5ir80TMxqEDGFiP3
         2e7PyBrGh5Lkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6AD2E49BBF;
        Thu, 30 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: fix lockdep splat in in6_dump_addrs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656161367.1686.3002489656467309635.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:00:13 +0000
References: <20220628121248.858695-1-edumazet@google.com>
In-Reply-To: <20220628121248.858695-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, ap420073@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 12:12:48 +0000 you wrote:
> As reported by syzbot, we should not use rcu_dereference()
> when rcu_read_lock() is not held.
> 
> WARNING: suspicious RCU usage
> 5.19.0-rc2-syzkaller #0 Not tainted
> 
> net/ipv6/addrconf.c:5175 suspicious rcu_dereference_check() usage!
> 
> [...]

Here is the summary with links:
  - ipv6: fix lockdep splat in in6_dump_addrs()
    https://git.kernel.org/netdev/net/c/4e43e64d0f13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


