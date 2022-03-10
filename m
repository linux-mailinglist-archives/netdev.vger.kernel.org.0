Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCB4D54D9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244272AbiCJWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiCJWvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:51:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22543E3C45
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BE5D61BC2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2732C340E9;
        Thu, 10 Mar 2022 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646952611;
        bh=64+RIaiiX/ZM5tzR+jtzAYSJtZddQdNhzXsDLqacsug=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=chD+d+gLbC56NvO3AQKoDwaDvBJrFp5jmuGxJubo/Bm9mSgwumTZ1A1pUQa8Nbon6
         gtmqLN0oKXgPdMMJc/x7S1PaepL/2cZu0MRvR/ebUrkGjvueavuEtHg6jC+ShL4nhJ
         xCTZN7lRddmUjDXjNnInrTLcNwhWPqapyvv2CI1BDpcBsrDmj9djD/vHYmRKfGVePu
         CMI24b2v7PIF/9kEmDQJqmDRwu1GTi6aI+29Wv+SkrjjX3qH8/wuvTvmvlM3gv/KO4
         sFTssjzZG43MlyyKi3rmzFlcj/EYITnEFK3rAjLDCdr3c/2kGCl/Vww+1BC+CnF+si
         icjmxU4Qi7VDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7042E8DD5B;
        Thu, 10 Mar 2022 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix kernel-infoleak for SCTP sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695261074.1555.3159642827265058252.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 22:50:10 +0000
References: <20220310001145.297371-1-eric.dumazet@gmail.com>
In-Reply-To: <20220310001145.297371-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        lucien.xin@gmail.com, vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 16:11:45 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported a kernel infoleak [1] of 4 bytes.
> 
> After analysis, it turned out r->idiag_expires is not initialized
> if inet_sctp_diag_fill() calls inet_diag_msg_common_fill()
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix kernel-infoleak for SCTP sockets
    https://git.kernel.org/netdev/net/c/633593a80898

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


