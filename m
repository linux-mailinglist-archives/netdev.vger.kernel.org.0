Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7745A86A3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiHaTUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiHaTUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE5E27B36
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA3FCB822AB
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74C41C433D7;
        Wed, 31 Aug 2022 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661973614;
        bh=Fm1deaeE+p4y04cF0Pq8YRF5SrM3l7QD4fo/O8ixfg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HoOHxnPax3Pw4Z3VYou4J0suOV1yO9QPSy+KuV3TA2YgMVvXyzWcet27w8x7KBjtv
         JtJzflIVY1cjVti93atmyUdsS/hoi7HA3MqYN9CUYVgstLseASKc31oEd9ZwFsvfYb
         DXlerxXvfcKhq8mfUjsU24k4qs93BttCFl6uAWZXqDVof8JRtCXUUB8WhAJLeJ+kLF
         J+kHfZDgJS9nB+m77DW5opU14c/ZRoQkn/ipdJa4L/i/ExO0hTviLF+cvE/YMJPH7I
         XTuOhl3nbGs7E89XcSbUpKlre6IpN6Rmgh8HH/GsOvN59so8TidPk+FTciasYEcp8w
         QTIxK+Bz9OPxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57CCDC4166F;
        Wed, 31 Aug 2022 19:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] mlxbf_gige: compute MDIO period based on i1clk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197361435.5324.4222952280326633553.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 19:20:14 +0000
References: <20220826155916.12491-1-davthompson@nvidia.com>
In-Reply-To: <20220826155916.12491-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, asmaa@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 26 Aug 2022 11:59:16 -0400 you wrote:
> This patch adds logic to compute the MDIO period based on
> the i1clk, and thereafter write the MDIO period into the YU
> MDIO config register. The i1clk resource from the ACPI table
> is used to provide addressing to YU bootrecord PLL registers.
> The values in these registers are used to compute MDIO period.
> If the i1clk resource is not present in the ACPI table, then
> the current default hardcorded value of 430Mhz is used.
> The i1clk clock value of 430MHz is only accurate for boards
> with BF2 mid bin and main bin SoCs. The BF2 high bin SoCs
> have i1clk = 500MHz, but can support a slower MDIO period.
> 
> [...]

Here is the summary with links:
  - [net,v1] mlxbf_gige: compute MDIO period based on i1clk
    https://git.kernel.org/netdev/net/c/3a1a274e933f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


