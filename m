Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE63761F209
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiKGLk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiKGLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67731A06D
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D1DF60FB8
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 970AEC43142;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667821215;
        bh=UGd0/5ofkUEWKicAaJuerDQasCfxy0KQUwKde0cJR1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePv80Yg90xwbnNkh4xUAAgQlvtAylnRoWYJy3U0Q2iSjjys6cKZhlPtPdwC8eAxuN
         rOEGFbXy/lVrCKStqPHEaHptRH4xWG+E3ALbyhc8Z23+4nqdGlLdvVi3iExavpoCPg
         RuonGFDQT02U+rgyAcWm2+Z6C3fJnzOppJkadYB5j/6BQLzzImnUTGrIJk0jAVzBGo
         jnUzbd6K4Y2I9UGxDQVjyrosVdoMXCzO2bvGz2Qrod1pN+5Gw1c7qr6/Bnz5GO8ppA
         tFwP43oYPDg5omkgoloPaSv8fJdOagBA+s0DD3wt/VdW0nkUcav/H2GJOccCdJjljB
         nri5gLi2kYBNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FC55C4166D;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: Fix error return code in gve_prefill_rx_pages()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782121552.20740.18043401751385826661.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 11:40:15 +0000
References: <20221104061736.1621866-1-yangyingliang@huawei.com>
In-Reply-To: <20221104061736.1621866-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jeroendb@google.com, csully@google.com,
        shailend@google.com, davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 4 Nov 2022 14:17:36 +0800 you wrote:
> If alloc_page() fails in gve_prefill_rx_pages(), it should return
> an error code in the error path.
> 
> Fixes: 82fd151d38d9 ("gve: Reduce alloc and copy costs in the GQ rx path")
> Cc: Jeroen de Borst <jeroendb@google.com>
> Cc: Catherine Sullivan <csully@google.com>
> Cc: Shailend Chand <shailend@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] gve: Fix error return code in gve_prefill_rx_pages()
    https://git.kernel.org/netdev/net-next/c/64c426dfbbd2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


