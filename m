Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D123E63349A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 06:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiKVFAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 00:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKVFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 00:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC46A2B18F
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 21:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 545DDB8166A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F224CC433B5;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669093222;
        bh=0aNWrsN/52lgTBH8cINIrcqNI/oaOoJTP4Hj5xcze7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B28UlVV83XCpYRpEewaaCo1QC2ArSWc7Yy7lemjDhC8M1zetqkJRiprYy9TdyM3+H
         SrogAVybczWhdgV9JvGcJZwYrX7QcgoxdAWvH1ckC1ZJ8xFCa/tf9wIcvdaB7UoaKF
         sr64br4m0B9IdaT6WsnHwzELHhkZAYrtf75ftlxZsKbZIv9bHTC1vgnW+095zjVBXB
         dmzna2UJnB0L1qEgJ9bzadr+Le7sXDC7bxwrcKWkyjNM/bHCMuvm4eirzWC6EVX/nd
         b6Ul9AcbpIvlEfVIXpevw1DGNVPaw96y7AXN2J6ilXNNfIBNAAX/xpsDZo7+HXF5ah
         s8x2W1TeaSeyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D61F0E270CF;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] tipc: fix two race issues in tipc_conn_alloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909322186.4259.10273863059651319220.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 05:00:21 +0000
References: <cover.1668807842.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1668807842.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        harperchen1110@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 16:44:59 -0500 you wrote:
> The race exists beteen tipc_topsrv_accept() and tipc_conn_close(),
> one is allocating the con while the other is freeing it and there
> is no proper lock protecting it. Therefore, a null-pointer-defer
> and a use-after-free may be triggered, see details on each patch.
> 
> Xin Long (2):
>   tipc: set con sock in tipc_conn_alloc
>   tipc: add an extra conn_get in tipc_conn_alloc
> 
> [...]

Here is the summary with links:
  - [net,1/2] tipc: set con sock in tipc_conn_alloc
    https://git.kernel.org/netdev/net/c/0e5d56c64afc
  - [net,2/2] tipc: add an extra conn_get in tipc_conn_alloc
    https://git.kernel.org/netdev/net/c/a7b42969d63f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


