Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E970C4BA7CF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbiBQSK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:10:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiBQSK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53717186E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EE1061A00
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97CAFC340EB;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645121411;
        bh=5NfTFW4b/qQ8nGzqoAxhdV9YirzpSk1mq3eOH0w/9pE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j0xKmCAVisSKjyehgR2+cf3EHh/PgfHCiB+s6lDqbaCLsMExqkYrBS/I8kuJm/GXn
         OY1Eo/A+JiKYlPzhjgd3ojKALJHQ1vAtId5JAZXZWACicz65d1wdZe5O40DKJmdkBJ
         1cnPrLMGqG1t6w0JOLtw+1yEV2abxFXl7/fN2FdtM8xvIpC87JxKRV9rSJsC6NtIir
         ZLOFp/qih1m32vQFzuxrJD4l9/KKw+k1VNgMHgYUgGDANL1k5B+gK/Gzb9CFDbFyDJ
         QupF1UwbJpaR8zDqCgngK7Z/g5R37zLp+s2eNG9XCFZJVWJnQwADflnJFIhhduirv/
         H4IV3k/CO3VPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84203E7BB08;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] ipv4: fix data races in fib_alias_hw_flags_set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164512141153.19163.18168888895219925303.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 18:10:11 +0000
References: <20220216173217.3792411-1-eric.dumazet@gmail.com>
In-Reply-To: <20220216173217.3792411-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, idosch@nvidia.com, syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 09:32:16 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> fib_alias_hw_flags_set() can be used by concurrent threads,
> and is only RCU protected.
> 
> We need to annotate accesses to following fields of struct fib_alias:
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv4: fix data races in fib_alias_hw_flags_set
    https://git.kernel.org/netdev/net/c/9fcf986cc4bc
  - [net,2/2] ipv6: fix data-race in fib6_info_hw_flags_set / fib6_purge_rt
    https://git.kernel.org/netdev/net/c/d95d6320ba7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


