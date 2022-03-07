Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EBA4D0B72
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbiCGWvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiCGWvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:51:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B436F497
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1FF6119B
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03C8AC340F3;
        Mon,  7 Mar 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646693411;
        bh=Tjt+GlGgamz0dKagtjVwMwCrQP8ARVAM0CP8Pw8dHq8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tAtffBTs2HsLTq304HkScyN7G0Bp0BzZkGOsX4F2iKTwyWBw46YZsVBWUYtA8ygkU
         c1PCh1yLPVq/47bZSK5NQBgHpnQ5PZOGiKxe7R35FFSFJMOhrpAW/nwbeC38HMnaYf
         /cKe0BSgPYZpFgHsOfhUU/htOH5FxI3vETYM7n38Uc0PHlSv1sDq1d0hs5IGMFVZN2
         wtfJyWwV5EcmJHd4jDhPPDjAlbbeOrfQvy/W5gAbMKuL+QEDrTrT8v/FVYlbaixYn6
         LwAnh7bKKLWe7Qrr4yvNb5MZu6ABPWLkUgfdi/98A8WvqLYHKgC73DRYnLfcLdfu2h
         dGTeeCSnJiQ1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1FCBF0383A;
        Mon,  7 Mar 2022 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v1] tc: separate action print for filter and
 action dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164669341092.30729.11461857343532556078.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 22:50:10 +0000
References: <1646359300-15825-1-git-send-email-baowen.zheng@corigine.com>
In-Reply-To: <1646359300-15825-1-git-send-email-baowen.zheng@corigine.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, jhs@mojatatu.com, victor@mojatatu.com,
        simon.horman@corigine.com, roid@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Fri,  4 Mar 2022 10:01:40 +0800 you wrote:
> We need to separate action print for filter and action dump since
> in action dump, we need to print hardware status and flags. But in
> filter dump, we do not need to print action hardware status and
> hardware related flags.
> 
> In filter dump, actions hardware status should be same with filter.
> so we will not print action hardware status in this case.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v1] tc: separate action print for filter and action dump
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a93c90c7f2d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


