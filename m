Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A54C3DDB
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbiBYFar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiBYFap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:30:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1AF25D6E9;
        Thu, 24 Feb 2022 21:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A502BB82B42;
        Fri, 25 Feb 2022 05:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41C57C340F2;
        Fri, 25 Feb 2022 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645767011;
        bh=pW4csDuDuyivgVLjBOBf/hwjeriH2QhbmoWSytq7yfI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rC7m3OXga3qEh1yboBa87MVtDITn8/qHRXWCzaPDbY5TcO24tnl+yVE4Z9xg4LCkN
         aNSQ/7TMRZgvux4UN2fyttPFlw9U+V9sYXmKyILdaQr9F6mybtPKNNpjDSfbY1/RfO
         qPbhtR12qgkdDi74Tha0i2PpqWRYu/22bOJ65WmLI8tPDV+eBSAcCLjA8ObcYgKwcM
         hq3jW0yD63tPoq2lWFiea3aZgd2xFuHzUp2gLhHmt1MxcQf3X3DwkH9RDOUizKXkfL
         uD3f8J+KzgI5TVH+LcF146W78F9xusnI5UuU79zgR4SLTBfPZa5MVcei7YX6taiuMq
         ZQq/Wf5cxVW4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2ADC3E6D4BB;
        Fri, 25 Feb 2022 05:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: marvell: prestera: Fix return value check
 in prestera_fib_node_find()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164576701117.8286.7470592072083909153.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 05:30:11 +0000
References: <20220223084954.1771075-1-yangyingliang@huawei.com>
In-Reply-To: <20220223084954.1771075-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, tchornyi@marvell.com,
        yevhen.orlov@plvision.eu
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 16:49:53 +0800 you wrote:
> rhashtable_lookup_fast() returns NULL pointer not ERR_PTR(), so
> it can return fib_node directly in prestera_fib_node_find().
> 
> Fixes: 16de3db1208a ("net: marvell: prestera: add hardware router objects accounting for lpm")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: marvell: prestera: Fix return value check in prestera_fib_node_find()
    https://git.kernel.org/netdev/net-next/c/d434ee9dee6d
  - [net-next,2/2] net: marvell: prestera: Fix return value check in prestera_kern_fib_cache_find()
    https://git.kernel.org/netdev/net-next/c/37f40f81e589

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


