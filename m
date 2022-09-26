Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ABF5EB199
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiIZTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiIZTuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F6C16588;
        Mon, 26 Sep 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2699612B7;
        Mon, 26 Sep 2022 19:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0573BC43470;
        Mon, 26 Sep 2022 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221814;
        bh=cLKsT6Ps6PnYo0bUP4HHJNwgjTlGzpgTDzqFNsRr8Ko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tTzL61FElOniH8+jLN8Os+s1udaBP50MgVb5KZrX8d8JVo7vnnc4MCvq9BIhESJ6k
         G4yjCAQAnv6VMkF/oaWKJW0kAoOIhzuK9TU+SBn+pV3i9uIgDHAxC/iZlBpzGQw6h1
         a67WvyaKuR3G1P/1NBFZbUfMJir09ryP/pF72fKtqnVvIxBM/TL0n8AhozfJche0FR
         fFhgPTYsq9qQTVvORZj9nrOHXOxJm6qsiik8uUeRSYfMRSNcjPCr4wpdjMW5g3ezSW
         plBxMa0L8tXIQhJrGQn8k8deBlgH45WGARb8Vbj+NLlpXeR4JqZzmsNjg0R3z2BZhO
         9BE2siSfBaH7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB3B3E21EC2;
        Mon, 26 Sep 2022 19:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sched: act_ct: fix possible refcount leak in
 tcf_ct_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422181389.25918.9402199011347037219.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 19:50:13 +0000
References: <20220923020046.8021-1-hbh25y@gmail.com>
In-Reply-To: <20220923020046.8021-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, paulb@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 10:00:46 +0800 you wrote:
> nf_ct_put need to be called to put the refcount got by tcf_ct_fill_params
> to avoid possible refcount leak when tcf_ct_flow_table_get fails.
> 
> Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sched: act_ct: fix possible refcount leak in tcf_ct_init()
    https://git.kernel.org/netdev/net/c/6e23ec0ba92d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


