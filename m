Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165FB52A048
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242549AbiEQLUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiEQLUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA29D488B7;
        Tue, 17 May 2022 04:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D9FF60EDB;
        Tue, 17 May 2022 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5F7EC34100;
        Tue, 17 May 2022 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652786411;
        bh=6ME1FCgfb68+KCAik+XgRAsS5KN4aen17HQEYN8EsuA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m+iP0Zg8U5PVmXVa6bbHk1URYfUQ25qCdXMvgwcCywLr+tqr57SWnNKQht+cNPjDv
         f8tmpgTjTumKdpkaObBqpHjOadB24x+wQOxeFuUb/B9WzNIb428RbnKpYYtkLCpBJM
         XIRfmPxfKLyQ4/pA2bPx8KMCL6N2BVYjwZERrTXAJ6wQaNm8a1ZqnjKQ8FDDdjcIp2
         0K1rOtOPOtx2DPPPYWy7K+YisWR6OCgy0b+O+xUOkpGc+unraBMp6vXMe+xLmpDIMT
         O/5QzWRPjgwYYGqQqrTGWciCF6wjgu0zrUPcDiFNqMq+WAi3+/KSv2jAXu7s12os8l
         W7s2XBDreNA4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A66DDF0383D;
        Tue, 17 May 2022 11:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: vxge: Remove unnecessary synchronize_irq() before
 free_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165278641167.14620.4675085770290545617.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 11:20:11 +0000
References: <20220516081914.1651281-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220516081914.1651281-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     jdmason@kudzu.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 16 May 2022 08:19:14 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Calling synchronize_irq() right before free_irq() is quite useless. On one
> hand the IRQ can easily fire again before free_irq() is entered, on the
> other hand free_irq() itself calls synchronize_irq() internally (in a race
> condition free way), before any state associated with the IRQ is freed.
> 
> [...]

Here is the summary with links:
  - net: vxge: Remove unnecessary synchronize_irq() before free_irq()
    https://git.kernel.org/netdev/net-next/c/bd81bfb5a1d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


