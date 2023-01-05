Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE35865E80D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjAEJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjAEJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7C656887
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63D8BB81A29
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BDE1C4339E;
        Thu,  5 Jan 2023 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672911616;
        bh=9NEu7o6c0HfCnZg76dWuFLRbTZO7fXCvzVah45tNWHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p1a1uLfmrILfYpccrkpAbvV4/ESqd7bUds3s02spnVti7l0yYnSGIZsofmoLWCb4M
         Ni07sKCAWKvFutNn2izEAPzG+vX2yhbtg7SwtyMXzMnNf02IzYAEUQ0uwxEKwNmJur
         9FbIDw7BLhn7wJE7an4jx639fDKp+rMmCw39U0RIDNNY4ziOrNCGZI9tASgyWgPlKm
         2NGt3eOy34r/1YrZVv+pb93GJXXk/26MsL7oF/SjkZBZ4s0tzHPDszNex86NmTCvO5
         Xq0h5pX97FcewGXCKW92PN+VUQyLw5tjKuWdr77sUMmCR0Z5GLDTZ0gY4jlm2qOMz2
         QJSnEkcglB+2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02EB3E5724A;
        Thu,  5 Jan 2023 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] caif: fix memory leak in cfctrl_linkup_request()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167291161600.31821.9458699342990494359.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 09:40:16 +0000
References: <20230104065146.1153009-1-shaozhengchao@huawei.com>
In-Reply-To: <20230104065146.1153009-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com, sjur.brandeland@stericsson.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 4 Jan 2023 14:51:46 +0800 you wrote:
> When linktype is unknown or kzalloc failed in cfctrl_linkup_request(),
> pkt is not released. Add release process to error path.
> 
> Fixes: b482cd2053e3 ("net-caif: add CAIF core protocol stack")
> Fixes: 8d545c8f958f ("caif: Disconnect without waiting for response")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] caif: fix memory leak in cfctrl_linkup_request()
    https://git.kernel.org/netdev/net/c/fe69230f0589

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


