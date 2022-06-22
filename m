Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFD5549EA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiFVMUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiFVMUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721A33E03
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41CBBB81E71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 12:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4E9CC3411B;
        Wed, 22 Jun 2022 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655900413;
        bh=2G6Bd9rsoItB9woFIw42uHV1kGQuQ3jQ2saltD9vltk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RXDoacMJQuGjZ5CUT7NEx0K1GZ1b0pa1HNAP+mplrRkLvJOh94wFhZICoI9seHyJJ
         J2uUQhk09PVkYRWoS/UNW0mUgHoYe3MDFRJCIkyVaF+bshZiBCI1PuZQqU4jGUUs8n
         acTSxHYyQAns3/6JPr2YN5OV1Gh7tcQESvOvAFUbLN8KhKNMHugR+K1jem25oWIhNx
         xrPZjgiYSeltAWzmIM5caUB7mFwbYUR6KmUDJcLv08ncb/GFsrlEhodmeiIx5PuBt5
         RdhxpCwXTvD7+52VaalI4FigfW7A2tWtFkmLUALDF36FGEvDL6XDANqv650hrptM6e
         +/O33auXAteUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF02FE7B9A4;
        Wed, 22 Jun 2022 12:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/6] af_unix: Introduce per-netns socket hash
 table.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165590041384.22299.3993147401404123836.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 12:20:13 +0000
References: <20220621171913.73401-1-kuniyu@amazon.com>
In-Reply-To: <20220621171913.73401-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, aams@amazon.com, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 21 Jun 2022 10:19:07 -0700 you wrote:
> This series replaces unix_socket_table with a per-netns hash table and
> reduces lock contention and time on iterating over the list.
> 
> Note the 3rd-6th patches can be a single patch, but for ease of review,
> they are split into small changes without breakage.
> 
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/6] af_unix: Clean up some sock_net() uses.
    https://git.kernel.org/netdev/net-next/c/340c3d337119
  - [v3,net-next,2/6] af_unix: Include the whole hash table size in UNIX_HASH_SIZE.
    https://git.kernel.org/netdev/net-next/c/f302d180c6d4
  - [v3,net-next,3/6] af_unix: Define a per-netns hash table.
    https://git.kernel.org/netdev/net-next/c/b6e811383062
  - [v3,net-next,4/6] af_unix: Acquire/Release per-netns hash table's locks.
    https://git.kernel.org/netdev/net-next/c/79b05beaa5c3
  - [v3,net-next,5/6] af_unix: Put a socket into a per-netns hash table.
    https://git.kernel.org/netdev/net-next/c/cf2f225e2653
  - [v3,net-next,6/6] af_unix: Remove unix_table_locks.
    https://git.kernel.org/netdev/net-next/c/2f7ca90a0188

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


