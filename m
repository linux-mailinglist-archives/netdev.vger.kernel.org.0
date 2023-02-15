Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDE869758E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjBOEuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjBOEuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AA22DE45
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965C0B8204B
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45B4CC433A0;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436619;
        bh=0/ZrKqIyuKl0eSLBHnRIAF+BTfG3jITSwgflpacQymg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ttd7d/2JvfQB593gUfNWh4RI3dJcQ77aIHnwAX9OLKcm28yySZBCozdog6rHtFfgo
         QHZJyhIBUOtvuCGWdtw3cih+OLitBxJWSi8cRPSE96YMQHqGWprWU2LLdxpvydFgai
         XJRTICaa9jHkTSGIafNNv+4yjgMPtPMVN+uTQzlFSfF9EgsJSJrT4qTKe4xWl9P3Ma
         9PLSB7tMymSjgJuTRmfNQAlgS0X5YKBXYoN7eBrRIUcWNql3SNulltZww2T+1KdnN0
         lWhd+m1SZvwJ82JoEXE+fK6BvjjjED5Cio3CDHRYOKBYIzE2em5IriPkszQiThzkpr
         l2eKEK+j8LQHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31481E29F42;
        Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink-specs: add rx-push to ethtool family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643661919.17897.4222981844459063079.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:50:19 +0000
References: <20230214043246.230518-1-kuba@kernel.org>
In-Reply-To: <20230214043246.230518-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, shannon.nelson@amd.com
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

On Mon, 13 Feb 2023 20:32:46 -0800 you wrote:
> Commit 5b4e9a7a71ab ("net: ethtool: extend ringparam set/get APIs for rx_push")
> added a new attr for configuring rx-push, right after tx-push.
> Add it to the spec, the ring param operation is covered by
> the otherwise sparse ethtool spec.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] netlink-specs: add rx-push to ethtool family
    https://git.kernel.org/netdev/net-next/c/1ed32ad4a3cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


