Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CDC661F74
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjAIHuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjAIHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5169A13D22
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDCF2B80D3E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F260C433D2;
        Mon,  9 Jan 2023 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673250616;
        bh=4EV8j06jNAysTNwT7QnsTd7fUSkfhFkqY3kz0qBGcjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AuNNG35vj00B4eAeLbQZ1HyrRcKvjJkTxkLlRlVr6MZ4onxUWQc9kebK9KK4qvAlY
         92F89A2BFibiP+DJc9NQASa7+15gmLVP+AkfCHFhNaFnYXWZrCFfC/I3PZkvdXqjTX
         wGZDICKvnhodnY6NFMBVOdhCGnhg3qwgNcOQ7z7e6DFdj+cNVn4ixd8j8I5vqidtr1
         3etywQs95oeJHtf4w5MbD0vxfhjO2MltxJtADHvMK4uG3ofdBJp96qxsaMX3XGkhTI
         tXfk/N41UyhjAVatLeYmfagBnpTYaLuKJ6gQ9WIcHt0757usOGKmwO7DKVAZT9/XX3
         MWeTRDM6iOKjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D3DDE21EE6;
        Mon,  9 Jan 2023 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] mptcp: Protocol in-use tracking and code cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325061637.1839.14365861753264546033.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:50:16 +0000
References: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
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
by David S. Miller <davem@davemloft.net>:

On Fri,  6 Jan 2023 10:57:16 -0800 you wrote:
> Here's a collection of commits from the MPTCP tree:
> 
> Patches 1-4 and 6 contain miscellaneous code cleanup for more consistent
> use of helper functions, existing local variables, and better naming.
> 
> Patches 5, 7, and 9 add sock_prot_inuse tracking for MPTCP and an
> associated self test.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] mptcp: use msk_owned_by_me helper
    https://git.kernel.org/netdev/net-next/c/109cdeb8dfa3
  - [net-next,2/9] mptcp: use net instead of sock_net
    https://git.kernel.org/netdev/net-next/c/a963853fd465
  - [net-next,3/9] mptcp: use local variable ssk in write_options
    https://git.kernel.org/netdev/net-next/c/3c976f4c9923
  - [net-next,4/9] mptcp: introduce 'sk' to replace 'sock->sk' in mptcp_listen()
    https://git.kernel.org/netdev/net-next/c/cfdcfeed6449
  - [net-next,5/9] mptcp: init sk->sk_prot in build_msk()
    https://git.kernel.org/netdev/net-next/c/ade4d754620f
  - [net-next,6/9] mptcp: rename 'sk' to 'ssk' in mptcp_token_new_connect()
    https://git.kernel.org/netdev/net-next/c/294de9090938
  - [net-next,7/9] mptcp: add statistics for mptcp socket in use
    https://git.kernel.org/netdev/net-next/c/c558246ee73e
  - [net-next,8/9] selftest: mptcp: exit from copyfd_io_poll() when receive SIGUSR1
    https://git.kernel.org/netdev/net-next/c/4a753ca5013d
  - [net-next,9/9] selftest: mptcp: add test for mptcp socket in use
    https://git.kernel.org/netdev/net-next/c/e04a30f78809

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


