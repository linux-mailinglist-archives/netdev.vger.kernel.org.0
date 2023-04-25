Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160AA6EDE81
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjDYIu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjDYIuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940C35B7;
        Tue, 25 Apr 2023 01:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04E9B62CEC;
        Tue, 25 Apr 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5845DC433A0;
        Tue, 25 Apr 2023 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682412619;
        bh=Mfq8yrxnuMMNRYzupPlRcoJpox8xhQLPPCGmRCRHJ/4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c0PuCEPKicdGzchx3Of5e7Iln5M0hRCqnElvFj7guEKzvTE8bZ9CM2dgtW5DTyIwI
         Q7dKPtD5pY+o4o3M0oSsKhtwlvtePG071TrpkFZiK/CjVPfJE6ZmZx5G3q1hMdY4QD
         aqAuZ5faA2ax6M9a6HC+NvD5up+WJSwhamqWvNLCT1iYY0lOo5xSN48GLXRfdVpHLe
         b8L8ZMIn3pplLTV4fgF8tZGEGOjdEegs/N+QMmntAEE73dbpkai6REZ7dyAnzdiZbH
         eRrBi+4g78J8nVK9jUeqEDd+0Xi8Yqety+b00J8hCRs8TIpi55TSv3cUSuY3mLBOwf
         j4WYZKLWKcmPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40C25E5FFCA;
        Tue, 25 Apr 2023 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: marvell-88x2222: remove unnecessary (void*)
 conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168241261926.1225.2701872674893598922.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 08:50:19 +0000
References: <20230425051532.44830-1-yunchuan@nfschina.com>
In-Reply-To: <20230425051532.44830-1-yunchuan@nfschina.com>
To:     wuych <yunchuan@nfschina.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Apr 2023 13:15:32 +0800 you wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  drivers/net/phy/marvell-88x2222.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: phy: marvell-88x2222: remove unnecessary (void*) conversions
    https://git.kernel.org/netdev/net-next/c/28b17f6270f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


