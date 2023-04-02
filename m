Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DF16D37F0
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjDBMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBMuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8D6A273;
        Sun,  2 Apr 2023 05:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 221DE611F2;
        Sun,  2 Apr 2023 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D7D3C4339B;
        Sun,  2 Apr 2023 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680439816;
        bh=rQqv9ogO54C4FfVeug38ZuObq436G/aGSDl7mWECQro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e8uUwbeC93ok3ei6LusXCLx1oF0gWFjCd7QcqkRdGdVHohkelzDdj0PKLQX1cbAa2
         NFv4WqLvu1dpgWWB23uMUswsrqPkAr9gCzMoA2uGx7ghF+U72bp0ZMTdiIHPpKwuR+
         CC9FiL0R5/+BoznrAvbTs8r9RcociabTz7GMVDgvFvrCpSOcQWrHJDN5WMlw3Kqi45
         pdUbhx4OyJvA13pYTemuwdmTUVg8SnIpMAhl5SvyNJ3ZrBDaFeAp+8k/B+5J55G/5Q
         xc4D/wXP2xH3cu2QYKkqd5yQBXl45BCK052TeaotwJootCF6UVQbf8V7BqNcJ7QuUI
         E/wOlAo4L8aew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55EEDC73FE2;
        Sun,  2 Apr 2023 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: check send stream number after wait_for_sndbuf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043981634.15620.14113899026364813015.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:50:16 +0000
References: <313e35feff94a17a88c2b6f6c4fa0b743754ec01.1680390597.git.lucien.xin@gmail.com>
In-Reply-To: <313e35feff94a17a88c2b6f6c4fa0b743754ec01.1680390597.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Apr 2023 19:09:57 -0400 you wrote:
> This patch fixes a corner case where the asoc out stream count may change
> after wait_for_sndbuf.
> 
> When the main thread in the client starts a connection, if its out stream
> count is set to N while the in stream count in the server is set to N - 2,
> another thread in the client keeps sending the msgs with stream number
> N - 1, and waits for sndbuf before processing INIT_ACK.
> 
> [...]

Here is the summary with links:
  - [net] sctp: check send stream number after wait_for_sndbuf
    https://git.kernel.org/netdev/net/c/2584024b2355

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


