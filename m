Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED665E7131
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiIWBLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiIWBK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B037F9629;
        Thu, 22 Sep 2022 18:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07906B834F3;
        Fri, 23 Sep 2022 01:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC34EC433C1;
        Fri, 23 Sep 2022 01:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663895422;
        bh=op7+9L67dqlaF5pksxSU+uimTe+RF2SRZi+xWANH2NI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UPYkIWELE/ahQh1qQMbRUpL0CZMurPrXkdwo362V4058WzSVE7eDh5MlpOlNGAe4V
         lk7695MPJeG3f12MBVT3L/dw9NIIumrmz/HlUn+NMwZAM/HKPf5FV/sVfTHVqlewvK
         t2wbiiiSR2ObMvcSRZzPGCCHa65/wVksncPtYPSB24VWWRiQqYllX8xPQ4R1Kyw6g6
         OOGz/XhgsH3xe3pIuk4gS8y6fadWuUitVnXPbobVmd543yOeZOnAwMm0t+B3mu7Pq9
         27cf7MhlxWsVfoD/HBTiL9kSfBVVv1oRZYureamZLF7jqYq4tt1v8nLvg7fv1nM1Ax
         hG+cWhUK3NNeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A1DFE4D03C;
        Fri, 23 Sep 2022 01:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next, v3 00/10] cleanup in Huawei hinic driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166389542255.15244.1888532276548956272.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 01:10:22 +0000
References: <20220921123358.63442-1-shaozhengchao@huawei.com>
In-Reply-To: <20220921123358.63442-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        shuah@kernel.org, victor@mojatatu.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 20:33:48 +0800 you wrote:
> Do code cleanup in Huawei hinic driver.
> 
> Zhengchao Shao (10):
>   net: hinic: modify kernel doc comments
>   net: hinic: change type of function to be static
>   net: hinic: remove unused functions
>   net: hinic: remove unused macro
>   net: hinic: remove duplicate macro definition
>   net: hinic: simplify code logic
>   net: hinic: change hinic_deinit_vf_hw() to void
>   net: hinic: remove unused enumerated value
>   net: hinic: replace magic numbers with macro
>   net: hinic: remove the unused input parameter prod_idx in
>     sq_prepare_ctrl()
> 
> [...]

Here is the summary with links:
  - [-next,v3,01/10] net: hinic: modify kernel doc comments
    https://git.kernel.org/netdev/net-next/c/15b209cde263
  - [-next,v3,02/10] net: hinic: change type of function to be static
    https://git.kernel.org/netdev/net-next/c/73f25f16cc3c
  - [-next,v3,03/10] net: hinic: remove unused functions
    https://git.kernel.org/netdev/net-next/c/2b291ee6dd6e
  - [-next,v3,04/10] net: hinic: remove unused macro
    https://git.kernel.org/netdev/net-next/c/2fa1cd3b4a0d
  - [-next,v3,05/10] net: hinic: remove duplicate macro definition
    https://git.kernel.org/netdev/net-next/c/97d6a3e642bf
  - [-next,v3,06/10] net: hinic: simplify code logic
    https://git.kernel.org/netdev/net-next/c/4f304250c39b
  - [-next,v3,07/10] net: hinic: change hinic_deinit_vf_hw() to void
    https://git.kernel.org/netdev/net-next/c/dcbe72d25594
  - [-next,v3,08/10] net: hinic: remove unused enumerated value
    https://git.kernel.org/netdev/net-next/c/566ad0ed6b12
  - [-next,v3,09/10] net: hinic: replace magic numbers with macro
    https://git.kernel.org/netdev/net-next/c/57ac57154d83
  - [-next,v3,10/10] net: hinic: remove the unused input parameter prod_idx in sq_prepare_ctrl()
    https://git.kernel.org/netdev/net-next/c/c706df6d8f6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


