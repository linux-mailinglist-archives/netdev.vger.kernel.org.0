Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD7550976
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 11:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiFSJKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 05:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiFSJKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 05:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A5295B9
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 02:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A28B60FE0
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 09:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4D78C3411D;
        Sun, 19 Jun 2022 09:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655629812;
        bh=/eEJa0pQlZlD5W1IGSGFgDFCcYnId4lZJJ2793sU0JA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GN8ykM0ElTqkD4oWhVurSrESySIzJ3VdlHE97wkXhfcB1RjroIRz0Hi4xu/4HqofA
         97TxvtDgj8JayqaQEFQvMuNFZF9MO0eAub1uvOsDkAv5uMVIwGlSy7Maxo/tjipcFk
         GbUXgs5G/ryTfMMZm1w5LXtMeRIf4j2aZz8Ai1W1HZh0RHFDBrh6yOt2yEOP4m51kT
         +bBxC4HIHWQVk7rXJBBgIanIxuetNHdG+VWi2F/sODZ6YNDQbaS5PKIHxiOiEucsTG
         M+7NAQXh9GrOtCRk635xhE/q4Zg0kC1K9shxxdMeaJ1AH0QwXKiiWCqfxpuRMQPLwh
         IHcl7fakq3GPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB7CAE7387A;
        Sun, 19 Jun 2022 09:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] raw: RCU conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165562981269.6554.17099795352757698507.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 09:10:12 +0000
References: <20220618034705.2809237-1-eric.dumazet@gmail.com>
In-Reply-To: <20220618034705.2809237-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Jun 2022 20:47:03 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Using rwlock in networking code is extremely risky.
> writers can starve if enough readers are constantly
> grabing the rwlock.
> 
> I thought rwlock were at fault and sent this patch:
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] raw: use more conventional iterators
    (no matching commit)
  - [v2,net-next,2/2] raw: convert raw sockets to RCU
    https://git.kernel.org/netdev/net-next/c/0daf07e52709

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


