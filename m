Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8C36C29A2
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCUFLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjCUFLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:11:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA3C5FFA;
        Mon, 20 Mar 2023 22:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47D2061962;
        Tue, 21 Mar 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9595CC4339B;
        Tue, 21 Mar 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679375417;
        bh=3wlJH7WtjVPeAI4WXTmrgA+XfvXv3EtwCjOHgVj2ufk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qmsz1bzS1b+ClvbiCEeGrPSnKQcaJDxm8JO1TzZD1+1Uzdd+vpfKdDe+F8rfLP4Kg
         2L1liqUJ9rEcwhONz5LTU5t+Pbikkj/FA9F/BayfmNR5b3lBpkAm6yjqy1I2T1R4jJ
         RJd+Tg6zK3ihT8zlQLPsMUazMzddGjl5pwBEqw83TdlRztLHbE6XZGysxfYFonrMS9
         vbIaW8E5INbPiJ8uduAK0Z42sezK/srFTvRdBcu0nzBztrd9nYsjMe4brps4qZr4sU
         WQxR9+a8qlogxTTS6Xi1MK3Z1krT3XOf1GXxExvnoGfF2FFUB2BeyfS3ibsfAXiH/a
         2oYd4+gGMaiwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79719E4F0DA;
        Tue, 21 Mar 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] octeontx2-vf: Add missing free for alloc_percpu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167937541749.11815.454855826935672100.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 05:10:17 +0000
References: <20230317064337.18198-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20230317064337.18198-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kuba@kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.swiatkowski@linux.intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Mar 2023 14:43:37 +0800 you wrote:
> Add the free_percpu for the allocated "vf->hw.lmt_info" in order to avoid
> memory leak, same as the "pf->hw.lmt_info" in
> `drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.
> 
> Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated LMTLINE region")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Acked-by: Geethasowjanya Akula <gakula@marvell.com>
> 
> [...]

Here is the summary with links:
  - [v2] octeontx2-vf: Add missing free for alloc_percpu
    https://git.kernel.org/netdev/net/c/f038f3917baf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


