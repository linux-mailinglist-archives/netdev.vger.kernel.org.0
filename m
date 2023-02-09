Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBB1690474
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjBIKKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBIKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCACC54548
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 615DDB8204E
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 045C2C433D2;
        Thu,  9 Feb 2023 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675937417;
        bh=mCHNgSfKuoyK2U1lrj135kXcHdFsLcGdeje3m+zk7cc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Za31CWfgXFH5iZ66k4XFg2HAvLvDF54ypEDukDc/Z2UQeRWA3JyhWtyWLVyZwY7Ql
         OtiDOP3V5Hefqt6WeclhUyh5WK3KLJNntY8Fx22DVPEFHsn0KC1LYodB9GodDUqREm
         wxFGyFQZFowvV1wcfSnU7074ePpYpVjoDm1zANexC2/bnhB46blwWNGrFFRQhz5Emq
         E2UUkmfKREVho2U+SV3lMS5Rsl29MVggZbmmuTkMlR51/CteUcI6qzggxJQ6tJvOMK
         y8LMv335r5cp9r153fixs96n5v2Yv3uKJYP68Cd9e//k7dyBKvS8JRCt9Lh/3bFTi6
         Us8+5wh+HRTGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCF21E4D02F;
        Thu,  9 Feb 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: forwarding: lib: quote the sysctl values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167593741690.2432.6572437373378026206.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 10:10:16 +0000
References: <20230208032110.879205-1-liuhangbin@gmail.com>
In-Reply-To: <20230208032110.879205-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, dsahern@kernel.org,
        petrm@mellanox.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  8 Feb 2023 11:21:10 +0800 you wrote:
> When set/restore sysctl value, we should quote the value as some keys
> may have multi values, e.g. net.ipv4.ping_group_range
> 
> Fixes: f5ae57784ba8 ("selftests: forwarding: lib: Add sysctl_set(), sysctl_restore()")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] selftests: forwarding: lib: quote the sysctl values
    https://git.kernel.org/netdev/net/c/3a082086aa20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


