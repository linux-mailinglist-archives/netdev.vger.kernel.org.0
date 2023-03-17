Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479936BE4BE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjCQJCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjCQJCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:02:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAF1B06EB;
        Fri, 17 Mar 2023 02:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845FAB82549;
        Fri, 17 Mar 2023 09:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39B8FC4339E;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679043622;
        bh=k1oY0wIlo/WeCKrS5TMLXVF9KIRMR16tVb0ApKbj6go=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oFM0djpOBL4O8HE4pTeBPSaTGIKARAN88G+3eHyBu3MQuBPixG8VzkEl3uf0qsN29
         t9LIDA232MBv79QzGS74zyzwV9gmIAwfesE6erJW5C+jMCimYTvdZ5IMZkUc+2qPM3
         kc0cQEFgnsDiWn7C506yk3x2amNkHN9gcqPwdohPXPtqb/fnqx+ZK7a8NzbsIfhg21
         qKqDeX0RSfRvSjx1Ro5aG9fOUZDZ9nHpV/vqZ1e/25Ff02Iyx9bbWLGwW7GaIyG/sT
         McMud94UqGC06l22JACyqNsw/vLBDxqAUubcVkFt5HwjXXR7u3WfsE+Wv/++gv3oM0
         wmLYIIy8x4zQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B65EE2A03D;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] net/smc: Use percpu ref for wr tx reference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904362210.30854.17584893958310072644.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 09:00:22 +0000
References: <20230317032132.85206-1-KaiShen@linux.alibaba.com>
In-Reply-To: <20230317032132.85206-1-KaiShen@linux.alibaba.com>
To:     Kai Shen <KaiShen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 03:21:32 +0000 you wrote:
> The refcount wr_tx_refcnt may cause cache thrashing problems among
> cores and we can use percpu ref to mitigate this issue here. We
> gain some performance improvement with percpu ref here on our
> customized smc-r verion. Applying cache alignment may also mitigate
> this problem but it seem more reasonable to use percpu ref here.
> We can also replace wr_reg_refcnt with one percpu reference like
> wr_tx_refcnt.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] net/smc: Use percpu ref for wr tx reference
    https://git.kernel.org/netdev/net-next/c/79a22238b4f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


