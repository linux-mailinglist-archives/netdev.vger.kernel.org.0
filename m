Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A220155A75E
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiFYFkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiFYFkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAC051321;
        Fri, 24 Jun 2022 22:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 063C160AD1;
        Sat, 25 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 354D9C341C7;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135614;
        bh=68DpM9TT/RQKX8plVaKa1Q8rd8QxG7tw7GJQsst56Xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RcAnKgpqeCN4U0ZjfN1veLQBhr01/KxittZXiK5gQY3AYaWC6P9ao68CuKSnOyIg+
         Je/pyvG3nPrv3YaD9gNIhpLld2s59rAjqvLRqQjfoBtM5a9ULKB/aQUFh5sZaJ87T4
         puRr/b8jCQ65DGF1VV6JFKAmPYx6RGb6mb8i9c006GpR5Iskzk1hpxhGbrqXAD/O13
         ubL8XGOmxNutRJV4gV/WIp//MZc9HmmIjmP5yWhoETh8dLJl5BXlgsUpLumCO/8meR
         RGkcbTLw+eO/C8R+bQTw0+TuaqMGV3RYsTHafsWlN+8a36I9HIPm1fzzKva0KNjyh+
         ns9Cu7cX3uQUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21BA8E7386C;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc:siena:Fix syntax errors in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613561413.1389.15987972112154515372.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 05:40:14 +0000
References: <20220623043115.60482-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220623043115.60482-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 12:31:15 +0800 you wrote:
> Delete the redundant word 'set'.
> Delete the redundant word 'a'.
> Delete the redundant word 'in'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/sfc/siena/mcdi_pcol.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - sfc:siena:Fix syntax errors in comments
    https://git.kernel.org/netdev/net-next/c/85a1c6536f99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


