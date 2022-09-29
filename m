Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A035EEFDE
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbiI2IBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbiI2IBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:01:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14BAFAC77
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548B662080
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0BD0C43140;
        Thu, 29 Sep 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664438415;
        bh=jN8W6qj1gZpbR0V6rn3V0AfAQbD9EtaGc5zxrsf2AYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uDnEe43Nk7X0PUMxjTk19LqfK6Trv5VVO4aVAUiTBtkR5FYaNFXixfue8dtMFRcN7
         YhOxD6ypUHNwsbdX2ss+i+tgD4/hzFGDq2jDoQIcMchlLHqmk9q+XEPsyc+AEQcY4t
         guyfTX2ViQSbZT680+r+MC4TfZZ2I277lqZTwvlQf7ZixZc64MIsSoi4R5HmLh8AKW
         TY7uKKTRDDphsJi8k0zSzOyaSDT46ml5G/7oqHTu/Olz+piudOphtN7AmDck+0X/2W
         FpcUaSzT3nPch6njGguREfff4tkxx0c76hkteaAPDo96rG3okZm2UFLPakoGG299L+
         Kj55RjwID56jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91E2FE4D01B;
        Thu, 29 Sep 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] wwan_hwsim: Use skb_put_data() instead of
 skb_put/memcpy pair
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166443841558.29286.6401738440734053427.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 08:00:15 +0000
References: <20220927024511.14665-1-shangxiaojing@huawei.com>
In-Reply-To: <20220927024511.14665-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 10:45:11 +0800 you wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/wwan/wwan_hwsim.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [-next] wwan_hwsim: Use skb_put_data() instead of skb_put/memcpy pair
    https://git.kernel.org/netdev/net-next/c/6db239f01abc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


