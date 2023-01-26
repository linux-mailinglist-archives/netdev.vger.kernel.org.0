Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A22367CE5E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 15:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjAZOkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 09:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjAZOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 09:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B7519D
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 06:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF8FB81D17
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D566BC4339B;
        Thu, 26 Jan 2023 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674744016;
        bh=Kx7smwdhFwBmvZ8hECseoV22inDQ2xU6yDXoHgZvdek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NJ8CxGNuTyQR3vDxS4lmcz59I2RCI9+LOE6g8NB0Nfbawetv06xVW1tUTiNqucc70
         neQ36h8PD+geo/mDUaVTO3LHl46fzlVT2TQ63FK1XcV5CqPQWUpxjYYVBxBRqup757
         8+m1GAjztSDs7yhiILHGBMUfpyCtMLrfbIRoDbJH1k0iOLQeV4WSIuhtaHOnKbU6wH
         hpLACxPVqOVZK+AcVVn3SK8Htro9iTEc1skDTpTwSFCsT/kyB5dPnDkxYIHfRMBWVh
         aYOBsrVNSi4jpBHblC1Jhc5UaNh29OLZu1be7hfOhccmb2rmDKcuFEucthq3qBSpfX
         4BHjkN5RXUrGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9740F83ED3;
        Thu, 26 Jan 2023 14:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethtool: provide shims for stats aggregation
 helpers when CONFIG_ETHTOOL_NETLINK=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167474401675.3279.4927410072236611100.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 14:40:16 +0000
References: <20230125110214.4127759-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230125110214.4127759-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, lkp@intel.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 25 Jan 2023 13:02:14 +0200 you wrote:
> ethtool_aggregate_*_stats() are implemented in net/ethtool/stats.c, a
> file which is compiled out when CONFIG_ETHTOOL_NETLINK=n. In order to
> avoid adding Kbuild dependencies from drivers (which call these helpers)
> on CONFIG_ETHTOOL_NETLINK, let's add some shim definitions which simply
> make the helpers dead code.
> 
> This means the function prototypes should have been located in
> include/linux/ethtool_netlink.h rather than include/linux/ethtool.h.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethtool: provide shims for stats aggregation helpers when CONFIG_ETHTOOL_NETLINK=n
    https://git.kernel.org/netdev/net-next/c/9179f5fe4173

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


