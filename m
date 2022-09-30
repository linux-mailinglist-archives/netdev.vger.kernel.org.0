Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3679E5F02B2
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiI3CVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiI3CVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186FE741B
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DFD562220
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE4E1C43144;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664504467;
        bh=4SODedFXzrV2VLpkvMj3tdxrFZXLJp7dtbVivwOA/lc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ayxYGX3frBE3LP/rjgjNWZW6KF+tEOaJXbILzmZJ2OHJPPKJQ9M87n/MggOWreWXi
         PfynqWsyzV94zZ+K8SHTy8lPOWKyd3Lxue8Y5uiof9GeakRuZGzVA3U7XMBfxk1sHq
         MWevgKapQODtIAwXa3irJdMjNmweU6LlXcKk7KYI6IMEvqCjnuM5RrL3vH3w/3EkL+
         vhWHAipMAirk+xkueWgCLqA9ncvGcsuHK69QmMRl2st5ZyWeW83zSNi1R0ZMSfO3GL
         zz6zMIRlPgpV9M4IahBQyhs4XDvUenHwb5yFZ2MzQAHI+kPKq5Nh3K+l90YgEXDwCL
         H0rClib3McWJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC6CFE49FA3;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page frag
 cache
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:21:06 +0000
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
In-Reply-To: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, alexanderduyck@fb.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 28 Sep 2022 10:43:09 +0200 you wrote:
> After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> for tiny skbs") we are observing 10-20% regressions in performance
> tests with small packets. The perf trace points to high pressure on
> the slab allocator.
> 
> This change tries to improve the allocation schema for small packets
> using an idea originally suggested by Eric: a new per CPU page frag is
> introduced and used in __napi_alloc_skb to cope with small allocation
> requests.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] net: skb: introduce and use a single page frag cache
    https://git.kernel.org/netdev/net-next/c/dbae2b062824

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


