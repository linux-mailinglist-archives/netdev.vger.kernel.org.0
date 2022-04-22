Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CC050C55B
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 02:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiDVXxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiDVXxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:53:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8662165D3B;
        Fri, 22 Apr 2022 16:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C956B832CC;
        Fri, 22 Apr 2022 23:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCA75C385AB;
        Fri, 22 Apr 2022 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650671411;
        bh=v0GEU8f647aDfOnHe6rDl7vHYkHF6lZNOzX+vulSejc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZLyF9wJO22xY+HTgq4Dq1U4B2rnf5qXQjtXjiZ/rwPuRrf/tgQjT3FzhYDJIhnNps
         nxy0o7mvz13I07cUA0NPjU0jY6JTWuk9+037dtWRxhxEaeSVYFSKcFBp7rswINhc5M
         xvULwHGqk0VNFeaRRbrWFKnT28PUKdNIg9Ban6aL+0RVYJsO74lMqL/xjp+NSliWvr
         E9oevqUpnsQqMyrW1SPEJBGxrZl7PZQMsz9y50RERyP8Rn5olC1g17AWotPI7prwW1
         CCgBIxCwJAkzBZ+yRv+owLUZG+/8Bjk6fcppulpDXFLTZ0oIa23xLksKICTU5j019W
         V+Lt8VqRxWZfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1825F0383D;
        Fri, 22 Apr 2022 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tsnep: Remove useless null check before call of_node_put()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165067141178.16286.5355771409782373166.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 23:50:11 +0000
References: <1650509283-26168-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1650509283-26168-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Apr 2022 10:48:03 +0800 you wrote:
> No need to add null check before call of_node_put(), since the
> implementation of of_node_put() has done it.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - tsnep: Remove useless null check before call of_node_put()
    https://git.kernel.org/netdev/net-next/c/f28c47bb9fd3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


