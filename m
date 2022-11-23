Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E292F634F32
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiKWEwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiKWEwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:52:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A951D9079;
        Tue, 22 Nov 2022 20:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E4561A5E;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32618C43470;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179129;
        bh=wxDwk73uwFKgFrxoQsw5hGTNazQHaehqQpWwfD32QgA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uOHA3a5vPNch1JujhiShNlwP+g6zg7HPjhiL2K3HN2VH40KOJVgQJq/KZqpAIWghJ
         HPBwFGYa4TIYcex1ou27MBuKXjOL/324C+gb4GVgBbZ2FAYXtIpi1D/sbecQR1tPOZ
         5HBxeXC9eAxOtjBA+wXILPiqiPBUAZBeN88wdatHfmFNiYKUQu7FurxR055119/WnQ
         vOMPzc7ARMEbCNyHmHhw0MrpXK7ErTOTNyEGXw8GMGCcBewnnL2Wv+cNY7ufE+u3xW
         C+9y5h8N1jDC2Tbk1XwAqItDby9g6FBEQoYYbu3urLoOZurKgfZoVqvOhuSf0v766C
         obkFL2JRHVEKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C94CE50D6E;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: remove redundant health state set to error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917912903.11566.16202598383366722432.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 04:52:09 +0000
References: <1668933412-5498-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1668933412-5498-1-git-send-email-moshe@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 20 Nov 2022 10:36:52 +0200 you wrote:
> Reporter health_state is set twice to error in devlink_health_report().
> Remove second time as it is redundant.
> 
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
> ---
>  net/core/devlink.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] devlink: remove redundant health state set to error
    https://git.kernel.org/netdev/net-next/c/815bc3ac75e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


