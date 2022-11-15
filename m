Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCA5629194
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiKOFkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiKOFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF71B9D1;
        Mon, 14 Nov 2022 21:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A13C6154A;
        Tue, 15 Nov 2022 05:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E2C0C4314C;
        Tue, 15 Nov 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668490815;
        bh=LT8W/8foA59Lc/+Wq64t2PU2vWoZ3b7gfR6WBUTSqwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ez4Yn8eEQYGJdTThPEUIB9gVObRLF0DsUdh4UTcVSipordUy7piad56a34Sj0mnbm
         hWjGAozEtV7ECyB2i+5j1UuZktyc9E8bbqidjbsqSErNcBhV4xbHPGTnq8TirIiLtw
         fqL6NvTVraM8TUyaA5rlH1KTTs0TPoz3yYlTz9RPWUH3poNcoNN039c83SH2lJRFko
         YN3Rf4virILQV6a2pi6Qf0IpVWIM2Crl3eWlO/cmQBvd6zN5dcSjMybcORTCecBIEc
         o/4jyjDyC6KSrHOGJMUa4sPZY5Pqxh7dMDS1Q7+0+lr4GGnQKgNqnQkI4BNBG1rpGz
         VcJqppE2pstOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C355E4D021;
        Tue, 15 Nov 2022 05:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] tcp: Add listening address to SYN flood message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166849081517.10793.8434157645254385822.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 05:40:15 +0000
References: <4fedab7ce54a389aeadbdc639f6b4f4988e9d2d7.1668386107.git.jamie.bainbridge@gmail.com>
In-Reply-To: <4fedab7ce54a389aeadbdc639f6b4f4988e9d2d7.1668386107.git.jamie.bainbridge@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 14 Nov 2022 12:00:08 +1100 you wrote:
> The SYN flood message prints the listening port number, but with many
> processes bound to the same port on different IPs, it's impossible to
> tell which socket is the problem.
> 
> Add the listen IP address to the SYN flood message.
> 
> For IPv6 use "[IP]:port" as per RFC-5952 and to provide ease of
> copy-paste to "ss" filters. For IPv4 use "IP:port" to match.
> 
> [...]

Here is the summary with links:
  - [v3] tcp: Add listening address to SYN flood message
    https://git.kernel.org/netdev/net-next/c/d9282e48c608

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


