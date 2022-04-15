Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B56502836
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352247AbiDOKXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352276AbiDOKWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCE6BB090;
        Fri, 15 Apr 2022 03:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF526222B;
        Fri, 15 Apr 2022 10:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 753ABC385AF;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018014;
        bh=kodpLuvtK8s5higBVJpvR6w9BbhTiCvnfC7n+wSImDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QXDg0VzM6Idnc64pXRPJoQm5DsySFwyMl/4hlEUHGNZpz3IpW2JSLCvDB8VVTXftd
         zhV4++KYHo3batYvMHEUCBHPhqKpvISmVwwatrSRaR9pMxFdwey5uEsjqlYgPNEYyD
         rx9FbzgzEtoZrJbc/s8qKLkuEWzPv9eU1kFjcZK1WDHEIlH5lJ+fTAjkTPmwRoZvpT
         AqiFuM99FFzRJrwRUIIRPsD53coQxn+LIhGMpddTw/wbPvubfA2akW5Fx4CvXo0+OO
         1Zm4j1Xpi/lMch7okYru2Lm1i9Ov4aI5GNnwYCqOkJGur7JQ6nXDLy42y82AEKeg+z
         vMVGdq77J7tqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E4D4E6D402;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpsw_new: use pm_runtime_resume_and_get()
 instead of pm_runtime_get_sync()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801438.12692.16273139621534267495.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:14 +0000
References: <20220413093529.2538378-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220413093529.2538378-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
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

On Wed, 13 Apr 2022 09:35:29 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpsw_new: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
    https://git.kernel.org/netdev/net-next/c/c557a9ae4960

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


