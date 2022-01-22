Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEF349699C
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 04:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiAVDkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 22:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiAVDkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 22:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65919C06173B;
        Fri, 21 Jan 2022 19:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E8D61B05;
        Sat, 22 Jan 2022 03:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F06AC340E4;
        Sat, 22 Jan 2022 03:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642822810;
        bh=5nPrRQxVOAj/qv9D1fN4iOkzeZZgJo5G6vEXoTa4yQw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ab0RniSxwvqxQZPVpBO4VKpkkZD5JQQUyCGNGdTM/3e25TjUlpmxWq3zjJ6lqfLTz
         zz14pnuKIjxWd39hObQBHx/bx06v+LiSiINFwBhsR5hlVE12PI8+A1kOMISwJeTtAK
         /P3xywjw8QgF3AvDxH1YDvu2EzCyQ3y9KAS1RGSAd5eIJJXULM6WDR3qkq0umDGTJU
         5WQ1hmjaEyeVjt+RfDtohxoqd+i+BcIfK3snJ5XXkLiIe6ttZWX2zyw5u0brVfezZ7
         kf2H2ruio5cKPB5A64bzIz6XZrND+V73+NG+8BqllnZyV0A7lEFCyQfGotC8MLoaxF
         cpLmqJp29Iixw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32D1CF60796;
        Sat, 22 Jan 2022 03:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mptcp: Use struct_group() to avoid cross-field memset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164282281020.32276.3955066233217706965.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Jan 2022 03:40:10 +0000
References: <20220121073935.1154263-1-keescook@chromium.org>
In-Reply-To: <20220121073935.1154263-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Jan 2022 23:39:35 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() to capture the fields to be reset, so that memset()
> can be appropriately bounds-checked by the compiler.
> 
> [...]

Here is the summary with links:
  - mptcp: Use struct_group() to avoid cross-field memset()
    https://git.kernel.org/netdev/net/c/63ec72bd5848

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


