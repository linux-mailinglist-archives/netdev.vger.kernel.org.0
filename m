Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1193668E72C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBHEbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjBHEa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:30:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB1D3CE04;
        Tue,  7 Feb 2023 20:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CAEDB81C0D;
        Wed,  8 Feb 2023 04:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15F7FC433EF;
        Wed,  8 Feb 2023 04:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675830619;
        bh=3ZkJSUIG6GK3cGNwLBOR1t5GeOC7jFReZFu/qQD7+KI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uB72mFnFkDvQCs4vdiKC0eUFJd8U7BjpJcaeB5hadytQ+2TtF5LnOyjIIPyohxCCT
         fXj9m8eYec+WUA9j+WcVpB0xn3djKdChz3WL23g+1wd4LgzTbyo6S8hTcfJUIB1ol6
         AVZCVEem6ZNB10AbX5b/8ZH29D0B56eb5XJB8S//eJ1GSMojugbRkTq3b37OvSNmKl
         2xxpuZq9gERtGvYsQwFK/d+Y89Y331t+tHWvoIgRFuNEFZgE0vER/+ueTxgY6aBKgM
         3A5TTnh1LpEKikzVz5zbmUm6leuUsYTf6CB2vSOAGnJtE17dIT7Pmi01+Vzb+yreYL
         iJUzyChI4m08A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0035FE524E8;
        Wed,  8 Feb 2023 04:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Fix memleak in health diagnose callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583061899.23427.370854463697916150.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 04:30:18 +0000
References: <1675698976-45993-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1675698976-45993-1-git-send-email-moshe@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@nvidia.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 6 Feb 2023 17:56:16 +0200 you wrote:
> The callback devlink_nl_cmd_health_reporter_diagnose_doit() miss
> devlink_fmsg_free(), which leads to memory leak.
> 
> Fix it by adding devlink_fmsg_free().
> 
> Fixes: e994a75fb7f9 ("devlink: remove reporter reference counting")
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Fix memleak in health diagnose callback
    https://git.kernel.org/netdev/net-next/c/cb6b2e11a42d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


