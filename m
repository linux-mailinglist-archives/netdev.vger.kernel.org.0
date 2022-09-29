Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE085EEC14
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiI2Cub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiI2Cu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12EC2A729
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32B5E6200A
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83C42C433D6;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419825;
        bh=eUaoUuQVpqQbJYbLx07kncpV4mUPQLwrO23/uvCkw/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YeCcxPbX4KL3HbDF0Wxqy/1Kw8mbpL0BHY0Hng9w8/REPDIpGj6GUTCXdlT396Avc
         FY2EYD38WXml1g0cC8aa7t/oKNcC2uoiJuBsBi1TMTLmIhy+LMz9Dl/GgQGpTPCiWm
         auDRbwjBmkVSInNF6TYA8fhitReYkHuS4Pd2b/Un2YzvGfkXUDZgJOjx+VMPhn0g3O
         ypfhaKGz25+zqOpQNAyyYK7hT8vQxyeApo8qspRJllUwNYy+waePTBKUBqGiK4Y8K3
         8F6ShYSoBaI7ovt5QqvEA/l0e1HsMeUOUHD7TpseYGOhXxHkt9ZCGE7PqLxHboR2IN
         EcoluiAZSJIMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66D85E4D022;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: wwan: iosm: Use skb_put_data() instead of
 skb_put/memcpy pair
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441982541.2371.3631955198846106239.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:50:25 +0000
References: <20220927023254.30342-1-shangxiaojing@huawei.com>
In-Reply-To: <20220927023254.30342-1-shangxiaojing@huawei.com>
To:     shangxiaojing <shangxiaojing@huawei.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 10:32:54 +0800 you wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: wwan: iosm: Use skb_put_data() instead of skb_put/memcpy pair
    https://git.kernel.org/netdev/net-next/c/f45892f75038

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


