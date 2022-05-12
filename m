Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B5524DDC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354176AbiELNKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354179AbiELNKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A0E24F20D
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8003D62011
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFA8AC34118;
        Thu, 12 May 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652361012;
        bh=FrMeIW1CGhF911RUI7gyWcReX5v5NR/gnsT1qw0zgbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SKlbEY2soLyS+7bFFh8eLpjRFxL86gt5JB2rHSglIy63nmjUemvzfzWgLMRBpyBfI
         aGd+7oMHhwsKsCJzJYXq+hjO8UQBkESsusOdn0SvtbyDBpwnSRZx3uI+ITmcjw2jVy
         4YV4gVt64JtqKeafjkli9W0Fb/mJhv5nfvy/mzsL+uH70auINZ8Mb2l7cmjFkeCqpE
         T36SiTiT59Zlz7AXEHXHoTlJ35VT02GTK3MaNc6evoa01VrcFobJJiGVvuTy8YRc2u
         ZrhqaHs1bc/zuJNZ2TdHTY1No+qpz2/zuJc6mJjRIfXEx4luAIMYTGOjV7kXUitPnK
         59HiMbmQvA8gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C33EFF03937;
        Thu, 12 May 2022 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] *nfp: VF rate limit support 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165236101279.8258.12695691074457232630.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 13:10:12 +0000
References: <20220511113932.92114-1-simon.horman@corigine.com>
In-Reply-To: <20220511113932.92114-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, bin.chen@corigine.com
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 11 May 2022 13:39:30 +0200 you wrote:
> Hi,
> 
> this short series adds VF rate limiting to the NFP driver.
> 
> The first patch, as suggested by Jakub Kicinski, adds a helper
> to check that ndo_set_vf_rate() rate parameters are sane.
> It also provides a place for further parameter checking to live,
> if needed in future.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] rtnetlink: verify rate parameters for calls to ndo_set_vf_rate
    https://git.kernel.org/netdev/net-next/c/a14857c27a50
  - [v2,net-next,2/2] nfp: VF rate limit support
    https://git.kernel.org/netdev/net-next/c/e0d0e1fdf1ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


