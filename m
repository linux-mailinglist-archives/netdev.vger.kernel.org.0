Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1456A127
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiGGLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiGGLkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E744A4D4EB
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41651622FC
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93173C341C8;
        Thu,  7 Jul 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657194013;
        bh=vns4zJES2aus8dAkYBczAyxzaPbP/uWzCkJ0qOZF/DA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QHPdHFFukA25YPPQ9uw3wgcItiARpAC5MhLXeT4XTmG6/knbNRncnA9Zdq+PoEg9r
         YWy0IMcr5QtaZdyWKumdE6zwU4UOgBIK0qnQChajyHd3AkcSfdv15AXBxT69jkxV19
         CkRTY4mbUCIrsJu/VViHggiYtNdlX8NeR5lpw0PRf39GkhxkTdmORW+Drf5HyC/WAW
         Bf6t/17Ak2UPZMJzJeE44XZIrhxPQdyvOTV5ysDRIu5YHvYAQJp110vAj8uMv7u/dP
         VtTjLdpwxBBiYb04pjllVrd90fsNtUHzIkA435TcoH2jq9NrH6dphlKR9+wjOLnD7f
         VEzeZWZ5dgDvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77928E45BDE;
        Thu,  7 Jul 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next] af_unix: Optimise hash table layout.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165719401348.14753.17090781575828144840.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 11:40:13 +0000
References: <20220705233715.759-1-kuniyu@amazon.com>
In-Reply-To: <20220705233715.759-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 5 Jul 2022 16:37:15 -0700 you wrote:
> Commit 6dd4142fb5a9 ("Merge branch 'af_unix-per-netns-socket-hash'") and
> commit 51bae889fe11 ("af_unix: Put pathname sockets in the global hash
> table.") changed a hash table layout.
> 
>   Before:
>     unix_socket_table [0   - 255] : abstract & pathname sockets
>                       [256 - 511] : unnamed sockets
> 
> [...]

Here is the summary with links:
  - [v1,net-next] af_unix: Optimise hash table layout.
    https://git.kernel.org/netdev/net-next/c/cf21b355ccb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


