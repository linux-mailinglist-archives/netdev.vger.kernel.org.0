Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5453155127E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 10:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiFTIUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 04:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiFTIUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 04:20:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B3711C1B
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 01:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 605E1B80EFD
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08108C341C7;
        Mon, 20 Jun 2022 08:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655713228;
        bh=rvS//YnlorwhiXD/fNFc6HRjl/InsHmuyPFJRAkdIHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mJKZwu1c2MR3DQhcYeI6oJkq4X8XZrL8rodb7AtzaWNHi6q3K/hXjZ2EplX0cMtzk
         yYSKOlu3+8+sc15ml6SKBaR7h3Ge+pRZ6i+Uk7Z+s8Q2+vp/yerWL/J6kvKBQw6v3g
         mTaIpoGFy8irlQ1FWitv+Q2dLbNuln0vRvNOu9d92G38ukKIUInI/8V4y7nikCbQX8
         YxigLsKQkGzNZnRMyaH5A8H6UGI+ETaeuTMjsFdUYTPwc8NshQBLHvhp49y+UDCpLQ
         R9t3qc5VCFexoxA2BjPIIFSfvuMshQmb8479X8Vo3spRZzxlt7G2ptdqH3LJFnExrc
         o5Ed28912uwEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E49D2E73875;
        Mon, 20 Jun 2022 08:20:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 0/2] raw: Fix nits of RCU conversion series.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165571322792.28545.587082097048401953.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 08:20:27 +0000
References: <20220619232927.54259-1-kuniyu@amazon.com>
In-Reply-To: <20220619232927.54259-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Jun 2022 16:29:25 -0700 you wrote:
> The first patch fixes a build error by commit ba44f8182ec2 ("raw: use
> more conventional iterators"), but it does not land in the net tree,
> so this series is targeted to net-next.  The second patch replaces some
> hlist functions with sk's helper macros.
> 
> 
> Kuniyuki Iwashima (2):
>   raw: Fix mixed declarations error in raw_icmp_error().
>   raw: Use helpers for the hlist_nulls variant.
> 
> [...]

Here is the summary with links:
  - [v1,net-next,1/2] raw: Fix mixed declarations error in raw_icmp_error().
    https://git.kernel.org/netdev/net-next/c/5da39e31b1b0
  - [v1,net-next,2/2] raw: Use helpers for the hlist_nulls variant.
    https://git.kernel.org/netdev/net-next/c/f289c02bf41b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


