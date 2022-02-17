Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6D4B9819
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 06:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiBQFUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 00:20:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiBQFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 00:20:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775D52A5993
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 21:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE647CE2A98
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 444DAC340FA;
        Thu, 17 Feb 2022 05:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645075212;
        bh=w2TN0nbQExvtSLOe9MVbkPl15ksC++6eBAlOoI+xVk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JYem4U4GGrkoJZxTb7YQwNgmKGT2v+yhkBqJqOcfuFgYNwmOUwjMJDxscesCCcQuM
         mCfTKBuWGDymXUFvc6WtdAd1H03I2yDZLc2rpnRHxE5Y978Fn/nfb+hJfJzSQL0FDI
         KKcertPCWLAcwZQicAMD5E+H1hJBOhpFRSPzri9ad1/dOfX2aTCdv+04+lTGNC7x/y
         BkPcmFzEHhjSIAbDXS6a6xG5Ea5pAiEOQ8MRD/w+8jMrS7J0v6NwawXCGZXTUT1uP3
         CrewrHh173egKRwx/RxEWpdx2qwIhilmR7LnX2oYKwylzX5SylQcQOwXXbe3k8+5ye
         VF90gfr2E+bsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33617E7BB04;
        Thu, 17 Feb 2022 05:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: rtnetlink: rtnl_stats_get(): Emit an extack for
 unset filter_mask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507521220.4843.7374534171349605404.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 05:20:12 +0000
References: <01feb1f4bbd22a19f6629503c4f366aed6424567.1645020876.git.petrm@nvidia.com>
In-Reply-To: <01feb1f4bbd22a19f6629503c4f366aed6424567.1645020876.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, idosch@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Feb 2022 15:31:36 +0100 you wrote:
> Both get and dump handlers for RTM_GETSTATS require that a filter_mask, a
> mask of which attributes should be emitted in the netlink response, is
> unset. rtnl_stats_dump() does include an extack in the bounce,
> rtnl_stats_get() however does not. Fix the omission.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: rtnetlink: rtnl_stats_get(): Emit an extack for unset filter_mask
    https://git.kernel.org/netdev/net-next/c/22b67d17194f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


