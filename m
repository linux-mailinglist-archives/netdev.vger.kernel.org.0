Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054CA6CFA47
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjC3EkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjC3EkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192E335A1;
        Wed, 29 Mar 2023 21:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B57FB825BA;
        Thu, 30 Mar 2023 04:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF766C4339C;
        Thu, 30 Mar 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151218;
        bh=da0yoQXP+HETNK7ouOhqpiEF8FE6zBREr+34FNXiCQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oK+M2zD8cgSDhfsz8lrmyXywqP8S7PX6Jefg0rtgcRUqTh9h0iaURgW6PKPznhA7M
         mU4Xq1y6WqKJQohM4F8n3V55N0XkIHZ38hupW0QoUob9XIlwrwjuEtI/Hu6kYpzIJE
         84lAAatbVP+H9NVdhkXr7nfHBaW+AjFTaaOi2wRPomW92HV34YY3oXbludYpiwZAcE
         TSqRDYHP5yY/6oB7aG1eL5nLE2+lrGZyX0RLR5e3VkHESSaHTOUKrLL6O9jxP4Xwni
         1NvJQu3P2vYCsu7ybGG7Nm23FlfbFlsVpTtgj2gvpFG38WgeSHVxCOn0IzV0pKpKMb
         dvn7TktzetCew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B2CEE49FA7;
        Thu, 30 Mar 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: ipa: compute DMA pool size properly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015121862.8019.7512892342991706209.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:40:18 +0000
References: <20230328162751.2861791-1-elder@linaro.org>
In-Reply-To: <20230328162751.2861791-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, quic_bjorande@quicinc.com, mbloch@nvidia.com,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 11:27:51 -0500 you wrote:
> In gsi_trans_pool_init_dma(), the total size of a pool of memory
> used for DMA transactions is calculated.  However the calculation is
> done incorrectly.
> 
> For 4KB pages, this total size is currently always more than one
> page, and as a result, the calculation produces a positive (though
> incorrect) total size.  The code still works in this case; we just
> end up with fewer DMA pool entries than we intended.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: ipa: compute DMA pool size properly
    https://git.kernel.org/netdev/net/c/6c75dc94f2b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


