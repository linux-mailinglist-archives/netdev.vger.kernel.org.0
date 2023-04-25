Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F256ED9BB
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjDYBUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjDYBUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D88C5276;
        Mon, 24 Apr 2023 18:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E1262AB4;
        Tue, 25 Apr 2023 01:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60A8EC4339C;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385618;
        bh=f4AcqI+qCMXP20DaWFRyma1XjY4NWgPRRbKwYC28C74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XkAmmc/cAVwViZjdZjn16PwTUssL0gygA4nMeYwV5lqUNz6+7Rb+L5EDFTP/kQzKn
         DeM0Vcg7J2kgyeXvr2nieIbdBTIayrrreHs43AUo0ZrxUXvBYBbVvJct5tihzByyYl
         uIgJ2Rxh+0qUvh+V48WPWFHoLYq+AacPTQyELYS0lR6cwMXDTO7pwvWUMNw4TYugLy
         c4mf5hdPI+l1cyHeGGMtjZyZPrAi6YI4xDK5Ray9zOeiAhZ9iTprjneXsGA5Kqr6Ew
         mhLku+E0NCj2y/arZLDyPhrV1gcfqOsHSa3y4WDZc/HZoOIKpT+VXgGR02DbRIP7xg
         1IgIUZBdueLag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42FE7E5FFCB;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: dp83867: Remove unnecessary (void*) conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238561827.11483.3510600412139981916.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:20:18 +0000
References: <20230424101550.664319-1-yunchuan@nfschina.com>
In-Reply-To: <20230424101550.664319-1-yunchuan@nfschina.com>
To:     wuych <yunchuan@nfschina.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Apr 2023 18:15:50 +0800 you wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  drivers/net/phy/dp83867.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - net: phy: dp83867: Remove unnecessary (void*) conversions
    https://git.kernel.org/netdev/net-next/c/86c2b51f203e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


