Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CB36E409E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjDQHUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjDQHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4914203;
        Mon, 17 Apr 2023 00:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 362E861F1A;
        Mon, 17 Apr 2023 07:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C6BCC43321;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716022;
        bh=u2Sguc+3766z1o03X+zVOjd8o1h6bry1xdq0odNeVqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s01MbO9j/hOSKo3HvKIYIvoge9ZYVGNEbygdM+YonPC+6JpfccQOZi151HZK+lid0
         DmCdKWnLkwF16+Oq3CBrr6UZq64M0Jf4gkqA/EM+eyUUnEm+C3j4ssG1HSX2lszPWo
         3bnN6ZSTE4r5Cf4ZMM9Qh9tMZU36xwcwyaP4EYPdFY5uJXIUzc2CDP7W2mGiuvpnVk
         Ia6DmHZ8SeatfrLqQ+lVexCEjovw8uMp2mtjGSfesF+1kPiqVo4iTrnE/zU2PlBNRI
         Ke7fIXTxn5bxuYTuuEm8Q8INbpp1W4kRvj1FAGbO8TqrSD/5o+YUEIB8uE4oOngOP3
         Ya1V5BxiRGECw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52590E3309E;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mptcp: refactor first subflow init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168171602233.1935.2357676124507584739.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 07:20:22 +0000
References: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
In-Reply-To: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, omosnace@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Apr 2023 16:07:59 +0200 you wrote:
> This series refactors the initialisation of the first subflow of a
> listen socket. The first subflow allocation is no longer done at the
> initialisation of the socket but later, when the connection request is
> received or when requested by the userspace.
> 
> This is needed not just because Paolo likes to refactor things but
> because this simplifies the code and makes the behaviour more consistent
> with the rest. Also, this is a prerequisite for future patches adding
> proper support of SELinux/LSM labels with MPTCP and accept(2).
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mptcp: drop unneeded argument
    https://git.kernel.org/netdev/net-next/c/7a486c443c89
  - [net-next,2/5] mptcp: avoid unneeded __mptcp_nmpc_socket() usage
    https://git.kernel.org/netdev/net-next/c/617612316953
  - [net-next,3/5] mptcp: move fastopen subflow check inside mptcp_sendmsg_fastopen()
    https://git.kernel.org/netdev/net-next/c/a2702a076e73
  - [net-next,4/5] mptcp: move first subflow allocation at mpc access time
    https://git.kernel.org/netdev/net-next/c/ddb1a072f858
  - [net-next,5/5] mptcp: fastclose msk when cleaning unaccepted sockets
    https://git.kernel.org/netdev/net-next/c/8d547809a5d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


