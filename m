Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FEB55A50F
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiFXXuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiFXXuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6228BED5;
        Fri, 24 Jun 2022 16:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21549624B7;
        Fri, 24 Jun 2022 23:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F3DAC341C0;
        Fri, 24 Jun 2022 23:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656114613;
        bh=f02DpCL2aEk54woWtJBWbI5HYdNEaHuOFuGc4q63xng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EeddxGEwiiVoC7pnf6+NkdGSjFN2CBTL7NEMe7HTPsFJrQiueo3fce5XZlU7YyWyn
         bE1mlfUAVO94FM4ykdsISv1KQ/8KWVqbHndsjtzfkYOj3dHyhzuhsMjveAF4qWWtWq
         dy1TPLll1VGtps1vVnoy7NzxJ1fUyf73bujfx0Ml0yB8eaBB3pDIVbEtd2ppOwjVia
         keZ5Q3aEwf5Yvo69kx/iTwqvCGcZyvdNCC5Pi7ZlqLqHnbiLKzqmUPQ6OVxKRMgQCh
         C04vFCB9bTCTYvY2iHdm2WkTpk9JjmhpZKSo7Nu73y/IJLDwcDM5eaDrAlGvdw1lp4
         pPS0G9AGkWQxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AED9E85DBE;
        Fri, 24 Jun 2022 23:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] net: dp83822: fix interrupt floods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165611461315.19940.5599143312649150183.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 23:50:13 +0000
References: <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
In-Reply-To: <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 15:46:43 +0200 you wrote:
> The false carrier and RX error counters, once half full, produce interrupt
> floods. Since we do not use these counters, these interrupts should be disabled.
> 
> v2: added Fixes: and patchset description 0/2
> v3: Fixed Fixes: commit format
> 
> In-Reply-To: YqzAKguRaxr74oXh@lunn.ch
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")

Here is the summary with links:
  - [v3,1/2] net: dp83822: disable false carrier interrupt
    https://git.kernel.org/netdev/net/c/c96614eeab66
  - [v3,2/2] net: dp83822: disable rx error interrupt
    https://git.kernel.org/netdev/net/c/0e597e2affb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


