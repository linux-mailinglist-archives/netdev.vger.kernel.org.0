Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3F16EA22A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbjDUDK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjDUDKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FD610C1;
        Thu, 20 Apr 2023 20:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 541B7617DB;
        Fri, 21 Apr 2023 03:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA63BC433EF;
        Fri, 21 Apr 2023 03:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682046621;
        bh=+twREB/d9bGk5DIfTsqzXiqYTl/7bAJYoU/XbbE+XYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J9D7XBJQkaTptwa8IUCHDNxjA4QhVKhFCgWKnGWgrlw3ccmJmpkf2ql+sSG1yxMmv
         wQCB0KWoz/+uKUiZiXCSgwB+V8BkZsNwxJ0q+esZd9q/FRkSylgwc9yUFqnUzAGXP8
         y7z+PGhkXAarnhjisUNIdT1UyEJgx5lqKyQjq4eGArmN7TG/EclmgJUFWZfHwct7dz
         469Tg05RDeUdyKkc0VADyLMTZ7uEb55VSMZ7baMSKE/eP4DicB57hmxNAWlmMiA5Lu
         EmwYwkDuVKdiFeskclGqF7gYyzfdkIpWy5Jigkfh67HKIVeUe3bKaZqd1mLJq/ZwJF
         xWAKVwtGZL56g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C048E270E2;
        Fri, 21 Apr 2023 03:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2] wwan: core: add print for wwan port attach/disconnect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204662156.31034.17690821763548569833.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 03:10:21 +0000
References: <20230420023617.3919569-1-slark_xiao@163.com>
In-Reply-To: <20230420023617.3919569-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 10:36:17 +0800 you wrote:
> Refer to USB serial device or net device, there is a notice to
> let end user know the status of device, like attached or
> disconnected. Add attach/disconnect print for wwan device as
> well.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] wwan: core: add print for wwan port attach/disconnect
    https://git.kernel.org/netdev/net-next/c/787e6144aef7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


