Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CC75ABD05
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiICEaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiICEaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13698419AA
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 21:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EF3960FA7
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09EA1C43140;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662179421;
        bh=PO+7kzORkzVva2ZrFAMf0tFhKoSAARYn6jZ3n5ZBLfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b639HfKurXSJh4lyqGUhf/Twu0ZIR/jCuPEi5yIgpsbW0nzGn+muE4yfHEOmM1kkw
         6rpn9hUylp9LnV7N6jp5IOscBD+B6VH0x8SRfpl2GC5ldhG1VNAdLvcLv0/mN3ue5c
         E++I8kY67kBToXK5qcCDFNYbziJlypXj7hkIuViN/7B3aOy8rqvy+VW2MZq9QiyWZD
         L/bJYQIN+lZJ+QIZDyBTGijTPc+KPHKaSNBKw0pwkI38RvmgkhxFkeGhqAwxdxsNmR
         bR8hPzsYLM8V5QQ1Fb+nQLlQdDhNIQ4MeDXeQ0ubi8L6i45oE+ZKIqfLqNpSyL0qtU
         9GrUCebo95RlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4CD0E924E4;
        Sat,  3 Sep 2022 04:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sunplus: Fix return type for implementation of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217942093.8630.7030418556822581393.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:30:20 +0000
References: <20220902075952.54345-1-guozihua@huawei.com>
In-Reply-To: <20220902075952.54345-1-guozihua@huawei.com>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     netdev@vger.kernel.org, wellslutw@gmail.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 2 Sep 2022 15:59:52 +0800 you wrote:
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this might get
> cought out by CFI and cause a panic.
> 
> spl2sw_ethernet_start_xmit() would return either NETDEV_TX_BUSY or
> NETDEV_TX_OK, so change the return type to netdev_tx_t directly.
> 
> [...]

Here is the summary with links:
  - net: sunplus: Fix return type for implementation of
    https://git.kernel.org/netdev/net-next/c/7b620e156097

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


