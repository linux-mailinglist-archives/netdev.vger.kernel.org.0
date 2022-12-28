Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6FF657636
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 13:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiL1MAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 07:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiL1MAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 07:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CF21180E;
        Wed, 28 Dec 2022 04:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90214614A8;
        Wed, 28 Dec 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEDD8C433F0;
        Wed, 28 Dec 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672228817;
        bh=+8P4e/h2rF3oG9WyG4ReZdjLiC3bMlya4yQOx9rG0os=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cdzirmop38QX8gkRsCmG3N8ZqWhy+LaaWUVaePr9UjdiShWN2YJQSr5gwhmgMwHmY
         o0i+eDik5hBB29rq0GOKCkkrhB5BD/j4bkpRh+T6ue/O6a2lQWjAVKqnVKJefx0zPJ
         PTnVSU1BIBdXKNkbH8SVVp036P8a1M4HqDi5Q+Xjur43QXKp1fUW1BEV5Icxexx5At
         A4pekYtEhuCYgx1UnB9A7OvFQElDKnGqZGRTY/UMD1gnKk/lgyQJY7VHceB/c9/K0p
         vluljdZRbR2yuaY4KgiChD34dtuME6x1c/ZCCfU9Q5pRZLBt7x7fK1VQ7V+IayLj5B
         cMjPiMJcxWmUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF2ABE50D70;
        Wed, 28 Dec 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] net/ethtool/ioctl: split ethtool_get_phy_stats
 into multiple helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167222881683.20935.9855134928646735585.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 12:00:16 +0000
References: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
In-Reply-To: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, sean.anderson@seco.com,
        jiri@nvidia.com, wsa+renesas@sang-engineering.com,
        korotkov.maxim.s@gmail.com, gal@nvidia.com,
        mailhol.vincent@wanadoo.fr, trix@redhat.com, marco@mebeim.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Dec 2022 14:48:22 +0300 you wrote:
> This series fixes a potential NULL dereference in ethtool_get_phy_stats
> while also attempting to refactor/split said function into multiple
> helpers so that it's easier to reason about what's going on.
> 
> I've taken Andrew Lunn's suggestions on the previous version of this
> patch and added a bit of my own.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
    https://git.kernel.org/netdev/net/c/9deb1e9fb88b
  - [net,v2,2/3] net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
    https://git.kernel.org/netdev/net/c/fd4778581d61
  - [net,v2,3/3] net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers
    https://git.kernel.org/netdev/net/c/201ed315f967

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


