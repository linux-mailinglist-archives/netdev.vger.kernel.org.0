Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91C85EB19A
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIZTuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiIZTuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71551110C;
        Mon, 26 Sep 2022 12:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C294612C3;
        Mon, 26 Sep 2022 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E39EC433D6;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221817;
        bh=DLNTJwRALufslcctqRNhV/BRoDslEqMSzhkCZpOfZf0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qlQYMUhuUad6VhYPorAuEPUI2df3ze6s/HaN4WxwHw7NpfrHwqYOhm9CGIFAchNkq
         ukvsIWO/ZrYLBDKXlppg9IJkA9Knb/UYLohpqFVGQK1er1EkjGZ+S4/FFODz9jkdvf
         zdZFzoi6ciRTnOg8A3xuBXL7zpYoCICyVbZlp9GgiADb1MMXElr0PQGI8J0kcilbKg
         ieP7Pnkh49IB4K4H0d0ED8u/jL9uBOcrMyEMskea/aDV9ILXvXkT93/wvOz9BUrI2D
         wTPIFpM7TsCeACmb+7JZY9ogp6Tw3oT8EYMtIqVmpziAyEKIWVloltgW3Iuk3Fn1M+
         CtH7iTHqls1YQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5974AC070C8;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: adi: Fix return value check in
 adin1110_probe_netdevs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422181736.25918.17964729176387213478.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 19:50:17 +0000
References: <20220922021023.811581-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20220922021023.811581-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lennart@lfdomain.com,
        alexandru.tachici@analog.com, weiyongjun1@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
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

On Thu, 22 Sep 2022 02:10:23 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> In case of error, the function get_phy_device() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: adi: Fix return value check in adin1110_probe_netdevs()
    https://git.kernel.org/netdev/net-next/c/9f1e337851be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


