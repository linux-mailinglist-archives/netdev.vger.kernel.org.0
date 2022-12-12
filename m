Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7814064A917
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiLLVBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiLLVBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:01:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB6319C19;
        Mon, 12 Dec 2022 13:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79D1B6122C;
        Mon, 12 Dec 2022 21:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4A34C433A4;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670878816;
        bh=khvImva0U8qbmjMX2hkdPknGiwt6X4vE5xCGbGpxmdU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nb7RnEQTE0MB5fgvH4sqO3haeHD2tdXFxs0wigOGWplzbqjzi7xLr4XmW8mNVj59F
         4iR5diva4b04D5qw9SQDuEEl4JgVYhoNMXc72ql2b5fGL2Toi0Y2y3rPn0TXBHB0j7
         2FLhrx6/R1MXP8FPC+JXpcFJCaA8N4VPDyafe9xp/u+cWRJt0vKXeuakzwrmDxLDlz
         mdvd5wnRVSahwEUQId+EaPfr/Yn6ueJmL3WbnTlAPrLZdu2NmgS8fm17SWw8WalURs
         vItCnN+7dKBqIayRU0P332+9432N2zD+YJeZk349qH+9X0va6/wuPLoEJa7/EGjjG5
         i76qmGuO//7Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C133FC00445;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/1] sctp: sysctl: make extra pointers netns aware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087881678.21711.18097135449442025698.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:00:16 +0000
References: <20221209054854.23889-1-firo.yang@suse.com>
In-Reply-To: <20221209054854.23889-1-firo.yang@suse.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     marcelo.leitner@gmail.com, kuba@kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, mkubecek@suse.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 13:48:54 +0800 you wrote:
> Recently, a customer reported that from their container whose
> net namespace is different to the host's init_net, they can't set
> the container's net.sctp.rto_max to any value smaller than
> init_net.sctp.rto_min.
> 
> For instance,
> Host:
> sudo sysctl net.sctp.rto_min
> net.sctp.rto_min = 1000
> 
> [...]

Here is the summary with links:
  - [v3,1/1] sctp: sysctl: make extra pointers netns aware
    https://git.kernel.org/netdev/net-next/c/da05cecc4939

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


