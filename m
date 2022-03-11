Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A994D598D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbiCKEbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346247AbiCKEbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:31:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E83E1A39F2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D057961953
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 358D5C340F3;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973013;
        bh=1HY+J2PY5trbwy2faBfOc4cn5y0GDPN9YSeWTCqhyKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BqM3pykiKXgtQxJQeWlPojbpnyLoMsSB6T5KHq+X+qc0Hxi2Bpz9KWxJ8ctu3E67x
         YljYEwT36nQbvMvJofMGR9Qf4L6KS6twOf1JeRPYqF4sEEyWzf8x0UtrUMj9WlvDhZ
         ihcm5f0nPWjPgXgGku0/KNUBJd3D+nEnC35c8p3Ry6fmgNbwEH3scliLuoElzKqxTo
         efdThSUj4GjktnTo40KSLcwAoiA1wpLz/pw7RKnbogRBXNQsQvKbAXULFVaEbSHvfF
         GsTr3Bn4RRTnRV++56kypxws723cHyRm5zYbNM7HVq3QWsBhT6rXhJjmIw23QyTzOn
         E0ksxwf4KECiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17301F03841;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-03-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697301309.12732.15401515532854177642.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:30:13 +0000
References: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed,  9 Mar 2022 11:03:10 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Martyna implements switchdev filtering on inner EtherType field for
> tunnels.
> 
> Marcin adds reporting of slowpath statistics for port representors.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: Add support for inner etype in switchdev
    https://git.kernel.org/netdev/net-next/c/34a897758efe
  - [net-next,2/5] ice: Add slow path offload stats on port representor in switchdev
    https://git.kernel.org/netdev/net-next/c/c8ff29b58742
  - [net-next,3/5] ice: change "can't set link" message to dbg level
    https://git.kernel.org/netdev/net-next/c/ad24d9ebc446
  - [net-next,4/5] ice: avoid XDP checks in ice_clean_tx_irq()
    https://git.kernel.org/netdev/net-next/c/457a02f03e92
  - [net-next,5/5] ice: Add support for outer dest MAC for ADQ tunnels
    https://git.kernel.org/netdev/net-next/c/02ddec1986ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


