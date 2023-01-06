Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8611F6600DE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjAFNAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbjAFNA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:00:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600926B583
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16469B81D3E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AA18C433F0;
        Fri,  6 Jan 2023 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673010016;
        bh=TTvJHvU3JxbDPnsc0WAhpQjLtugVdN/lbhixt4wrdXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ab3q42P8tr+9hnN25zpMkYVEEwwxP7ESMIskFsUCy2K5WivIQjC7dw9WCvMiZLptv
         2A9shD+FCYlja3ASD1JR9RUl5mhpfBVW11xuEI5Z3yRcvl3R0tcpnBR91sh584twgg
         c7dMxj3REldRJVfWqBi2tGBeAQ25C7ZVWUPC8uwz1+u7wS2t5flc2wwekJ3hQAdxNy
         /U5/RQWKTGgPK7E8h8PqCkibZG4JHcwZ76aObuoUEm2QfcR7jromEyHmmrdIBfKHof
         GWcDYjAOgOXGOwdq7Dyt0uHu85oMnLfY8AoHaxDxayz4zhdBqB2PQPFunxOHEQcs7d
         GSs7K2Us/yc1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BDADE270EC;
        Fri,  6 Jan 2023 13:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/1] tipc: fix unexpected link reset due to discovery
 messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167301001643.32012.2626222000937248173.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 13:00:16 +0000
References: <20230105060251.144515-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20230105060251.144515-1-tung.q.nguyen@dektech.com.au>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jmaloy@redhat.com,
        ying.xue@windriver.com
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

On Thu,  5 Jan 2023 06:02:51 +0000 you wrote:
> This unexpected behavior is observed:
> 
> node 1                    | node 2
> ------                    | ------
> link is established       | link is established
> reboot                    | link is reset
> up                        | send discovery message
> receive discovery message |
> link is established       | link is established
> send discovery message    |
>                           | receive discovery message
>                           | link is reset (unexpected)
>                           | send reset message
> link is reset             |
> 
> [...]

Here is the summary with links:
  - [v2,net,1/1] tipc: fix unexpected link reset due to discovery messages
    https://git.kernel.org/netdev/net/c/c244c092f1ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


