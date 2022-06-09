Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F08544224
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 05:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiFIDuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 23:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiFIDuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 23:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A69100;
        Wed,  8 Jun 2022 20:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8405261C31;
        Thu,  9 Jun 2022 03:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFB25C34115;
        Thu,  9 Jun 2022 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654746612;
        bh=fFZmJ6RX445T/UbDv09I1P7giPriqSfKBoZ4d+EjFvM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VVbOUlxRb15927m30PHJ3obRhNGxrbNpvz+ocoQTtAqCfE+UcUUpzfKfm8ZpqtsU8
         /RjPJ4dd/paQcbZyhTBYaHk9K0DBBz7yQmHHxndRA41+KQt/8kfnH7RHXgZ+I3RnCC
         vF8pX/NvQPy59/EmNwcVrINQPbrwOAJryxPflOqjXoU2xd0+mNw5E8yrZaQGdpAFoc
         +3dbF/zjY2hm1KXiUP7eMMz4xVrNzWaB7aBT6CB1N410oDLY/fl+uyzEMj/CoIDPef
         0F9CtABRwup/nn2YV9IdK9hwpjotoP3GiqoTXyPwrHbak4LbAjco7v2mQnkkdePqUC
         3G2RgLABWpJpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7009E737FE;
        Thu,  9 Jun 2022 03:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474661281.23506.13629631597684739850.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 03:50:12 +0000
References: <1654692413-2598-1-git-send-email-chen45464546@163.com>
In-Reply-To: <1654692413-2598-1-git-send-email-chen45464546@163.com>
To:     Chen Lin <chen45464546@163.com>
Cc:     kuba@kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 20:46:53 +0800 you wrote:
> When rx_flag == MTK_RX_FLAGS_HWLRO,
> rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
> netdev_alloc_frag is for alloction of page fragment only.
> Reference to other drivers and Documentation/vm/page_frags.rst
> 
> Branch to use __get_free_pages when ring->frag_size > PAGE_SIZE.
> 
> [...]

Here is the summary with links:
  - [v5] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag
    https://git.kernel.org/netdev/net/c/2f2c0d2919a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


