Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0772E508589
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377546AbiDTKNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377484AbiDTKM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:12:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6933EBB5;
        Wed, 20 Apr 2022 03:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62E8561755;
        Wed, 20 Apr 2022 10:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EC58C385A1;
        Wed, 20 Apr 2022 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650449412;
        bh=kgUJN+UBTLmDmzszyDcZPLTkalYOukejwnpRQs4AeAI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AwjgT+6W2dzbhhkNsCJAcf2oHZEW9UfQNy9qrmXYC4/JAy6DTlCz9rL/LHR9DKYlu
         o8K6h01aSyUVDlc7cb1EQ6vnqnXk1QfRKbSda9pYwA4dUS2QeH7F4dDfdL0lPUGQsU
         38JHh1VIMetB8mRLVjVWI3siPOQYtxSmvvUUDQyTXQzfJgN4X9O9IPcSyRtx4K+IFG
         EVCqoFqb+nlm2+fyNMvIg3WCZpF3gJCtkZaJW0RMoO0cgyL4MXzrTGXN2fij9Que7a
         TlrCOPofBJ+TD2xQTOVirCCGk8F5Gi7OifmURNej5wy3FD3uBgxPYyxj3of/p3ONQt
         VSMID04DNhK4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7154DE85D90;
        Wed, 20 Apr 2022 10:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ar5523: Use kzalloc instead of kmalloc/memset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165044941246.8751.12176607608401955459.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:10:12 +0000
References: <1650332252-4994-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1650332252-4994-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     pontus.fuchs@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 09:37:31 +0800 you wrote:
> Use kzalloc rather than duplicating its implementation, which
> makes code simple and easy to understand.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/wireless/ath/ar5523/ar5523.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - ar5523: Use kzalloc instead of kmalloc/memset
    https://git.kernel.org/netdev/net-next/c/e63dd4123507

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


