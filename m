Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516CA5305F8
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351420AbiEVUuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351315AbiEVUuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F442A26B;
        Sun, 22 May 2022 13:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 141A4B80DE1;
        Sun, 22 May 2022 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB2B6C3411D;
        Sun, 22 May 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653252612;
        bh=Kk5uT/DeKHK1sHJ505T67+URNDzp9i39Lv4OQ7CtE7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MLrtacHMMFJjMfg0WFIhbXf6iba5xMv/jdPiIwqLDX7SxLNzn2lb4MJ8ka+NQY/tv
         yVd5kzltoA2FPV7CaOx/8yxlrfRYrJcxUKuwSiISLNuC+PnKYDjVKwuNTgO5oNOlyG
         i9s56pEIO5S4nqAjPlbHsu3pxMgH66WSoCTGaTOx6hl1xubTJHKgcu9OaAEBoEw4MG
         mFSOiWrPRgGMzkUCX97iJeEx6zAypzWvkEXMUUhkfXu6k2fqaxakQpmWvkl35v7YPW
         InuQtfozwwX5cxCnP9blwwESbjURQr17/9VZqfnMXCm16s0N9F3pj371OBddKN9BNf
         gXiC0DOrdKnJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB876E8DBDA;
        Sun, 22 May 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: selftests: Add stress_reuseport_listen to .gitignore
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325261269.21066.8374996331619063241.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 20:50:12 +0000
References: <20220521093706.157595-1-usama.anjum@collabora.com>
In-Reply-To: <20220521093706.157595-1-usama.anjum@collabora.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, kafai@fb.com,
        kernel@collabora.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 21 May 2022 14:37:06 +0500 you wrote:
> Add newly added stress_reuseport_listen object to .gitignore file.
> 
> Fixes: ec8cb4f617a2 ("net: selftests: Stress reuseport listen")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  tools/testing/selftests/net/.gitignore | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: selftests: Add stress_reuseport_listen to .gitignore
    https://git.kernel.org/netdev/net-next/c/a3f7404c0bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


