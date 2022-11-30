Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4363CE59
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiK3EaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiK3EaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:30:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C110D2A416;
        Tue, 29 Nov 2022 20:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16E36CE17D8;
        Wed, 30 Nov 2022 04:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 181AAC433C1;
        Wed, 30 Nov 2022 04:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669782617;
        bh=/in5Kk6DmVC0nx8gtlneaUqJh9o6GPhXF1Lsqe68WZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHnXcq6BNH6yDBBD4vpPwdkh5HwAh7wUbK7tXSW7BZNTGHniJKrQZia4y1S4ZmnST
         2B2UyRVRvYslk+mjT4c86WhINS0MzL7PqUiC3vebGIf78nv3REb3Z/67Z+vXkoUgxF
         zkSLxgMLigbppZGa6U0YD3yC65t6u7vyn0tBsmNv3fAZyi5XuCEf+XIX4WG9wX3e4g
         gZUtMqaAB7g+KGsjlJGp8YXo959jhcYsyIVOnJHy3hgD5jx/KVW58bmv1wpxQPOJmD
         j9twxFiWw2L48tnARGsXMxf1oSWkZPttt7XARgEFo8qlkzOLXmi9WbBH0DQJexwuUw
         lJ3JrzqtFeZjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3121E4D00F;
        Wed, 30 Nov 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: MSG_FASTOPEN and TFO listener side
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166978261699.28302.9342506278559559292.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Nov 2022 04:30:16 +0000
References: <20221125222958.958636-1-matthieu.baerts@tessares.net>
In-Reply-To: <20221125222958.958636-1-matthieu.baerts@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com,
        shuah@kernel.org, benjamin.hesmans@tessares.net,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Nov 2022 23:29:46 +0100 you wrote:
> Before this series, only the initiator of a connection was able to combine both
> TCP FastOpen and MPTCP when using TCP_FASTOPEN_CONNECT socket option.
> 
> These new patches here add (in theory) the full support of TFO with MPTCP, which
> means:
> 
>  - MSG_FASTOPEN sendmsg flag support (patch 1/8)
>  - TFO support for the listener side (patches 2-5/8)
>  - TCP_FASTOPEN socket option (patch 6/8)
>  - TCP_FASTOPEN_KEY socket option (patch 7/8)
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: add MSG_FASTOPEN sendmsg flag support
    https://git.kernel.org/netdev/net-next/c/1e777f39b4d7
  - [net-next,2/8] mptcp: track accurately the incoming MPC suboption type
    https://git.kernel.org/netdev/net-next/c/fe33d3862677
  - [net-next,3/8] mptcp: consolidate initial ack seq generation
    https://git.kernel.org/netdev/net-next/c/b3ea6b272d79
  - [net-next,4/8] mptcp: implement delayed seq generation for passive fastopen
    https://git.kernel.org/netdev/net-next/c/dfc8d0603033
  - [net-next,5/8] mptcp: add subflow_v(4,6)_send_synack()
    https://git.kernel.org/netdev/net-next/c/36b122baf6a8
  - [net-next,6/8] mptcp: add TCP_FASTOPEN sock option
    https://git.kernel.org/netdev/net-next/c/4ffb0a02346c
  - [net-next,7/8] mptcp: add support for TCP_FASTOPEN_KEY sockopt
    https://git.kernel.org/netdev/net-next/c/cb99816cb59d
  - [net-next,8/8] selftests: mptcp: mptfo Initiator/Listener
    https://git.kernel.org/netdev/net-next/c/ca7ae8916043

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


