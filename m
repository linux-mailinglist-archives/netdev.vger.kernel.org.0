Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE25EEFDF
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiI2IB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiI2IBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:01:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2269FB333
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F9EB82398
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF3F9C43141;
        Thu, 29 Sep 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664438415;
        bh=KNC6ytsmU9/yq9CgFlyzlpsOGGoUBvcQA1TmRqTa7yI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u3h0ClM0WNwFHvoXI8OJpsFFzRUSmnJwtrBOxM73Edx3DIOBp1ZekbBP65+satBGx
         DDKUaQzg8MCg4xNmN8fUOB7g3LB2/dI/PSDseie5Y+5z24I8N8+YGKhC8ExfPJw5r2
         BEhJT1p4Dk9hTxqTnuQCO4GzJgRzFqZLw3BVEPbL/4KUuEbhWW/iPT4nqRpZSm/CQG
         nD8coWMM8GmcX4YIumBSQYHLhma4oZ8hoV3iuEP1PhWWP2J+3l6zhEHCMahnPIQ2zn
         tBAqr6XKMP9HrMeAQBzbZSYPog/nRyrJhpX4vGNsicUfckiJPmJal2BDgmDtE+zfd+
         PknhCDPrxdjyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FFC0C070C8;
        Thu, 29 Sep 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ax88796c: Use skb_put_data() instead of
 skb_put/memcpy pair
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166443841565.29286.7561483525001010283.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 08:00:15 +0000
References: <20220927023043.17769-1-shangxiaojing@huawei.com>
In-Reply-To: <20220927023043.17769-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     l.stelmach@samsung.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 10:30:43 +0800 you wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: ax88796c: Use skb_put_data() instead of skb_put/memcpy pair
    https://git.kernel.org/netdev/net-next/c/85e69a7dd693

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


