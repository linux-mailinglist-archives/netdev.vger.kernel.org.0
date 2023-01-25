Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E853167AF17
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbjAYKAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbjAYKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483F553B2D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C976148A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE57EC433A1;
        Wed, 25 Jan 2023 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674640819;
        bh=bi4VczwQtqgKwsI9XdYsoe4hPlZtfmH7k6DAYYWKyV4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XrUbpHeWWt9xq7S6LpY7LQAwONFrlKL8fOH9WUwhwxQ21n5xVHGV32H9RnBF/XHDR
         M7OTiJsEeEq8fQvtkIMDds5hIvN8+Tlfo6FJ+vkXohc4EJ4eKNvm8dJLPlMhiatYJp
         3g6PkaKaf0QKvQRIY4Uk5LaprujBirhayzi86fCz5X+SicZghauRlLW7P+9uPA3mFD
         sNX9e/ho3SwmsGgJpBCTmVcG52VyZy1yeyBgLfwUfs+hOxILZO8ZBWzM31F0EpvZoL
         8A8pLlXMkCeXPKolItZyDIP5n7RCnJGHgu+9zSanYf9td+BArmas+dqxGT1+jLFd7M
         Q8gLCbyF3yjfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBB96F83ED3;
        Wed, 25 Jan 2023 10:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167464081882.8627.15300415632487392106.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 10:00:18 +0000
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mkubecek@suse.cz
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
by David S. Miller <davem@davemloft.net>:

On Tue, 24 Jan 2023 13:08:01 +0200 you wrote:
> In the following call path:
> 
> ethnl_default_dumpit
> -> ethnl_default_dump_one
>    -> ctx->ops->prepare_data
>       -> stats_prepare_data
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethtool: fix NULL pointer dereference in stats_prepare_data()
    https://git.kernel.org/netdev/net-next/c/c96de136329b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


