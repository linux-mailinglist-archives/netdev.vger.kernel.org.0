Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9468F51796A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387783AbiEBVyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387737AbiEBVxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:53:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A6ECC2;
        Mon,  2 May 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 791EEB81A50;
        Mon,  2 May 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04B72C385AF;
        Mon,  2 May 2022 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651528212;
        bh=FGNBa+oCtiJLAqxCgr8dMx1J2bpxxfvCC5pSTvcYvyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YzIeaDJhbLSxalkq50471OOpm8l5Apht0mWoAMh27bPIgjlNmxFBNeHaFhvW6FnsE
         5BLBYPWOJBkcFk8tdj3NC1Ya+QFRFUoXIkCLwmzKn8RK/rGHrMfdNpCfcxM3ce+GIT
         ho2KXPw1PDf5TP+6v13o9iosWdWE2fI7XHYb7uSO3E3WHqWY1v6lCVOUetbHU8JUqz
         +U2ZcdNR+rNsToTmVdQpZBrWoltjhkC0C0rG5dhQHZ4DHEJW5Vjj+ycVUjO1Yffd3c
         YOFlNbsorkupev69L8/ZigkQ8hwGcw2Y7krqA642gSxupOtfo9ZO0QfDjL0nU/QFCG
         aY001DrlTm++w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4E15E6D402;
        Mon,  2 May 2022 21:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] tcp: optimise skb_zerocopy_iter_stream()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165152821186.23338.11869983661549264354.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 21:50:11 +0000
References: <a7e1690c00c5dfe700c30eb9a8a81ec59f6545dd.1650884401.git.asml.silence@gmail.com>
In-Reply-To: <a7e1690c00c5dfe700c30eb9a8a81ec59f6545dd.1650884401.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, edumazet@google.com,
        willemdebruijn.kernel@gmail.com, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Apr 2022 11:57:46 +0100 you wrote:
> It's expensive to make a copy of 40B struct iov_iter to the point it
> was taking 0.2-0.5% of all cycles in my tests. iov_iter_revert() should
> be fine as it's a simple case without nested reverts/truncates.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] tcp: optimise skb_zerocopy_iter_stream()
    https://git.kernel.org/netdev/net-next/c/829b7bdd7044

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


