Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC2673101
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 06:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjASFMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 00:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjASFMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 00:12:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5165594
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3274061B22
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85E4EC433F1;
        Thu, 19 Jan 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674105017;
        bh=NKy3226ZJhNFJixKUS/I/sYQXhojlU+/BvcAKsl9c7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AwDH2h4j9zuRHh0wcS6ud1ejRWlVedU5ZxCjTAB+QpF+bw5TLJHjkJhKl4QV+5T6Q
         gFOK47qZyIl9JGCAsmkZRxqpMs9HPSLxucIKXeSvS+eqqo0KmyGb7ITmgW1ntKlm6P
         hFTBPTs0Quaju1s3OKg9Zpa4fGhXSytrFEBXrd+xNadFo7FfNLua6DgQR4PkN9x5U5
         Umsv9F3zDMrbaPfEoS6D1tO6KRPWQ25Rx2l+tue+nYiDRR1o5uRbWoVnlXH29mneZF
         LXuF6UH33NJGG1cpTp0aJVmtqAHsdmVZZiKHOXJ5k/qI4zJ4G8DWCzJNI8NiTTpTXs
         8OvXYy4Cx/XkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BCB2C73FE7;
        Thu, 19 Jan 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: team: use IFF_NO_ADDRCONF flag to prevent
 ipv6 addrconf"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167410501742.20849.2151671875758851377.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 05:10:17 +0000
References: <63e09531fc47963d2e4eff376653d3db21b97058.1673980932.git.lucien.xin@gmail.com>
In-Reply-To: <63e09531fc47963d2e4eff376653d3db21b97058.1673980932.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jiri@resnulli.us,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Jan 2023 13:42:12 -0500 you wrote:
> This reverts commit 0aa64df30b382fc71d4fb1827d528e0eb3eff854.
> 
> Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
> slave ports of team, bonding and failover devices and it means no ipv6
> packets can be sent out through these slave ports. However, for team
> device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
> link will be marked failure. This patch removes the IFF_NO_ADDRCONF
> flag set for team port, and we will fix the original issue in another
> patch, as Jakub suggested.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf"
    https://git.kernel.org/netdev/net/c/4fb58ac3368c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


