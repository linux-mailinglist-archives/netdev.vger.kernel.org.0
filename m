Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5D15570EA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 04:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbiFWCKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 22:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377803AbiFWCKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 22:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC0D220F3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 19:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EE71B821AD
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA67AC3411B;
        Thu, 23 Jun 2022 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655950213;
        bh=BHWVdcALkvJZfpJ2NE8MVXe7B7DeXB/fdhZwwjvESpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pSzv4uULLbsSrfBhDRDBL1DKFdMpA5tuyiaLFf0TA9Jq+ME0ZQWUBY5/zO/mc5eyk
         rCOtPxsWBq/5uNQmQm7OiZNpFBgDYLV4MBijlcwJADXkzeig3LbmMKr8sKOOEPNDHt
         cS48jP5VCfaP6PirRQDixPXcgeRysHIyh+K8zNAGvpqFsAtZk+wL7Hni3pN2NGWBmv
         JP7wJDbU4upbHbU21Pl2QEw9CAwCUvy7oKsMz1v2R5CmBRBhF3fbTZEN4ExF0DhY5G
         1nh68if0HMxvaHQGYI1EZzUqFh90V65QGslIxAfLVxV8lw2xXjOJzJJyHvjCpNL9Bk
         3sNJKmpTwHMeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE845E7386C;
        Thu, 23 Jun 2022 02:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] raw: remove unused variables from raw6_icmp_error()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165595021284.7185.7098753707223716064.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 02:10:12 +0000
References: <20220622032303.159394-1-edumazet@google.com>
In-Reply-To: <20220622032303.159394-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, lkp@intel.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 03:23:03 +0000 you wrote:
> saddr and daddr are set but not used.
> 
> Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/raw.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next] raw: remove unused variables from raw6_icmp_error()
    https://git.kernel.org/netdev/net-next/c/c4fceb46add6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


