Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790CD6E967A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjDTOAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjDTOAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3AE1FC7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32FA0649C1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 14:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 910ACC433EF;
        Thu, 20 Apr 2023 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681999219;
        bh=WAYfJcOyWDyKllGaJuXSA8b1cvb1qsT8HYjj/7cOGLw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G0i0IKMd7N8OqMUdGvxsKepj7QSoJPMFzcx/JJmlyI2kIM5uPA4QcM2uJAWjfDZ39
         Jfq+aSMgqzYDiH+sybg15lr9hVyTqL6Eq8ILnH1CvEnrufs4HP+PmpAjcjrafP7RjR
         tmHfE7n9vPEmsIOvx61TkZ6zJAQTZqhUYlbtMzO06uOyULsByRU1uW0oQYttL3mZSm
         yIZc8WZwaXjENXepD0wEE7hAqki3FzsJgB8kW/QANoEvmx1w7DFMba/a5l/gr2IL6w
         ylwIsC4qp1cHzKDQBuilsYoEZptNGamAzWpB/GilGlHi4RlxmhfQcaEFRtS4KUMcsv
         JRRnxP8ElHMyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AAC7E270E5;
        Thu, 20 Apr 2023 14:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: libwx: fix memory leak in wx_setup_rx_resources
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168199921949.17149.10730360260810886257.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 14:00:19 +0000
References: <20230418065450.2268522-1-shaozhengchao@huawei.com>
In-Reply-To: <20230418065450.2268522-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com,
        mengyuanlou@net-swift.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yang.lee@linux.alibaba.com, error27@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 18 Apr 2023 14:54:50 +0800 you wrote:
> When wx_alloc_page_pool() failed in wx_setup_rx_resources(), it doesn't
> release DMA buffer. Add dma_free_coherent() in the error path to release
> the DMA buffer.
> 
> Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: libwx: fix memory leak in wx_setup_rx_resources
    https://git.kernel.org/netdev/net-next/c/e315e7b83a22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


