Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5CF5ABD03
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiICEa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiICEaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52AC52466
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 21:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D9DDB82E52
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 268F5C43141;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662179421;
        bh=y9NpQkRPYVLVOfkn6fZPmjxLRwm04FeFfEHqGh91tFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ck9id3hCn5b98nmw1QAdppCP2qpcbAtxdX3zLK9OjCjedkphapDXgJCD6lPjrZyPs
         raYU907lyFPhKBOm6lwUXLyxjymxOQqeIHPuKYzqvT0K5v/xvH0OVK0tFEH7ibVzpX
         gEZ82omLnkVsTygY5jqaj2nS6yCwH2KMBGPjZo8zr2PdsZMGo3YaRoeRGDjJg1sdfV
         i44IKkx3jGAVXw0qgei7wfIqhvSwtcQ5JXx3dt3oMRmOQ7LbzQKCNq416VIEKVFW4T
         CWZ5J5zxuRSv5dL71it9/+MCPcxT4Zp++LfiCJ+aFh8LZq6QsWvAxezzJjRgdBHbG9
         alldka0PtCLpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10D66C4166E;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: lantiq_etop: Fix return type for implementation of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217942106.8630.14243914478679286421.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:30:21 +0000
References: <20220902075845.53721-1-guozihua@huawei.com>
In-Reply-To: <20220902075845.53721-1-guozihua@huawei.com>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 2 Sep 2022 15:58:45 +0800 you wrote:
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this might get
> cought out by CFI and cause a panic.
> 
> ltq_etop_tx() would return either NETDEV_TX_BUSY or NETDEV_TX_OK, so
> change the return type to netdev_tx_t directly.
> 
> [...]

Here is the summary with links:
  - net: lantiq_etop: Fix return type for implementation of
    https://git.kernel.org/netdev/net-next/c/c8ef3c94bda0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


