Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6517B5EB21B
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIZUab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiIZUaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7217DF65;
        Mon, 26 Sep 2022 13:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2EDE6126A;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C6D3C433D7;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664224215;
        bh=RJ6jtyOjU1W5kzNPFeCAt+kkwBt7wbBvhZ3gdMNIa9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RI4GbgzotzcRu4Di6LBsCp0SXpO/62Hu+IVl/tSc7tobtgWRzTxIOgJ+JfC2q9KOH
         cIAOY0rWO0dHVpgxO8zU4UBTZzzUcJ08BKrracrUoKiLtVg4mBweuthm3xfFas12Pd
         WhpJXIMH05Il8LxUexf82tn/WcV21OmLuxMX5uNIDFksBLrRAvX67CK0EKbPDXwqI+
         abR+I+nJGPCQNjDDoGh8P5XsKaaiWjw7BLdSqcBZiyvc2e4vUMDDQ8DwDsklUkSvQL
         vCtUYfUhmVfPsstjT0JLtUzMGFfdwZEPEzO+KAoXsRmCD/41JIost+Rso7KVKVCBvC
         vp7G6tzEkiFjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1A6DE21EC2;
        Mon, 26 Sep 2022 20:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in
 mlxbf_gige_mdio_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422421491.13925.4532839446468338951.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 20:30:14 +0000
References: <20220923023640.116057-1-wupeng58@huawei.com>
In-Reply-To: <20220923023640.116057-1-wupeng58@huawei.com>
To:     Peng Wu <wupeng58@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, asmaa@nvidia.com, davthompson@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liwei391@huawei.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 02:36:40 +0000 you wrote:
> The devm_ioremap() function returns NULL on error, it doesn't return
> error pointers.
> 
> Fixes: 3a1a274e933f ("mlxbf_gige: compute MDIO period based on i1clk")
> Signed-off-by: Peng Wu <wupeng58@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe
    https://git.kernel.org/netdev/net/c/4774db8dfc6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


