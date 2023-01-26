Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9461C67C4EA
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjAZHay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZHam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:30:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B2765F14
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FDC8B81D11
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE8FCC433EF;
        Thu, 26 Jan 2023 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674718217;
        bh=peXoYPPrUOK4Qs0iE8o633kAROwBt89Lyk2AOGEGPHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C+cAZRR2n4geYewHjB8nQX9/EzHOaNNHj7TzMPzgj5MKDJaZiLJU6L3AoclVfvYCN
         n8LPwFnH3xXjaanz+iC13UG3haYgjfiTLQ8S0ePDyLcCPIbAAgwgW4CcHECVkT7iVl
         BtrW+4cVgeeJRsjxfZZlXMgcTD/AyR2fdweMTO+PT5wLTVpqJ9h6ZOhoZeKUB3Md1v
         vir2yJ8GI4o2YharK9rrJDzrO8B96vVBC+TDSA5WD99Lm1Ozx/DrR88jVetnhrKMRe
         NCgaLJ/IE7qF0bw7FFceXwT2snX9S9K5v2yReL8DM+M/LR9fPwzcT5BTohhnh1w9sD
         l+UZB8/jd6BfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFDC2F83ED6;
        Thu, 26 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tsnep: Fix TX queue stop/wake for multiple queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167471821684.31738.12532532466082445385.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 07:30:16 +0000
References: <20230124191440.56887-1-gerhard@engleder-embedded.com>
In-Reply-To: <20230124191440.56887-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Jan 2023 20:14:40 +0100 you wrote:
> netif_stop_queue() and netif_wake_queue() act on TX queue 0. This is ok
> as long as only a single TX queue is supported. But support for multiple
> TX queues was introduced with 762031375d5c and I missed to adapt stop
> and wake of TX queues.
> 
> Use netif_stop_subqueue() and netif_tx_wake_queue() to act on specific
> TX queue.
> 
> [...]

Here is the summary with links:
  - [net] tsnep: Fix TX queue stop/wake for multiple queues
    https://git.kernel.org/netdev/net/c/3d53aaef4332

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


