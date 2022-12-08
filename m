Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589B5646833
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiLHEU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLHEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FBD93A77
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 20:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7A54B8227A
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 869F0C433D6;
        Thu,  8 Dec 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670473217;
        bh=rJP6NvNL1Qor4N6xl/X6UowgwnRPkffLD1RuGfKlYr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q86pZSnnShcEKdoXVFzR4Wi1b1m3QDgOZuzE0ZG6TYXqnzlLD7mIOn8iWcQW9icS1
         bFqxTJgrQe3Lc8u10WmurHAaDRFAXXB0OWCZVdKOHYaMqzPPULPrOUYWJF7pQcTXsO
         55SNyBiEZT9/YHxXIsHXAxm/l7/4/d8/MJVmaIuTJhInIMcgAr7sbia+0qi+u/EvmG
         FlBoMYRyUpIbz2gMQ7toawQ/89si9zb/FtNBYkra6DkfIga56fcqCsORe66QU3UvfU
         JxHnrPd982M/6VX8doeJaiUIx6M7QEa3PT+MlalKeIaQw/BRdWpe0sY1aiJTbH0fNI
         N70DoxJdhcvyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 700BCE4D02D;
        Thu,  8 Dec 2022 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V4 0/8] devlink: Add port function attribute to
 enable/disable Roce and migratable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047321745.25577.15054374693408227752.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:20:17 +0000
References: <20221206185119.380138-1-shayd@nvidia.com>
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
To:     Shay Drory <shayd@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        danielj@nvidia.com, yishaih@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com, parav@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 6 Dec 2022 20:51:11 +0200 you wrote:
> This series is a complete rewrite of the series "devlink: Add port
> function attribute to enable/disable roce"
> link:
> https://lore.kernel.org/netdev/20221102163954.279266-1-danielj@nvidia.com/
> 
> Currently mlx5 PCI VF and SF are enabled by default for RoCE
> functionality. And mlx5 PCI VF is disable by dafault for migratable
> functionality.
> 
> [...]

Here is the summary with links:
  - [net-next,V4,1/8] net/mlx5: Introduce IFC bits for migratable
    https://git.kernel.org/netdev/net-next/c/df268f6ca7da
  - [net-next,V4,2/8] devlink: Validate port function request
    https://git.kernel.org/netdev/net-next/c/c0bea69d1ca7
  - [net-next,V4,3/8] devlink: Move devlink port function hw_addr attr documentation
    https://git.kernel.org/netdev/net-next/c/875cd5eeba96
  - [net-next,V4,4/8] devlink: Expose port function commands to control RoCE
    https://git.kernel.org/netdev/net-next/c/da65e9ff3bf6
  - [net-next,V4,5/8] net/mlx5: Add generic getters for other functions caps
    https://git.kernel.org/netdev/net-next/c/47d0c500d76c
  - [net-next,V4,6/8] net/mlx5: E-Switch, Implement devlink port function cmds to control RoCE
    https://git.kernel.org/netdev/net-next/c/7db98396ef45
  - [net-next,V4,7/8] devlink: Expose port function commands to control migratable
    https://git.kernel.org/netdev/net-next/c/a8ce7b26a51e
  - [net-next,V4,8/8] net/mlx5: E-Switch, Implement devlink port function cmds to control migratable
    https://git.kernel.org/netdev/net-next/c/e5b9642a33be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


