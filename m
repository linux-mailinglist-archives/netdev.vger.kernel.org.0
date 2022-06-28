Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1B755E168
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbiF1FkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244340AbiF1FkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E73313E8B;
        Mon, 27 Jun 2022 22:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C24EB81C55;
        Tue, 28 Jun 2022 05:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12192C3411D;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394815;
        bh=Iu6dQkyIEKcoDAXZCseTzJDUCVtlpQuhsunv1Q5yZ44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gr1kdIRdMHYnMXLoSWSPl9JuYV1wyjd945xJRFhoyve58wEypaDN9SVWlxytyA4Pj
         Mw8WbY6VKI0u71jeQM4xtrWgdMudo4kbaH3FiRbMYe5MHbJ9YngLkhMqrmZjJyPKRk
         ZLTwW1qAckmwEj1yetJOMnxi1DdFbKQsEQJm6AhQmQKkUYUy9FjIj8GQ7pGylqckSB
         LsD6QjPb+E6OD77t7T8WMpXlEuDddgz3seH5jnnRZWtvSxg1fitJMeVaeB923zqZja
         HnfR/RKL9Y4+fW1feDYU5UnVatawVotyWfRAWguS8udNcSwlRZF7tu1DW0IgvxDbRJ
         6JaTRHsNxeh3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0B52E49FA1;
        Tue, 28 Jun 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: axienet: Modify function description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481498.10558.13866676954785753975.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:14 +0000
References: <20220624013114.1913-1-wangdeming@inspur.com>
In-Reply-To: <20220624013114.1913-1-wangdeming@inspur.com>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 23 Jun 2022 21:31:14 -0400 you wrote:
> Delete duplicate words of "the".
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: axienet: Modify function description
    https://git.kernel.org/netdev/net-next/c/e3b64a7a5af3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


