Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE262671C
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiKLFKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiKLFKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6900132BB1
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 21:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9CC5CE2B35
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5E1FC43147;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=PaooxliwUn1Pu2sLF2ZbvJCMXz0/JXs7SKnFjzv6wWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RE+7fnuYjcb7NBMh7jhN5Zjqv9SubKMS2MWNLDcFMaYYUAnk0NzT79G4CYEu1/msf
         KwZNviv8eEukv9OrwvJrDM9I37jzSJTBW+qzaInKiTFFqEoHgbmq5vCfSdS6YP23ag
         CCD4Lp/aT1+87Ahj9g/xPHqy1/YrjjCBu23jNgeitr5VmqHXbRs6fveXmOGCqZxt8M
         0KIMVUDenb3ziCyyawdN9Vj97Rf1Jq6dXWaWVj5ykyWdxTNcu7auDScPPNHp37vuwu
         nFBiaNetb1q5dYwku4siQw4RnWJSOAtsWNJdL4d4pcgz8oxcxE78QDvq/6rQrOKBtE
         kf+6QDN/YCB8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DAC9E524C8;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/tls: Fix memory leak in tls_enc_skb() and
 tls_sw_fallback_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981744.20406.15674722676438523059.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221110090329.2036382-1-liaoyu15@huawei.com>
In-Reply-To: <20221110090329.2036382-1-liaoyu15@huawei.com>
To:     Yu Liao <liaoyu15@huawei.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        gal@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        davem@davemloft.net, liwei391@huawei.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 17:03:29 +0800 you wrote:
> 'aead_req' and 'aead_send' is allocated but not freed in default switch
> case. This commit fixes the potential memory leak by freeing them under
> the situation.
> 
> Fixes: ea7a9d88ba21 ("net/tls: Use cipher sizes structs")
> Signed-off-by: Yu Liao <liaoyu15@huawei.com>
> 
> [...]

Here is the summary with links:
  - [v2] net/tls: Fix memory leak in tls_enc_skb() and tls_sw_fallback_init()
    https://git.kernel.org/netdev/net/c/0834ced65a6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


