Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D230D6C76C2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 06:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjCXFAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 01:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCXFAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 01:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BE128E5C;
        Thu, 23 Mar 2023 22:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA42B822E2;
        Fri, 24 Mar 2023 05:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D48F8C433D2;
        Fri, 24 Mar 2023 05:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679634026;
        bh=qfVHgp+5oL2oL1nXQ3h/7rUusCHjez1p7JZ3phax7bs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDBOpvTjCSbkPKXuSI2fQ/byDR5T2n2Eys0TtI400S2+gwocomkxEC9VL5HRTh/DL
         sl/gmy11Vc1vcB5Sw7QRCToGv39wsroGOsCTxTgr3H+3nvs0O8OONwAFi121Vhj3Xg
         Is+BUfpszIV2F3l8GwEDvxXFAptArSeHBJutf855EEg/7LhexAL4ap3wkaB/qjv89y
         c3oV7bpE1R2B9pn+olb00TmpcvHrElQSXQJmzn7cq3drdoboMQpZVM0dADc66oUh9i
         IVtMh6d68VrixsRp0TL9udmXpqv52sFaxyUJ9cikFpyBaHVdSoQBHuWFRpTAQmcCbH
         RvWq/wf1Ol8Fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B488FE61B87;
        Fri, 24 Mar 2023 05:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] bnx2: remove deadcode in bnx2_init_cpus()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167963402673.21241.18025874959684415951.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 05:00:26 +0000
References: <20230322162843.3452-1-korotkov.maxim.s@gmail.com>
In-Reply-To: <20230322162843.3452-1-korotkov.maxim.s@gmail.com>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mchan@broadcom.com, vadim.fedorenko@linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, leonro@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Mar 2023 19:28:43 +0300 you wrote:
> The load_cpu_fw function has no error return code
> and always returns zero. Checking the value returned by
> this function does not make sense.
> Now checking the value of the return value is misleading when reading
> the code. Path with error handling was deleted in 57579f7629a3
> ("bnx2: Use request_firmware()").
> As a result, bnx2_init_cpus() will also return only zero
> Therefore, it will be safe to change the type of functions
> to void and remove checking to improving readability.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] bnx2: remove deadcode in bnx2_init_cpus()
    https://git.kernel.org/netdev/net-next/c/4691720f509a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


