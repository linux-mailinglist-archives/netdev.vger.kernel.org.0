Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B55463BF39
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiK2Lk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbiK2LkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D97E45A17
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB347B815AE
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EC22C433D6;
        Tue, 29 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669722015;
        bh=mtORzzh0YGHDIPdVuUG145Iuo2li25/7Bwk5Jy8YkCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KQ+3kqsLV38UNg3CkF2cq/4U5SuUI59jrXzEUmXUHogKsgvX0T6Me580mtTyqiKOS
         GoJXHdbVD78IM7KNoco7MritbYinVrEM6lKNuQP/yjBeUpCzC7rBE+kE/nlwgWjGed
         UzWqh7xXYH+HGGi5J8fVx1BsZey9Dkreu8u3FTfRD8PCnailYoDdRQ5lseTkqAMVVr
         wzzGqe0Ecz07tpv7Le1mroXdl51Uk0y/CkwMOkgiAopK6Ol8fYmBWteGH+SyvBqNby
         +oeoNnol24N7TCCNPpEfj2bScxnKThXmk+LGwp5aQ18X+5ufr0MKTwO6YYYuHET3JE
         BF+WXWL8y97PA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 683B7E21EF5;
        Tue, 29 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: prestera: Fix a NULL vs IS_ERR() check in some
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166972201542.14402.36048512654202405.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 11:40:15 +0000
References: <20221125012751.23249-1-shangxiaojing@huawei.com>
In-Reply-To: <20221125012751.23249-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yevhen.orlov@plvision.eu,
        oleksandr.mazur@plvision.eu, netdev@vger.kernel.org
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

On Fri, 25 Nov 2022 09:27:51 +0800 you wrote:
> rhashtable_lookup_fast() returns NULL when failed instead of error
> pointer.
> 
> Fixes: 396b80cb5cc8 ("net: marvell: prestera: Add neighbour cache accounting")
> Fixes: 0a23ae237171 ("net: marvell: prestera: Add router nexthops ABI")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: marvell: prestera: Fix a NULL vs IS_ERR() check in some functions
    https://git.kernel.org/netdev/net/c/e493bec343fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


