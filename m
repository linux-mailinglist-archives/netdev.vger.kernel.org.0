Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AA05EAD72
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiIZRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiIZRAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:00:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FE656001;
        Mon, 26 Sep 2022 09:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31E85B80AFD;
        Mon, 26 Sep 2022 16:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAEB4C433D7;
        Mon, 26 Sep 2022 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664208016;
        bh=C7ATyrZzj7o+84SsCaR8602boUIqkK0qno/6YB5vXk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hY7bDhPTLJktcFKp6Oo82iAnvUfUngSK6NTVo70dhwtk9v30bzTS0LK46B+n8fxNb
         oJo64yKv37NHoObiEyhvAtERhFmUO8qFr5do2hpKycXDNmFOwSO1SFXJeaHkZsjbcu
         xobQcfFFEq1FUMBV1cwoGPt0pjcVL8oRg+zKxfkS2gNEyV4TuCu/VC3pFjFUpbRGAQ
         EV287iuWJ16+FWVsCBBqBINhmh4ajeivSQS2LXBTDCnsnogNU6rN6iZSZXeg+4sBFn
         n0yw0T1K5H2PXOoA0L75mtILi4FY2awMlXFCAtVX8fhvP2N/yPrgar7dRV6PjFGy+O
         rBD+q5q3uRwWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1BE2E21EC4;
        Mon, 26 Sep 2022 16:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] skmsg: schedule psock work if the cached skb exists on
 the psock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166420801585.16435.9996429158020872150.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 16:00:15 +0000
References: <20220907071311.60534-1-liujian56@huawei.com>
In-Reply-To: <20220907071311.60534-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 7 Sep 2022 15:13:11 +0800 you wrote:
> In sk_psock_backlog function, for ingress direction skb, if no new data
> packet arrives after the skb is cached, the cached skb does not have a
> chance to be added to the receive queue of psock. As a result, the cached
> skb cannot be received by the upper-layer application.
> 
> Fix this by reschedule the psock work to dispose the cached skb in
> sk_msg_recvmsg function.
> 
> [...]

Here is the summary with links:
  - [bpf] skmsg: schedule psock work if the cached skb exists on the psock
    https://git.kernel.org/bpf/bpf-next/c/bec217197b41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


