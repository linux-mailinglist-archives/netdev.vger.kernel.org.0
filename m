Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23717630B0A
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiKSDUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKSDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526E22A953
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA41062530
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39580C433C1;
        Sat, 19 Nov 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668828016;
        bh=WrNWq66A33NIxRY7jVhtSQulqMyrS/rO1WpQZ4OedTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BE/2dQ7BIpU5chOtEoTkcxHEE3W4ZwuFOEybmIxiXMKbVwFa/k/Z6iwjdzEptNiZN
         mUi0OyMxXM06WPYt2fLmEhBagkclI8Nnbj9FRpPAAYMZ9vY30sxweltSvlAfOw5oCn
         483yPDzGQ3G9xp6OQ4eWhdwPyJ7VVy/WcT4nWnvA9SN4hHfpFwwNBOaiT074+rGxTq
         uKqwH62R5qnyNJzmtGduPcnXIjjuBTa+gCP7JQXcUCaQ+V2p4y/qvTlLgr+Gz3yACk
         aR/z0svanYH8wdbkCIUIY5qc8E876Rf2n3FffRvDt3JxAuRCFMX6cOgzK4eA/4YcOo
         F+M3zuvfQnLhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24D95C395F3;
        Sat, 19 Nov 2022 03:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: remove the flex array from struct nlmsghdr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882801614.12875.6125141397212888728.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:20:16 +0000
References: <20221118033903.1651026-1-kuba@kernel.org>
In-Reply-To: <20221118033903.1651026-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, keescook@chromium.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, llvm@lists.linux.dev
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

On Thu, 17 Nov 2022 19:39:03 -0800 you wrote:
> I've added a flex array to struct nlmsghdr in
> commit 738136a0e375 ("netlink: split up copies in the ack construction")
> to allow accessing the data easily. It leads to warnings with clang,
> if user space wraps this structure into another struct and the flex
> array is not at the end of the container.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/all/20221114023927.GA685@u2004-local/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] netlink: remove the flex array from struct nlmsghdr
    https://git.kernel.org/netdev/net-next/c/c73a72f4cbb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


