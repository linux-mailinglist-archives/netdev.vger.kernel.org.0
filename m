Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE3457AB0D
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbiGTAkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiGTAkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91804AD59
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65EC3616C7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1ADCC341CB;
        Wed, 20 Jul 2022 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658277613;
        bh=Bdvk4V2QhAaXSLg2xjkZft+Jaayvp9yEdTaZq9lemF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GNNvB1erv3CX23YNzFv4eeShMMt7GfZZOoG7hHq6JJMzcvgpCrKKJVPUIcf/wdqUQ
         XWHGhuNcnTyaxttnb8jrXkl5g9+rQztRdtjWhPj5QDR7ncEhd1A/K3EL160kP4wAmD
         3pH6FqMZ8DKamcJTtFz/FuVd6dRlqOfDOyTwkCXMqPRZCy4wbaO2kcR+b6czuFx1ZL
         5FvEVbn/+BywYp/F0+P9NnMRPLUUNSyWiO3wv2qm89aopR/J7We7FiNogbvBkiQXjy
         lx9LKHJk5OxwX4SguLy5Rp44O+cTt8TZAnoxkW4ty6ZOZ9BVvciNkAgGAKUXhGP9SF
         0tVsQruKFqeOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92AEDE451B7;
        Wed, 20 Jul 2022 00:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Documentation: fix udp_wmem_min in ip-sysctl.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165827761359.10063.2585519986719707110.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 00:40:13 +0000
References: <c880a963d9b1fb5f442ae3c9e4dfa70d45296a16.1658167019.git.lucien.xin@gmail.com>
In-Reply-To: <c880a963d9b1fb5f442ae3c9e4dfa70d45296a16.1658167019.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, haoki@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 18 Jul 2022 13:56:59 -0400 you wrote:
> UDP doesn't support tx memory accounting, and sysctl udp_wmem_min
> is not really used anywhere. So we should fix the description in
> ip-sysctl.rst accordingly.
> 
> Fixes: 95766fff6b9a ("[UDP]: Add memory accounting.")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] Documentation: fix udp_wmem_min in ip-sysctl.rst
    https://git.kernel.org/netdev/net/c/c6b10de537b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


