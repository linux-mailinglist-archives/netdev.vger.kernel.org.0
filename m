Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E2A58459E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiG1SKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiG1SKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E1E11A04
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AB6761DA4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 18:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2367C433C1;
        Thu, 28 Jul 2022 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659031813;
        bh=FCjiS7S6D2Ly6lwktvoPzYb2SF1zjyOOuUklp9eqDyU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gn8PW3WY73t0Yrmofwi4FfifD5UP8lD7ubOnsbc+6B19yh/ryE+mFlFw+WO5ype/y
         sFJUgIafsamfcg82M9Q8xKlnQ2ruIL7CtLaJOHlX7OvYMRWX0a2q/u+ZQriZE5YfYH
         7PwRVy5RCMTmTUS35UQImQTdxFbFTdDffYdslHdq4QRakquJ+b9G3rLvFDSGF6VXQK
         j7sFMLC3ow70jhauvTlnbiyOU9r6WH00k6kyIehurd9uNPtKq3CwtzzDVHBq5GE5av
         5WzmBU7fzjQfz7RN1D3r1cdMETaU5auIhogxOFlqO9THCD1pi80z3a6+FiWXDDNLjq
         en+npNHLooIdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7EF9C43142;
        Thu, 28 Jul 2022 18:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: ping6: Fix memleak in ipv6_renew_options().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165903181374.2291.8213182596118662690.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 18:10:13 +0000
References: <20220728012220.46918-1-kuniyu@amazon.com>
In-Reply-To: <20220728012220.46918-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo@google.com,
        benh@amazon.com, ayudutta@amazon.com, netdev@vger.kernel.org,
        syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Jul 2022 18:22:20 -0700 you wrote:
> When we close ping6 sockets, some resources are left unfreed because
> pingv6_prot is missing sk->sk_prot->destroy().  As reported by
> syzbot [0], just three syscalls leak 96 bytes and easily cause OOM.
> 
>     struct ipv6_sr_hdr *hdr;
>     char data[24] = {0};
>     int fd;
> 
> [...]

Here is the summary with links:
  - [v2,net] net: ping6: Fix memleak in ipv6_renew_options().
    https://git.kernel.org/netdev/net/c/e27326009a3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


