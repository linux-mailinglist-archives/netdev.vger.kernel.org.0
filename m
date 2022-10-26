Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12F860D981
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiJZDA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiJZDAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCF23740F;
        Tue, 25 Oct 2022 20:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5851B82014;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64D12C433D7;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753216;
        bh=8nabVticuCpcAcueCMQ1mmCBEDT7rRPUWr+aIr8zL3c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=khhfOhDAoNx6GuhbDgwlQKDStMxcAlhyLgV0RhhG/HyBG11DsdxTytOo13oD/M3/0
         rsX7pxI/rOb9W0JN6Z9nMkE7kp4n2Bx7jAgVcsd8lf6yB11sVJEUqNCtdibRxB/IkI
         0+qQt/HTSiEI72hgqz3i+KRK2x86UvhpaBtctaT+hnPpPPvguJFr7cLPvkN/MrMdsI
         G7jd7mwvXjo6PmlyasVNrqBO4217JZQWov1+z4x0z2gVuuETJMxPwXoCXubBlosH2k
         bZZtx/crFLbqWu2lzTODk4NHVkwhs3GvO71t+axt9cvtnpv/Hhc3PDpLEEeCKVShVV
         Tgvw6DMWxUSkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 455EDE45192;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] net: ipa: fix v3.5.1 resource limit max values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166675321627.7735.13125128064237036684.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 03:00:16 +0000
References: <20221024210336.4014983-1-caleb.connolly@linaro.org>
In-Reply-To: <20221024210336.4014983-1-caleb.connolly@linaro.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
Cc:     elder@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jami.kettunen@somainline.org,
        elder@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Oct 2022 22:03:31 +0100 you wrote:
> Some resource limits on IPA v3.5.1 have their max values set to
> 255, this causes a few splats in ipa_reg_encode and prevents the
> IPA from booting properly. The limits are all 6 bits wide so
> adjust the max values to 63.
> 
> Fixes: 1c418c4a929c ("net: ipa: define resource group/type IPA register fields")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: ipa: fix v3.5.1 resource limit max values
    https://git.kernel.org/netdev/net/c/f23a566bbfc0
  - [v2,2/2] net: ipa: fix v3.1 resource limit masks
    https://git.kernel.org/netdev/net/c/05a31b94af32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


