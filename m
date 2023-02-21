Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8650E69E598
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbjBURK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbjBURKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:10:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C461BAEE;
        Tue, 21 Feb 2023 09:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51E6EB80EAB;
        Tue, 21 Feb 2023 17:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9E66C433AE;
        Tue, 21 Feb 2023 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676999418;
        bh=0hlJs8PCwXbCA4MA3yHGksQYbthDDCsUOTg1IfC/xLY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oXm5u841qGvn6gxnJjOUFkl2ySDkNxTTNDCvRE01V32IaRo4J1UZGpNR3tfxqu8YD
         T3ApJ78M1fHFjIHlf2tR/03NSvbdpN/FM/mL87mc49lXzjpYsBkMonrjC54KzljmNa
         C/3nLqnu/LtljytdQGauy1Qao0dk2GdYXZohxwOK3HC/dwls/YLMZtTC51YsUZM+o1
         pDACIKLTr+gLO4FjB4MkBxqribACc+MGXG+uAwyBJfUsNue3ROeql5o7gadxiK3CYV
         cjnCKp7l/9rVz+fM7uCVzRqKQrQGguFrb/Ab/eupdJ6p1Pl0o4jDIiF5Qn3t3inexK
         4bTWq4NZ3MBvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6ABBC43159;
        Tue, 21 Feb 2023 17:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167699941787.22649.10401891950568750658.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 17:10:17 +0000
References: <20230221083036.2414-1-liubo03@inspur.com>
In-Reply-To: <20230221083036.2414-1-liubo03@inspur.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rempel-privat.de, bagasdotme@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 21 Feb 2023 03:30:36 -0500 you wrote:
> Remove the repeated word "for" in comments.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  net/ethtool/pse-pd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ethtool: pse-pd: Fix double word in comments
    https://git.kernel.org/netdev/net-next/c/7ec077744aad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


