Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD0645871
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLGLBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiLGLAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B188F2A43D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 759DBB81CEC
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2899EC433D7;
        Wed,  7 Dec 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670410816;
        bh=Mb5ZY9+Lp1JfyIe7OBAqVnpoZIAGDHdVud0v3NlHJ5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y2eSbZMzYRWzzfRgoLVq5nvHB+4kjOJGCzOPeEweFoV7tFaE87yMabSI5l29rlMPT
         oU7Q3S2OTHSbBJIvG/JmnHnBk0CCNU7UsuUnQZEFSNgyNm0EDoNRjxEWQhgjvQRM1K
         e1f4PdYjsKqMihr3jyCZmLzQqDCJRSkw/QKoEuzqEyRKekQ6wRgSLngDCwkzkcXN56
         xEXVxned4ZQGSZrCZCRAImiwecIobDAsgxep1xPQlZjX7usiLrd6RuuJcjjAufEe+L
         5tgmx3ik37p+L/IlQvRWnZ1WKGrMKUIz7pINftMy1WG/cFokM2qbIaX0d8WvMr3otu
         DHvUrJqSzbqgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 160EDE4D02D;
        Wed,  7 Dec 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ethernet: mtk_wed: Fix missing of_node_put()
 in mtk_wed_wo_hardware_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167041081608.7212.15407463858879760365.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 11:00:16 +0000
References: <20221205034339.112163-1-yuancan@huawei.com>
In-Reply-To: <20221205034339.112163-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, sujuan.chen@mediatek.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 5 Dec 2022 03:43:39 +0000 you wrote:
> The np needs to be released through of_node_put() in the error handling
> path of mtk_wed_wo_hardware_init().
> 
> Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - Replace IS_ERR_OR_NULL() with IS_ERR() to check wo->mmio.regs.
> - Add net-next tag.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ethernet: mtk_wed: Fix missing of_node_put() in mtk_wed_wo_hardware_init()
    https://git.kernel.org/netdev/net-next/c/e22dcbc9aa32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


