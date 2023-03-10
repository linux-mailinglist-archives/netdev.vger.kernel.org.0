Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F223E6B375C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCJHac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCJHaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF9EDB57
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE4FAB821D0
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AC17C4339C;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433419;
        bh=lspj8XMnRoARm+Ye57OhYX93XoQuiY6t6YH9WXT9dEU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=poDPI3RPP6vLqtKLDWoJHA32ZGXuSltJhuJV85CBxV2vNJCm6SiKd4GmSn+4QkTcI
         bdN0uJBzr4HjfL6//hJw0/Huyxmqd8+pxJ9UWircuageY4WNG0UaBuaAbgRNXeMrUs
         eAm85flwwQrWWZ4rI+qy6nD2wkHdQ5IBo0TXtTqpI1LfPhXVJjCHRresKEo/BacIbF
         PrH5KDO0dcAVMPA8jZJvSE9wL5XgeOIRf/N+IKWHae3iR6Zu+L3mrkThEPNHlvoNnY
         +HwOESzUYrVaBy2Ney90VcZGzlRCNdAJJD0vRyhQe4LoQP6VmxjEkKsyVbXAQ/y1qs
         AQ+xkrOxgG9Zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CC69E21EEE;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: remove unused 'compare' function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843341944.20837.3743769137200736884.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:30:19 +0000
References: <20230308142006.20879-1-fw@strlen.de>
In-Reply-To: <20230308142006.20879-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 15:20:06 +0100 you wrote:
> No users in the tree.  Tested with allmodconfig build.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netlink.h  | 1 -
>  net/netlink/af_netlink.c | 2 --
>  net/netlink/af_netlink.h | 1 -
>  3 files changed, 4 deletions(-)

Here is the summary with links:
  - [net-next] netlink: remove unused 'compare' function
    https://git.kernel.org/netdev/net-next/c/6978052448f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


