Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772F04AF310
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiBINkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiBINkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:40:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797CFC061355
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34368B81E61
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E560BC340E7;
        Wed,  9 Feb 2022 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644414009;
        bh=T1cp02KTnTJjhwg9p/dszqcveWz271Fj69NoLiOoLtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JaWvqV8JKNAE4HXxbh2YGDvWgYhXP/JY/0QQhqH7aYtPXAqfAKdXb41WzN4RKrbqf
         fsVuxITcYhmPJ7BTokf/s6G3lPu8oX4hzGxoia2APl8Kuqf4tWIyzxMvaq6pcn18nX
         4rvwKhyq5bJ8F3f7vxLqoYPEO7gty/fkh8sB97N/SiS/thEgSfjik1s+xbxl+z80ls
         c6Zu+rv0QbkOhSYr010kcB9985FttaTkDiUpt2qcHLU/ESghMfrqQPPLz9pnMRy32J
         I7GBP+LaCsOlNblzFxBxTpT2tYPtjAV6J0cqeMEgrP4UVyPU1Kk0INkWUurgjAfC2N
         FF79qnTzNqS5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4632E6D458;
        Wed,  9 Feb 2022 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] vlan: fix a netdev refcnt leak for QinQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441400986.27404.8808199212918206130.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:40:09 +0000
References: <cover.1644394642.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1644394642.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, william.xuanziyang@huawei.com
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 03:19:54 -0500 you wrote:
> This issue can be simply reproduced by:
> 
>   # ip link add dummy0 type dummy
>   # ip link add link dummy0 name dummy0.1 type vlan id 1
>   # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
>   # rmmod 8021q
> 
> [...]

Here is the summary with links:
  - [net,1/2] vlan: introduce vlan_dev_free_egress_priority
    https://git.kernel.org/netdev/net/c/37aa50c539bc
  - [net,2/2] vlan: move dev_put into vlan_dev_uninit
    https://git.kernel.org/netdev/net/c/d6ff94afd90b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


