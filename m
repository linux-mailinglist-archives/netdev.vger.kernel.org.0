Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643995BF8F0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiIUIUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiIUIUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:20:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1024D4663F;
        Wed, 21 Sep 2022 01:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAC02B82E9E;
        Wed, 21 Sep 2022 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 582DAC433C1;
        Wed, 21 Sep 2022 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663748415;
        bh=KFB6KZHo+snfmSgIigxaeJd7ZPBwW6DhtfmLlftQfqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RT7otP1+oACGvYrf9tyeg1zNyeOEMc634K9swO5pE6aMPVRM1PN64039AppwvaOpK
         TnLIrhENvzpagZGYg23xmGO2H9i7TGY+tPkuMDY3HUsmppsUt/6bwn2rrbFNEp/DdG
         zHoYF8PswIcjxQ8XvG2vYgqVFJHNX2kC1zcoxLPrchvmgZfvA8/NjMyZXJ4KKGwF6p
         wgc5O08XXq0M9w+H/GQt2iyVHzqlP45t5Joo52cdp8Gmw0Snoj7jLhZl3tGgIkw6ra
         MtSru+tmSLI6bHD6PQi7GSNwwyX47mHyHMaJr5jkIF7TctjEogGJq4CUUcnYq3mbX7
         m/7AWA61qKqOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3831FE5250A;
        Wed, 21 Sep 2022 08:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: conntrack: remove nf_conntrack_helper
 documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166374841522.10980.7211411640375714208.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 08:20:15 +0000
References: <20220921073825.4658-2-fw@strlen.de>
In-Reply-To: <20220921073825.4658-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, pablo@netfilter.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Florian Westphal <fw@strlen.de>:

On Wed, 21 Sep 2022 09:38:21 +0200 you wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This toggle has been already remove by b118509076b3 ("netfilter: remove
> nf_conntrack_helper sysctl and modparam toggles").
> 
> Remove the documentation entry for this toggle too.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: conntrack: remove nf_conntrack_helper documentation
    https://git.kernel.org/netdev/net/c/76b907ee00c4
  - [net,2/5] netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
    https://git.kernel.org/netdev/net/c/921ebde3c0d2
  - [net,3/5] netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()
    https://git.kernel.org/netdev/net/c/9a4d6dd554b8
  - [net,4/5] netfilter: ebtables: fix memory leak when blob is malformed
    https://git.kernel.org/netdev/net/c/62ce44c4fff9
  - [net,5/5] netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed
    https://git.kernel.org/netdev/net/c/d25088932227

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


