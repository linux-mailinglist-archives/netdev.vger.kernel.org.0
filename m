Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BFD57C33A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 06:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiGUEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 00:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGUEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 00:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0342DF10
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 21:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34FE2619AC
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78EF6C385A2;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376617;
        bh=KUQvyK+PBDHTHcB4XisPspwEkoGDAG+qMPXHfaoSUr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NqrRZj7FFrB31/4ZkbmZh6RCInkk7qeLkRR4VmYjGbHwvkC1DvBa6MvxlRB8/P+/7
         puVo4/d4CtfwrudRplHGQW7EHi1uX1rhHtb+7KSCPIeA551XVQ9dJsY0i2HFgi5Y+L
         VLA/T68MXyAzMObOpBAa5MBu5QwezSygjrNwhtoEfggmrC3ertQY3gq1XuRrYOczu6
         Ra/N3ycXt9uaSMfl6+KkymrfMMZaBpr6U+x6CnxveigrXQZOw6STv2uL4QskX+5nCI
         oqBtwcCH4MuMFCuHgWxzVCThMmMekZ9L0lUO7sXDyxlOuodLrANz91g8UV1CkFxKZj
         m3IcILmHFY7yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60B14E451BC;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] selftests: net: af_unix: Fix a build error of
 unix_connect.c.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165837661739.25559.14033620950904760057.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 04:10:17 +0000
References: <20220720005750.16600-1-kuniyu@amazon.com>
In-Reply-To: <20220720005750.16600-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org,
        lkp@intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Jul 2022 17:57:50 -0700 you wrote:
> This patch fixes a build error reported in the link. [0]
> 
>   unix_connect.c: In function ‘unix_connect_test’:
>   unix_connect.c:115:55: error: expected identifier before ‘(’ token
>    #define offsetof(type, member) ((size_t)&((type *)0)->(member))
>                                                        ^
>   unix_connect.c:128:12: note: in expansion of macro ‘offsetof’
>     addrlen = offsetof(struct sockaddr_un, sun_path) + variant->len;
>               ^~~~~~~~
> 
> [...]

Here is the summary with links:
  - [v2,net-next] selftests: net: af_unix: Fix a build error of unix_connect.c.
    https://git.kernel.org/netdev/net-next/c/f12b86c0d606

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


