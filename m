Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7C254426B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiFIEUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbiFIEUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DE3E3DD3;
        Wed,  8 Jun 2022 21:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DC7BB82C11;
        Thu,  9 Jun 2022 04:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D898C3411F;
        Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654748412;
        bh=r3IG1XGY1Z+dhXtiUA5k5GH9RuhF7LJU49zedVngv2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l6PQ9r9N9qEP2hIaQYkduiea8l18Q8e/8U4uh2CkLioPhgf8+wFpB3LGFbIA2Q7R2
         r8LFYupdV8oVphtMbLp7rMcSzTmsc2lVn4gIKscQxZe24K3z5CWVN91ILkRal5n6lY
         52pRLph7huvrG1MqFB9F+rRFoDAQ6zbx1sz2plyv6JfkYM4D5Uqz/vz8CeVf7BhyBM
         B+SaGe3SobuQLiuDAaMaMJ+yIsu7plaxq/waBrhFvgFil42LyuIfmj61b1jAsp57Ps
         InmiC1RJHkjs3MCqswsd+/mFAhl9d/FpUc4wMdpUUO/vbtxxmFLi69TRskxklmeMFa
         AdhcY077nyOUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20FA1E73803;
        Thu,  9 Jun 2022 04:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] tcp: use alloc_large_system_hash() to allocate
 table_perturb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474841213.6883.11101685875318805138.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:20:12 +0000
References: <20220607070214.94443-1-songmuchun@bytedance.com>
In-Reply-To: <20220607070214.94443-1-songmuchun@bytedance.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  7 Jun 2022 15:02:14 +0800 you wrote:
> In our server, there may be no high order (>= 6) memory since we reserve
> lots of HugeTLB pages when booting.  Then the system panic.  So use
> alloc_large_system_hash() to allocate table_perturb.
> 
> Fixes: e9261476184b ("tcp: dynamically allocate the perturb table used by source ports")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [v2] tcp: use alloc_large_system_hash() to allocate table_perturb
    https://git.kernel.org/netdev/net/c/e67b72b90b7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


