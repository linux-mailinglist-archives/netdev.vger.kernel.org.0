Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192594FEABF
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiDLXYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiDLXXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB6DC6F11;
        Tue, 12 Apr 2022 15:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F35861CBF;
        Tue, 12 Apr 2022 22:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 022E0C385A1;
        Tue, 12 Apr 2022 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649801412;
        bh=dQ/T/ZuxskmsuLt2xpmXTUGAR0p3y2TucLrWk/3CkUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O0B64cEAmjIFpM087/9dRj6tdnGTnNcj+MxuKeaYecd2p3gNGi5gzA+6uv9VT4jV6
         iaKeHTZnPeVdNwgn1g1i5xbDM6mEBCKKNerOJ5ijtkhEGE0hBoAzu/0lQk8dZTvOfV
         IV4jO3UZw/ru4aZ2JN0DKfQ1Jne5Tm/z8pEa04OLIK0QKzcAsvTyHlx8GRRs6b04CI
         VPVGxpHDsq6TBsh0npqfGpjJb6cDHZiGq+z6vLviWLdIWsAtY1dzUmeuQP8EXN/cfu
         HR92Tr14wT5S+C4R5CEUbmwoERM5IMx9dKHY2wt+G5tMGSP/hsmO62guOFdidUuUVJ
         eJrUp0r9Wy+Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D271EE6D402;
        Tue, 12 Apr 2022 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ixp4xx_eth: fix error check return value of
 platform_get_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164980141185.23707.2486129829088445971.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 22:10:11 +0000
References: <20220412085126.2532924-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20220412085126.2532924-1-lv.ruyi@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linus.walleij@linaro.org, arnd@arndb.de, lv.ruyi@zte.com.cn,
        wanjiabing@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zealci@zte.com.cn
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Apr 2022 08:51:26 +0000 you wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> platform_get_irq() return negative value on failure, so null check of
> return value is incorrect. Fix it by comparing whether it is less than
> zero.
> 
> Fixes: 9055a2f59162 ("ixp4xx_eth: make ptp support a platform driver")
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - ixp4xx_eth: fix error check return value of platform_get_irq()
    https://git.kernel.org/netdev/net-next/c/f45ba67eb74a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


