Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EEF6F137C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbjD1Iu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjD1Iu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08157E59
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8898964206
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E332FC4339E;
        Fri, 28 Apr 2023 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682671819;
        bh=9Dyk4nwkn0ZhMxIaLgZp0WF2Llws/sH54SP3L+/VHSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZZ384Fy76az3oq1bLcGoydcZkwPq8j82htrMbffq/7+Jznk3N7L234OujWgTBDq/J
         myEPlbuCIJrP2E0+SbZ3xr1Q0Oqwf5Qu+PzgOZn7uUvp8FdNvqQi7Q63+dj4bxHgiN
         UuH7Fu3XJvOfDpXJQMhwe6ZaD7v9l3G5LG3feyu0ikh0Btwkav4Sql3g/KoU1F0knE
         BEkesY83KdXewQ7Kq2g8qRxsEwEEk8U1It07EC9Vusi+ViwaaaYa0O/iXXfqjtXqQA
         L4JBuu94IU0P4ZnUM9dH8GuoxUtbzks0yP235g9H1ePYWbmvSwsN+o0Iojo63VyHes
         74W4akOLQXKQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5487E5FFC5;
        Fri, 28 Apr 2023 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2] sit: update dev->needed_headroom in
 ipip6_tunnel_bind_dev()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267181980.3488.332133565847617634.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 08:50:19 +0000
References: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        oswalpalash@gmail.com, kuniyu@amazon.com, edumazet@google.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

On Wed, 26 Apr 2023 23:00:06 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When a tunnel device is bound with the underlying device, its
> dev->needed_headroom needs to be updated properly. IPv4 tunnels
> already do the same in ip_tunnel_bind_dev(). Otherwise we may
> not have enough header room for skb, especially after commit
> b17f709a2401 ("gue: TX support for using remote checksum offload option").
> 
> [...]

Here is the summary with links:
  - [net,v2] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
    https://git.kernel.org/netdev/net/c/c88f8d5cd95f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


