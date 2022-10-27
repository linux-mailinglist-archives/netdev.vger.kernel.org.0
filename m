Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB6660FFB8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiJ0SBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbiJ0SB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4EF98CB9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A05E06241D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA4C8C433D7;
        Thu, 27 Oct 2022 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666893619;
        bh=VsBbPxauLLNApzDVeINLwfVB6JTtAtjhdxQ9XVSe0pQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ih16Nv0Rb0dmBilE4Zwre2nXwlayMyv9oj0X6Dz8YCeMz9TYU9fBo1OFVJE5lRcPb
         BWwSn6PKO9CZjiYX3TvUh+OnKyAq+JSCcLu8GxCvX1+WYbRgwSSVYHOFi5EGFC5ATy
         fPxEqnPPuIIXGgq61yH3KsriTuTmoGAkizOzXJLu6mBuy9Ou9g+vxrckXPlf9wAClm
         SV9RDWCGmbHQZY/z0viHaNDT6Ypw8fJA6rUaeWSMMdBSmZNOCQZUuufZRH/g8dDb0y
         Py1SjXa4qlk+HYjTxPgAif5Fi6qDoNyGakeGrN83B5831CHLpcrgO1mil4qwmci4da
         udkKQtBAAyLGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8A91C73FFC;
        Thu, 27 Oct 2022 18:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v3 0/2] fix some issues in netdevsim driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689361881.21530.14825539415949662631.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 18:00:18 +0000
References: <20221026014642.116261-1-shaozhengchao@huawei.com>
In-Reply-To: <20221026014642.116261-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, dsa@cumulusnetworks.com,
        jiri@mellanox.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Oct 2022 09:46:40 +0800 you wrote:
> When strace tool is used to perform memory injection, memory leaks and
> files not removed issues are found. Fix them.
> 
> Zhengchao Shao (2):
>   netdevsim: fix memory leak in nsim_drv_probe() when
>     nsim_dev_resources_register() failed
>   netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports
>     dir failed
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] netdevsim: fix memory leak in nsim_drv_probe() when nsim_dev_resources_register() failed
    https://git.kernel.org/netdev/net/c/6b1da9f7126f
  - [net,v3,2/2] netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed
    https://git.kernel.org/netdev/net/c/a6aa8d0ce2cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


