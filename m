Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88868FFAC
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBIFMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjBIFKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A74A243;
        Wed,  8 Feb 2023 21:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA058B81FCE;
        Thu,  9 Feb 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85E44C4339B;
        Thu,  9 Feb 2023 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675919418;
        bh=eDI57/LzqUVY+qTf/jG2cQsw1+OgqTTTCWIWL/hRgKo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+6hn8mRUi4+wEf9sN3E0ZtgA81FrUxabXw+OPcwv3RPa7v+r2HyCpctLo0B3E+fa
         +1YQowlRtIx1k+d8HrbTuQfRNBeQMMdnaw/YkLubtlMa0kbODI+706h8EJnRCN3jJi
         bpr4Uh9e/Qyi/ZSY/VH7qUE3Oz15RQtdgTp833/nVBJbXFQ/Goixir8JorGK18qnBt
         8aUQsDIOcVuS6r27CI9F6aWVZsIrKAqX0TmOjqbvIzHjbEhGZbW/CzkeVJMlUK7OBr
         EA8c+UpdZE7JjPfR9FnLdzYrtq585ZxCldX6W2OlGlEeDXD9KT8MM7MMpNzzAQcqUL
         Ta23jfB4wRI0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6AAFAE21ECB;
        Thu,  9 Feb 2023 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167591941843.2876.6131720358641221887.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:10:18 +0000
References: <20230208005626.72930-1-saeed@kernel.org>
In-Reply-To: <20230208005626.72930-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jgg@nvidia.com, saeedm@nvidia.com,
        linux-rdma@vger.kernel.org, leonro@nvidia.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Feb 2023 16:56:26 -0800 you wrote:
> The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:
> 
>   Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-next-netdev-deadlock
> 
> [...]

Here is the summary with links:
  - pull-request: mlx5-next netdev notifier deadlock 2023-02-07
    https://git.kernel.org/netdev/net-next/c/9245b518c89f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


