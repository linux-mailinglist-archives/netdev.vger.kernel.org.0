Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A87653DCF
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiLVKAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 05:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiLVKAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 05:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B0422B3E
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 02:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12E01B81D15
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A88BDC433F0;
        Thu, 22 Dec 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671703216;
        bh=nGoo+AY3sS/GPozscP2niyappZZiZBtXJX5hesDq5WI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B3pC16ncfsdj4mCK4yv4DF+psFIP3PO8/yy2WzkFnXXLExz99iB8E44KzTZJEJi32
         RaykK4obpVjQkcYr7nbvK9oION0hWYItP1UGjUHfJIrU7BtDfbfYdzOI3mUw3OVuB8
         zNhqVOIxoperJftYXPjtH7WE99NfiEqr3nrpE98hUdP4ib80bSAyOpz9mHxblSw0g3
         2c5mdBramqt8JARZ4SvRfPh284KKUVuz/yPBvLqyDuLhlJVB/opov9vseHefyquJ+w
         LReW7RdTpT3BzQhESuKbLOZwGCYpXcfsXObXs2OGnC+XvAAm8fcJfGaTZ8aaU2AfcX
         x+jKILkFldPpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D2EAC5C7C4;
        Thu, 22 Dec 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: fix lockdep splat in bond_miimon_commit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167170321657.16848.18389604222248206257.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 10:00:16 +0000
References: <20221220130831.1480888-1-edumazet@google.com>
In-Reply-To: <20221220130831.1480888-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, liuhangbin@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
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

On Tue, 20 Dec 2022 13:08:31 +0000 you wrote:
> bond_miimon_commit() is run while RTNL is held, not RCU.
> 
> WARNING: suspicious RCU usage
> 6.1.0-syzkaller-09671-g89529367293c #0 Not tainted
> -----------------------------
> drivers/net/bonding/bond_main.c:2704 suspicious rcu_dereference_check() usage!
> 
> [...]

Here is the summary with links:
  - [net] bonding: fix lockdep splat in bond_miimon_commit()
    https://git.kernel.org/netdev/net/c/42c7ded0eeac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


