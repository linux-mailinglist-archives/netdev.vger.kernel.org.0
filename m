Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5777767AF19
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbjAYKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbjAYKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:00:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D38153E62;
        Wed, 25 Jan 2023 02:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5733CE1DC3;
        Wed, 25 Jan 2023 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DEAC1C4339E;
        Wed, 25 Jan 2023 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674640816;
        bh=UamnZL0q5DHDLkY75y5Nxam4bD27yr/asZU4Aseivsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EyW1SugmykJvZL164x9ZsUbxj8gBJB3XPhzmvxffNbEXziji5GdzFH17KYAP7WrOb
         ok7DIaKNWqLpfmD8xxFDgvBhHoAFpgyuuGIMubKC6dIUMhEo/UviemnVo8h4KkHlU6
         F7s3FKNiShfjCTk4s/YrVcwWGR3/xaC7eWKROiM9rny3CnxQSJX1dw5eG/vGyTfFWo
         6aZjPItDWlg7YjlFAC2rmCku7Sq8UP03MAlkurJWp4G4UF8BDy+NE7anXjjOY96WUY
         k7zDygh6TgH5O57S+uhfsjZwZmHL9uheMkB07fMboiN3FwvzV71DANUfdTQQszlZwd
         qMFazTLIAAyqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3D9FF83ED2;
        Wed, 25 Jan 2023 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/x25: Fix to not accept on connected socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167464081679.8627.16186557969987796753.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 10:00:16 +0000
References: <20230123194323.GA116515@ubuntu>
In-Reply-To: <20230123194323.GA116515@ubuntu>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     ms@dev.tdt.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, imv4bel@gmail.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Mon, 23 Jan 2023 11:43:23 -0800 you wrote:
> When listen() and accept() are called on an x25 socket
> that connect() succeeds, accept() succeeds immediately.
> This is because x25_connect() queues the skb to
> sk->sk_receive_queue, and x25_accept() dequeues it.
> 
> This creates a child socket with the sk of the parent
> x25 socket, which can cause confusion.
> 
> [...]

Here is the summary with links:
  - [v2] net/x25: Fix to not accept on connected socket
    https://git.kernel.org/netdev/net/c/f2b0b5210f67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


