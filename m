Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01FF62080D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiKHEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiKHEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DA565DA;
        Mon,  7 Nov 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADFDAB818A4;
        Tue,  8 Nov 2022 04:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 334A4C433D6;
        Tue,  8 Nov 2022 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667880615;
        bh=2/kV0FWirF5R3owaF9CYlU8SM59Xw2DzuCXN1gp3phU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=chByF1bBsAvMIumFvG1kUx4KNb6GJwDuaLfDGrLdz0cO81QaStF0OJW+sg2MBuCF7
         zSocf5kXL8of2jpo30IerICmjQJcpuryoNrlg0KIC8GuyVZlOhAAA5/Hxn3Dw1arvE
         8jydQMilB8wVhXTz1nja02W/WQRHdZ1KGp+6piFhhoPISidVtEMAJq7FDUOQVTfnxG
         60tBo8AIOdwA18qM8LthHA3NEWGlZXVqlbmRi9OO/GtFpLkKqM6j8wP+xG5vdT+hWK
         FMGJK5bFOgCykhI2O2F50wJf3DmPF1ubLANaEfqvip8KSxZZmQkLmSvUH8q5iAs7RN
         org/xUL8zWlyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F8C7C73FFC;
        Tue,  8 Nov 2022 04:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] sctp: fix a NULL pointer dereference in
 sctp_sched_dequeue_common
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166788061512.1355.13741281961471766630.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 04:10:15 +0000
References: <cover.1667598261.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1667598261.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com, chenzhen126@huawei.com,
        caowangbao@huawei.com
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

On Fri,  4 Nov 2022 17:45:14 -0400 you wrote:
> This issue was triggered with SCTP_PR_SCTP_PRIO in sctp,
> and caused by not checking and fixing stream->out_curr
> after removing a chunk from this stream.
> 
> Patch 1 removes an unnecessary check and makes the real
> fix easier to add in Patch 2.
> 
> [...]

Here is the summary with links:
  - [net,1/2] sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
    https://git.kernel.org/netdev/net/c/9f0b773210c2
  - [net,2/2] sctp: clear out_curr if all frag chunks of current msg are pruned
    https://git.kernel.org/netdev/net/c/2f201ae14ae0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


