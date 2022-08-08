Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B13D58C50D
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 10:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiHHIuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 04:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiHHIuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 04:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2D6103E;
        Mon,  8 Aug 2022 01:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 036A9B80B2B;
        Mon,  8 Aug 2022 08:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 747FFC433D7;
        Mon,  8 Aug 2022 08:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659948613;
        bh=vTtW7Jpsz7mxLP/cz0pwqd+V3tCzbGxdXCK1pCfio8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IHN2ifkmz3TRcRUmmp6YgRvs7IN3B7lTD07ayr6TR74migWXXf84gFKEXt2Ha91tI
         aB39o+XpeonJLzedfagRV0doTLxEc1kijTFQa1rLfZt74YST8eOrN4Nj5B3dyBHhl3
         Qs42DQrnBeQ5MtA+Mr2IywBBtpE8OihhMU6qmJ7JR70gRs60jjktpDaD4U51hsk69F
         ecNNtGIYz77A4+miHCA8JxzMfz7jp+zVMr0qnaI2/rVQCHaPKCRkkG6Glg8+UV+Cq0
         NiHLyx/dtPwaRsRap/5uxhiLQgbMfd24RPrIBDqn09bwc0PN+wWSXOlMl6kwKY7s5M
         QeA4cxj8cvxAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5523AC43140;
        Mon,  8 Aug 2022 08:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] virtio_net: fix memory leak inside XPD_TX with mergeable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165994861334.797.7508341498448348184.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Aug 2022 08:50:13 +0000
References: <20220804063248.104523-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220804063248.104523-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 Aug 2022 14:32:48 +0800 you wrote:
> When we call xdp_convert_buff_to_frame() to get xdpf, if it returns
> NULL, we should check if xdp_page was allocated by xdp_linearize_page().
> If it is newly allocated, it should be freed here alone. Just like any
> other "goto err_xdp".
> 
> Fixes: 44fa2dbd4759 ("xdp: transition into using xdp_frame for ndo_xdp_xmit")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net] virtio_net: fix memory leak inside XPD_TX with mergeable
    https://git.kernel.org/netdev/net/c/7a542bee27c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


