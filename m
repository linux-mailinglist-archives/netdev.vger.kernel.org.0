Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA7581DF0
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbiG0DKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiG0DKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAE8617C
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D7C061799
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF342C43470;
        Wed, 27 Jul 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891414;
        bh=pQSyi3UH3WZQn2CrCYki7a8JjgL0ezEu7fIgfkMONR0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DQpIhrd3Rktn9eh83J7GQr6kN4F5z1IkJQ5yMQxCwOM4Aa0ueT7Ed4H7JSvxnBh5G
         HJ72bUQPSMW3cj7JsoSiiqxKfHHc5g3xw3lSAU9e8wXe9ZQaq/88jdPgJ6xWly7j4w
         bgaSHXi91svU5cwPdwxmfW+QRD1y/3QpUvaLeRU4H6NOwCpWgatz7JrRL1d8UbwhaY
         7nBDEP14PH03EYLBGrP2YGTpYSOplYLDCANepZ6WcE2ZhfxX8krRVW8QJ5b3KklTVU
         J2W4rR8xNAE7256h8O+k/XrVkhn6T1FfGXRIlQnd0zwJVVijCVl5q2gVY1w1dNNW/V
         te4lspArTPeBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5D06C43140;
        Wed, 27 Jul 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: Do not return EINPROGRESS when subflow creation
 succeeds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165889141387.5272.6096636304213896963.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 03:10:13 +0000
References: <20220725205231.87529-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220725205231.87529-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, fw@strlen.de, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Jul 2022 13:52:31 -0700 you wrote:
> New subflows are created within the kernel using O_NONBLOCK, so
> EINPROGRESS is the expected return value from kernel_connect().
> __mptcp_subflow_connect() has the correct logic to consider EINPROGRESS
> to be a successful case, but it has also used that error code as its
> return value.
> 
> Before v5.19 this was benign: all the callers ignored the return
> value. Starting in v5.19 there is a MPTCP_PM_CMD_SUBFLOW_CREATE generic
> netlink command that does use the return value, so the EINPROGRESS gets
> propagated to userspace.
> 
> [...]

Here is the summary with links:
  - [net] mptcp: Do not return EINPROGRESS when subflow creation succeeds
    https://git.kernel.org/netdev/net/c/b5177ed92bf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


