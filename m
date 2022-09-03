Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA4E5ABCD0
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiICEUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiICEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3460937F98;
        Fri,  2 Sep 2022 21:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AB06B82E31;
        Sat,  3 Sep 2022 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A67EC433B5;
        Sat,  3 Sep 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662178817;
        bh=bYM5yg9Ez5VYkbDGL+B+4sqkE1UITDolX2TVlpo8xXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dR0P7v+iBZtr3mpYgzSS4+Mmh/pA/TKbkkMiBx+U5JxV/u8e/cEan7h8KB6GpGTC3
         gzk5GN6fHzwIXnKqHij14UocR6zT7Bv0bKFmf9F2covpRcNVjY4WF6Re0rLW8t3wAd
         9dEg8U8KgpefJcA1BhaH7dVk8TAAai5tN6cYidXoOnzSe9cmTooZ6rOHVW+kY0RWW+
         oTEGUJXoiKQw4ZS/Oyxf8na3KuWDi9/+D6p/uitTY3nV4pl8auhoic6MO/+wbkzapp
         +FVOtewA+TRvL92+SBTlFMRNyxtUJZFQB2FIAyYeoI1Iwo1f5qe3943mYuJnb3z0K6
         f6N0YWecYjKrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DED9DC4166E;
        Sat,  3 Sep 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: remove nf_conntrack_helper sysctl and
 modparam toggles
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217881690.4142.3378968788062574533.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:20:16 +0000
References: <20220901071238.3044-2-fw@strlen.de>
In-Reply-To: <20220901071238.3044-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, pablo@netfilter.org,
        aconole@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  1 Sep 2022 09:12:35 +0200 you wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> __nf_ct_try_assign_helper() remains in place but it now requires a
> template to configure the helper.
> 
> A toggle to disable automatic helper assignment was added by:
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: remove nf_conntrack_helper sysctl and modparam toggles
    https://git.kernel.org/netdev/net/c/b118509076b3
  - [net,2/4] netfilter: br_netfilter: Drop dst references before setting.
    https://git.kernel.org/netdev/net/c/d047283a7034
  - [net,3/4] netfilter: nf_tables: clean up hook list when offload flags check fails
    https://git.kernel.org/netdev/net/c/77972a36ecc4
  - [net,4/4] netfilter: nf_conntrack_irc: Fix forged IP logic
    https://git.kernel.org/netdev/net/c/0efe125cfb99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


