Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A895C617538
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiKCDuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKCDuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8CA1580B
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 20:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B361361C5E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A5B2C43141;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447419;
        bh=5OGtEYV5MkEiCbODbHQAtBmGdHcjVk8OgMLB8+VkgRM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nnRFMwKw/KkR9yJSOrcEWC9GD4jkOLzkQr8Pa55zBUgXOqQrc+e/AhcBBJVhhgPfe
         302jOnZw+b6cVSicu1HdxfK6UHDUc0btUuLp/gsmywxz32QHoNuS+by9bD4nhbAGQp
         ZkCjQDaJTN6w/0yMt6n8mbSi6vEOhqmO6NgcvMxL61IiFN+cbd8EoDvL3lhqAfSXwI
         +iCSMM/BRgpNw6DsWeWZh2yu9j7mXAFvLNs1wguh7KcjJUXIBmhSvpjd6dLfTmH/0D
         2bzbK9nmJJJDAHRkhndHd9MG69FJrFSsI6L6lfcft6ZQyipfL5yFLCPtxKwNupx5pw
         aQRFsrZnmK5vA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00218E270D3;
        Thu,  3 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] rocker: Two small changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741899.12191.803317220019437998.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:18 +0000
References: <20221101123936.1900453-1-idosch@nvidia.com>
In-Reply-To: <20221101123936.1900453-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jiri@resnulli.us,
        vladimir.oltean@nxp.com, netdev@kapio-technology.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Nov 2022 14:39:34 +0200 you wrote:
> Patch #1 avoids allocating and scheduling a work item when it is not
> doing any work.
> 
> Patch #2 aligns rocker with other switchdev drivers to explicitly mark
> FDB entries as offloaded. Needed for upcoming MAB offload [1].
> 
> [1] https://lore.kernel.org/netdev/20221025100024.1287157-1-idosch@nvidia.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] rocker: Avoid unnecessary scheduling of work item
    https://git.kernel.org/netdev/net-next/c/42e51de97cb4
  - [net-next,v2,2/2] rocker: Explicitly mark learned FDB entries as offloaded
    https://git.kernel.org/netdev/net-next/c/386b4174827c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


