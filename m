Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D960D96C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiJZCuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbiJZCuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9A33E769;
        Tue, 25 Oct 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 609AAB81FEE;
        Wed, 26 Oct 2022 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8E41C43470;
        Wed, 26 Oct 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666752615;
        bh=n9sJ4KLB0FhlXT692AcX2PeP8h09PGHq9UBiYs6qD8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+DiQMyPGAx9dpdzPmRZXUMBArxNKqHI689FtnEK4Hpvu+F1zKGOiezCN61CNffHY
         jQvfNMp+un8KcVdCqg4iIs+ykyxqfRMM4+wtm1XJi/yUaw0NqLF2WAhUDVZZkx0Qe/
         OPJZNBBX/Xgcsv1Esef5yFCNAfj5WutfQVOIRfW9Lwu8QIi9qhrfQK6eYnq1oA1pXh
         dWn1c8H9/3aJXdGqd0OsTFANR90FTpGWlS6eM3S7a4lwlfdMTcPT6Eioa3zOz//f9A
         nC+JvM3o98GbOheBHLQ6eSMBVBL15zGnQ87mQerl0mHd+ffpwI2lE2YI8TN8ZxSi9w
         eKeztujVSPsmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEC1FE29F32;
        Wed, 26 Oct 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: hinic: Set max_mtu/min_mtu directly to simplify the
 code.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166675261484.3838.2180607229263110846.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 02:50:14 +0000
References: <20221024103349.4494-1-cai.huoqing@linux.dev>
In-Reply-To: <20221024103349.4494-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, mqaio@linux.alibaba.com, shaozhengchao@huawei.com,
        christophe.jaillet@wanadoo.fr, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Oct 2022 18:33:35 +0800 you wrote:
> From: caihuoqing <cai.huoqing@linux.dev>
> 
> Set max_mtu/min_mtu directly to avoid making the validity judgment
> when set mtu, because the judgment is made in net/core: dev_validate_mtu,
> so to simplify the code.
> 
> Signed-off-by: caihuoqing <cai.huoqing@linux.dev>
> 
> [...]

Here is the summary with links:
  - [v4] net: hinic: Set max_mtu/min_mtu directly to simplify the code.
    https://git.kernel.org/netdev/net-next/c/022f19cf361b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


