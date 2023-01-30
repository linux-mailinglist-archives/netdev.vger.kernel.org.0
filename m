Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8DF6807DA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbjA3Iup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbjA3Ium (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:50:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD673E4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA11160EF3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C31FC433A0;
        Mon, 30 Jan 2023 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675068617;
        bh=MnyrYw7W8vkWPKHjZA24jd7FREYHUjzRkr9F3W0SbxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pi4eNKB3MFfpGpR3EGMqV6xCvR/QWRPc3PXar0Nsfbgqw8BBnXxVlh9z9S8pMh0tZ
         06x2d47DvqA3KcSYMk19E4dEerdrvvS6btBZ6J1Tq23yrY19UIcScWTauluHJ7QRmV
         I/lSmyjGHoW4aFhj6hVXgxrE+giRbGrt8Z5BkTZqU+BwobPOLWEFPdYQW3Q2wmuV3V
         AWkzP/qukzg1RS0a0pU+hNRHr1KWg8ss5RJJQnm+e1wTL/klcIQASQhgBZ+zFWCUmj
         tX6CgG2M3uWMf+CJSHDj2+PLslLi+pxnokriJVCEAAo93UrC4kXQen1iM6tXQHt0fc
         zOibdputFTfWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E15FCE21ED8;
        Mon, 30 Jan 2023 08:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/3] devlink: fix reload notifications and remove
 features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167506861691.21040.7506893085716379938.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 08:50:16 +0000
References: <20230127155042.1846608-1-jiri@resnulli.us>
In-Reply-To: <20230127155042.1846608-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 27 Jan 2023 16:50:39 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> First two patches adjust notifications during devlink reload.
> The last patch removes no longer needed devlink features.
> 
> Jiri Pirko (3):
>   devlink: move devlink reload notifications back in between _down() and
>     _up() calls
>   devlink: send objects notifications during devlink reload
>   devlink: remove devlink features
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] devlink: move devlink reload notifications back in between _down() and _up() calls
    https://git.kernel.org/netdev/net-next/c/7d7e9169a3ec
  - [net-next,2/3] devlink: send objects notifications during devlink reload
    https://git.kernel.org/netdev/net-next/c/a131315a47bb
  - [net-next,3/3] devlink: remove devlink features
    https://git.kernel.org/netdev/net-next/c/fb8421a94c56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


