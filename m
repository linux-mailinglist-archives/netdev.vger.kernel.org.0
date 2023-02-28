Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301CD6A503E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 01:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjB1Aqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 19:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB1Aqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 19:46:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609E11E9DD;
        Mon, 27 Feb 2023 16:46:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E971560D57;
        Tue, 28 Feb 2023 00:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A1A5C433D2;
        Tue, 28 Feb 2023 00:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677545196;
        bh=bwOp4yx50VaNVXym63VvR5fZ9BdHxXUqyY+m544YWks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YxPm8N3ab3cZpy5YrbfoDNAjYJQuo4IGt6Gy1eCb8mGB3+xd78v9Fg+z6M51hlF/X
         2bQkOiCVqR+FS/3g2jF78ht/6YMNWjO1Fxip6D0fKTv/BPRUp+/an8tlj6AVMLI+gR
         IDFk8+emzDuiO/R5Cyf2JDAw1Ig2r/XLWXisPn9ooTqvpLlechPB58Vg+xfZ3DqX7L
         601gFyyCclePHqR5sNpSJ8V7olJPmb5aJq0WQLTQa79lJl0hUfSTAQHQkcg4xtuvD2
         GvC3rDtSj/jIjcW8qiiKHcJnJlXDbGLC5Uc5vLw/dAhtu1SgjD3cR/LRmbHBdXXVi+
         x05PP8BFuYX1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29902E1CF31;
        Tue, 28 Feb 2023 00:46:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xen-netback: remove unused variables pending_idx and index
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167754519616.16363.18059153345889882200.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 00:46:36 +0000
References: <20230226163429.2351600-1-trix@redhat.com>
In-Reply-To: <20230226163429.2351600-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 26 Feb 2023 11:34:29 -0500 you wrote:
> building with gcc and W=1 reports
> drivers/net/xen-netback/netback.c:886:21: error: variable
>   ‘pending_idx’ set but not used [-Werror=unused-but-set-variable]
>   886 |                 u16 pending_idx;
>       |                     ^~~~~~~~~~~
> 
> pending_idx is not used so remove it.  Since index was only
> used to set pending_idx, remove index as well.
> 
> [...]

Here is the summary with links:
  - xen-netback: remove unused variables pending_idx and index
    https://git.kernel.org/netdev/net-next/c/ccf8f7d71424

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


