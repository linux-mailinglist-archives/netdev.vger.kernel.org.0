Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36506F137F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345517AbjD1Iue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345271AbjD1Iua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2107C10C6
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C72D64211
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC4A5C4339B;
        Fri, 28 Apr 2023 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682671820;
        bh=apweGcKxWQdr1zieES+V76DV4bZR0QcCt+hx0PxpDG8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X3Op0U9QT4qmA1l9d96Ok9aGWYHw5skcHS5n+kf9yPdo2wiudXr+qwYazx55++OnK
         C92z5wYWQMP/X87pFs71ly3Nvj+lKit74gpRRg7MTHFdyJkQr4GY8oFN5iPWnJO2YC
         ZDa6W0pWcKBu8tqEreREuppTewF75DU560l6AvqBQRkTYtlsSxCbZ6dq8HzfwGEjIj
         /mqQx9qhtV8OcAbJzKsyoD1Zt9daaThwZL6NIUAhdsTEc8heJUdWQrgqvxQE4LKfU8
         WLJnGNagfmZQpUxdoaRgS3wFgOqUnJ6uI1RX6ATAMCJ1TWCSAHpwY4pakp6JcaHjDx
         H5O4ddk6NmcqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE9BEC43158;
        Fri, 28 Apr 2023 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] tcp: fix skb_copy_ubufs() vs BIG TCP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267181984.3488.15879400692691350248.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 08:50:19 +0000
References: <20230428043231.501494-1-edumazet@google.com>
In-Reply-To: <20230428043231.501494-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, dsahern@kernel.org,
        lucien.xin@gmail.com, willemb@google.com, lixiaoyan@google.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Apr 2023 04:32:31 +0000 you wrote:
> David Ahern reported crashes in skb_copy_ubufs() caused by TCP tx zerocopy
> using hugepages, and skb length bigger than ~68 KB.
> 
> skb_copy_ubufs() assumed it could copy all payload using up to
> MAX_SKB_FRAGS order-0 pages.
> 
> This assumption broke when BIG TCP was able to put up to 512 KB per skb.
> 
> [...]

Here is the summary with links:
  - [v2,net] tcp: fix skb_copy_ubufs() vs BIG TCP
    https://git.kernel.org/netdev/net/c/7e692df39336

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


