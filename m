Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3788C4C9958
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbiCAXa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiCAXaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9F85E77B;
        Tue,  1 Mar 2022 15:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E67A3614C4;
        Tue,  1 Mar 2022 23:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40724C340F1;
        Tue,  1 Mar 2022 23:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646177412;
        bh=Nk9jdq+V5/7aJfn04TEEkO508Hs8UlxP6etnQSUs/ck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=plQIQ9YFS4wXeMLlZCB5gkuTEj532P6ZzldXIFQ6c5p9QwybSLx8+CrK+ctIEcL2a
         rXUIfl9TzdLwfiEzDV9EXXJRMelKmC0iCn+o+TJIh9JhoF3TyzRkZpmYv3oR41qfGp
         1NzX2czx1ZSuNf61Hi7VKzbHyr5WqvCokMhhweLj9GHXXLjp9G9e+6tJRDIDED0RGn
         MfJsKIHxVMf9tXfKomU5n3qxbIesngdH3PQZnHoz3PczZShtovN4DT/IQ6Rz0cDVia
         8FtT93CZRoQxMigRS+IhvdMOxQ5qPO8PXWY4CMTp24BCYAadAm8/OEpzBpFdAmunpu
         +rpGDrG7+Ls4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 242FAE6D4BB;
        Tue,  1 Mar 2022 23:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: nf_tables: prefer kfree_rcu(ptr,
 rcu) variant
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164617741214.25603.717853332136466469.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Mar 2022 23:30:12 +0000
References: <20220301215337.378405-2-pablo@netfilter.org>
In-Reply-To: <20220301215337.378405-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue,  1 Mar 2022 22:53:30 +0100 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While kfree_rcu(ptr) _is_ supported, it has some limitations.
> 
> Given that 99.99% of kfree_rcu() users [1] use the legacy
> two parameters variant, and @catchall objects do have an rcu head,
> simply use it.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
    https://git.kernel.org/netdev/net/c/ae089831ff28
  - [net,2/8] netfilter: fix use-after-free in __nf_register_net_hook()
    https://git.kernel.org/netdev/net/c/56763f12b0f0
  - [net,3/8] netfilter: egress: silence egress hook lockdep splats
    https://git.kernel.org/netdev/net/c/17a8f31bba7b
  - [net,4/8] netfilter: nf_queue: don't assume sk is full socket
    https://git.kernel.org/netdev/net/c/747670fd9a2d
  - [net,5/8] selftests: netfilter: add nfqueue TCP_NEW_SYN_RECV socket race test
    https://git.kernel.org/netdev/net/c/2e78855d311c
  - [net,6/8] netfilter: nf_queue: fix possible use-after-free
    https://git.kernel.org/netdev/net/c/c3873070247d
  - [net,7/8] netfilter: nf_queue: handle socket prefetch
    https://git.kernel.org/netdev/net/c/3b836da4081f
  - [net,8/8] net/sched: act_ct: Fix flow table lookup failure with no originating ifindex
    https://git.kernel.org/netdev/net/c/db6140e5e35a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


