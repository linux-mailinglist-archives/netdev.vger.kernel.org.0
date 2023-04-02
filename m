Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63756D37E4
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjDBMkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDBMkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFA49740;
        Sun,  2 Apr 2023 05:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 121B1611D8;
        Sun,  2 Apr 2023 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 698BCC4339C;
        Sun,  2 Apr 2023 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680439217;
        bh=Thl461YmRiXcYQIaPiNMd2KjfJL5dnXi69gC+xBBIx8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GzvhQKjUU2JqRYIWVLY8YRefeOKi58TW1e5zfvrIgANQN9S4P0LzG1m0cilqxBfC0
         wurxhvt0FyIEjjly2UWCpkzU4uq14C5kNFuMuAAypyCsF66XwTUBXo1jMIxZYhgmWI
         Y2Ll+ocReKEdXpxMIKv6GNhi4Kh0xLWJV6kUV17RA0TgleSjCyaOR+wcRwIs3qU2Ii
         vFXSAOSrqw51qKXHo6VzIDNFg8l5lkYYt8MOfh7OgNPHPpK1GPtPgDjjckiRO776Ab
         hvqlsNRoY0tcrwcxiYIXCsczpj/lIePXtdggzFdJPfyQf5mcMjmbDeKgyP+RpBWtf7
         74j5QbZ2UnKGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4DC77E21EE4;
        Sun,  2 Apr 2023 12:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: Reset mv88e6393x force WD event
 bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043921731.11869.10697921708685299184.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:40:17 +0000
References: <20230331084014.1144597-1-gustav.ekelund@axis.com>
In-Reply-To: <20230331084014.1144597-1-gustav.ekelund@axis.com>
To:     Gustav Ekelund <gustav.ekelund@axis.com>
Cc:     marek.behun@nic.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@axis.com,
        gustaek@axis.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Mar 2023 10:40:13 +0200 you wrote:
> From: Gustav Ekelund <gustaek@axis.com>
> 
> The force watchdog event bit is not cleared during SW reset in the
> mv88e6393x switch. This is a different behavior compared to mv886390 which
> clears the force WD event bit as advertised. This causes a force WD event
> to be handled over and over again as the SW reset following the event never
> clears the force WD event bit.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit
    https://git.kernel.org/netdev/net/c/089b91a0155c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


