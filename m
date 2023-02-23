Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5A6A0647
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbjBWKar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjBWKao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:30:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8234ECEF;
        Thu, 23 Feb 2023 02:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B55A61689;
        Thu, 23 Feb 2023 10:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABC0CC4339C;
        Thu, 23 Feb 2023 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677148216;
        bh=Y9tEj5S8MFTKwz7UntsPwS+3EshDQz0ehhziSrDe5kQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dXAcm/+9S8JrWbAppeeGQtMX0A8pRqoDl/Vbo6kcgSMJR3G04CbNBKYzyG7xq95Hh
         iXcMkfhGt69OqPl8wePs/9F8xH9MdbkpLSjcp+RkDW7aWKW6RlnRGncsvPXa0gv5Es
         +o9i1itgE7tF6XW1bwrfzvnoloIzL4H4JpSKxaq9/r3tOG6fkSl0To0/JBsoH37apN
         olHvnU+rHjBQAgcaJ3wXIjLYHPoWoNR1OGlHNtfnw+Rao2tMit5lmPxKqlC/dGDC6K
         m7p9hSpWCMhHS4vkJ1ZIZqD5fQNT8jNvScwGWOXnqINwbfjabwd7S1kiNxopSDPDC/
         AQ5s73fihRHOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93609C395E0;
        Thu, 23 Feb 2023 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net/mlx5: Fix memory leak in IPsec RoCE creation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167714821660.3301.1148990623254072691.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Feb 2023 10:30:16 +0000
References: <a69739482cca7176d3a466f87bbf5af1250b09bb.1677056384.git.leon@kernel.org>
In-Reply-To: <a69739482cca7176d3a466f87bbf5af1250b09bb.1677056384.git.leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, phaddad@nvidia.com,
        edumazet@google.com, linux-rdma@vger.kernel.org,
        markzhang@nvidia.com, netdev@vger.kernel.org, pabeni@redhat.com,
        raeds@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 22 Feb 2023 11:06:40 +0200 you wrote:
> From: Patrisious Haddad <phaddad@nvidia.com>
> 
> During IPsec RoCE TX creation a struct for the flow group creation is
> allocated, but never freed. Free that struct once it is no longer in use.
> 
> Fixes: 22551e77e550 ("net/mlx5: Configure IPsec steering for egress RoCEv2 traffic")
> Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,v1] net/mlx5: Fix memory leak in IPsec RoCE creation
    https://git.kernel.org/netdev/net/c/c749e3f82a15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


