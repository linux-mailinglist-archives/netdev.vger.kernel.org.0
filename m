Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD666BA9F7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjCOHu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjCOHus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029E16C1B7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14AB261BBC
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7209CC433EF;
        Wed, 15 Mar 2023 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866617;
        bh=d9zOgoD47BY0oq0/DGqs9Ms8OQe+x+BNigGfncvr0EM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=chE4oLKOUDQQ4aaK5gBjb7rWsWNR/rdbXm7FmwKf62MBgiEuM6bp3x7q82e/s2ZTD
         CirXrlYA57LAYBO0b0n1rWlJpEuKu5ZdyXFpnMEcqa5QkF7qMhJSBUd4YCSU3TOWZo
         AXLiwyaXyRrH47S3EPJ1Bae7MyUApT+kaPirro5VMaOGrVmjNHz+PXzO3LDQcK1Q1p
         O5O7tdZH+1DqsG3GmE0vNgWtwxEZ5ShAbpoQfgf6ZzNORn9GR9TgwshDbWsjvaFJcX
         vtmW6vLa716r5uesEbOw5UBkK7XSg8GlzANHWpCCPEhMJsxS7Yzx0uMZgpVs3jz1c3
         pqjj46KPDfKmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FE82E66CBC;
        Wed, 15 Mar 2023 07:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] veth: rely on rtnl_dereference() instead of on
 rcu_dereference() in veth_set_xdp_features()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886661738.11035.18068120188027895258.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:50:17 +0000
References: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
In-Reply-To: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        matthieu.baerts@tessares.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 00:08:40 +0100 you wrote:
> Fix the following kernel warning in veth_set_xdp_features routine
> relying on rtnl_dereference() instead of on rcu_dereference():
> 
> =============================
> WARNING: suspicious RCU usage
> 6.3.0-rc1-00144-g064d70527aaa #149 Not tainted
> 
> [...]

Here is the summary with links:
  - [net] veth: rely on rtnl_dereference() instead of on rcu_dereference() in veth_set_xdp_features()
    https://git.kernel.org/netdev/net/c/5ce76fe1eead

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


