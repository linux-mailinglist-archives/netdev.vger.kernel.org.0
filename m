Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012E459C125
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiHVOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiHVOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E628539B91;
        Mon, 22 Aug 2022 07:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B6C611BC;
        Mon, 22 Aug 2022 14:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C022EC43146;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661176816;
        bh=TK0aHnVUHmyemBKxG6WHN2Y75ijt5Mj4rMw0lwKOElM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U+Ils+cn2M6HbqI7YRHZYLi/NWbVs07gCLT0e6mZ4JX4T7QI6cHLdEPePsFGALphB
         sfgxMoCbH8cq99zqcR7gyQcEpWtjUYlZ6djnb3T1qeIj3qrMT0uorQrF3WrA/VVXG+
         gRHblOsvUPKO9qGSJ/5VjaM+0bYs7DU49g9xYSperTRd7H+C9eSFc9O3B4e8Enkulf
         LKbQQbyLR6sVQaUGmtLYrnA5wKuJt/asFHWyd7kzSqDiLoPPLin70mZ5eRpFDvLPs7
         VzQ89/dsxk662LlzwnQsoTC0JKb4LFzjNkfP0CBWY+OPttl9Ssok3CQZ8YuUjGGvrX
         QisGfwLaw3+rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC634C04E59;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: freescale: xgmac: Do not dereference fwnode in struct
 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117681670.22523.6843770265863412321.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 14:00:16 +0000
References: <20220818095059.8870-1-zhaoxiao@uniontech.com>
In-Reply-To: <20220818095059.8870-1-zhaoxiao@uniontech.com>
To:     zhaoxiao <zhaoxiao@uniontech.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, morbo@google.com, weiyongjun1@huawei.com,
        colin.king@intel.com, tobias@waldekranz.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 18 Aug 2022 17:50:59 +0800 you wrote:
> In order to make the underneath API easier to change in the future,
> prevent users from dereferencing fwnode from struct device.
> Instead, use the specific dev_fwnode() API for that.
> 
> Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>
> ---
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: freescale: xgmac: Do not dereference fwnode in struct device
    https://git.kernel.org/netdev/net-next/c/105b0468d7b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


