Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8280528295
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242588AbiEPKuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiEPKuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFAD275F4;
        Mon, 16 May 2022 03:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6202E60F78;
        Mon, 16 May 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE52BC34115;
        Mon, 16 May 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652698212;
        bh=t+51nrrgSkIjnZenLBM29jn0cFivbc6zRaMM3G1kdGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BiBAoRpMNhVcmAL9+QuFnxcI4SnKlJ+6Zrfv2UjK3+YuIK+vaCuxg6rLU3QA679xw
         wCiELqhfjxBoaRwJ8CK9Hasi18dukyxxzA38BFcIe37LKTyWNnmRSDJXcZTk7MRv1g
         CLINudovi5qhekkhbootCY1ImZ7eDONUCHMor7mmfLDxjJq/JIsED4ybELTPJCpyM0
         DVe3Lbu8CqwQzmsvvyRq3L51/9jUKc8WOB508tG3Bhx8TXrI2X2F4fcfMfJW95ajOj
         p3G70eJC8BtlbxrU9nVAKPjwlQhk7PNEj/nPRkqxl3BLpJo2/6JsRgvaz2OQCyl6bG
         Fb2oiY4UZkVXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F4E7E8DBDA;
        Mon, 16 May 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Remove unnecessary synchronize_irq() before
 free_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269821264.15644.13660458221076598095.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:50:12 +0000
References: <20220513081918.1631351-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220513081918.1631351-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 08:19:18 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Calling synchronize_irq() right before free_irq() is quite useless. On one
> hand the IRQ can easily fire again before free_irq() is entered, on the
> other hand free_irq() itself calls synchronize_irq() internally (in a race
> condition free way), before any state associated with the IRQ is freed.
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: Remove unnecessary synchronize_irq() before free_irq()
    https://git.kernel.org/netdev/net-next/c/d887ae3247e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


