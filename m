Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396784DDAE1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbiCRNve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiCRNva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F52D1EEF8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 06:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E6C5619EB
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6445FC340EC;
        Fri, 18 Mar 2022 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647611410;
        bh=HzHNL57UYYnF4SUG9L/I9zp48Mb89SYnWKW3ZWGOeQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j17bf365Hw5XQB7Yky8xQFrMcnOGJprK1VT2bfDDf4TlTov1IDuAwE9dCBWrOs3Hp
         nZTAJGVRWftYVG6fcDBA9TDlgy8nCaTV37J+JsZrO+qI9jcipKfELtGaF+nJOrBoyx
         UX+cJ3XOtcTjW4J02FdoA6ViF0PyNiizTsfC2stLplmWC83B87YpZxV03F0o7UUdPu
         XH936GwOXE08rehGEV0YALjS0RxCGYSxNhrJYRw4q2w+Vwi915dlgXsv1fM7qi53Yx
         r8h+gkn6AiZLmhkla3BRJbcFxLODWAfM6cd5AmGA+sFysuS4Xw7QNBvwT9fb2gGAgv
         SQlq+p2eZxYrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47EBFEAC09C;
        Fri, 18 Mar 2022 13:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net 0/2] af_unix: Fix some OOB implementation.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164761141029.7048.11992846376490717395.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 13:50:10 +0000
References: <20220317030809.63672-1-kuniyu@amazon.co.jp>
In-Reply-To: <20220317030809.63672-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        Rao.Shoaib@oracle.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Mar 2022 12:08:07 +0900 you wrote:
> This series fixes some data-races and adds a missing feature around the
> commit 314001f0bf92 ("af_unix: Add OOB support").
> 
> Changelog:
>   - v4:
>     - Separate nit changes from this series for net-next
> 
> [...]

Here is the summary with links:
  - [v4,net,1/2] af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
    https://git.kernel.org/netdev/net/c/e82025c623e2
  - [v4,net,2/2] af_unix: Support POLLPRI for OOB.
    https://git.kernel.org/netdev/net/c/d9a232d435dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


