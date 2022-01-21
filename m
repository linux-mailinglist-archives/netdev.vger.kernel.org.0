Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132224959A8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378599AbiAUGAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378598AbiAUGAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37460C06173F
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 22:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5016E616BD
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD7DFC340EA;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642744813;
        bh=onzouLhMpXf6kXry2+DPC6QAhFr2IaamcS+DblFnoys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F0lsbEcj4n+DAOz1BQduJidJLYgeeIWBDzzmCVzKG9qcNr0nm9m3nLvc2TCL2oHNS
         L1byNN0nSLfMuHZ6qUgBhfaqmHBZx/4lRXqSqllnebRNQruk7ENfI1cCFTtrMIpotr
         e79HxglZ33qFCSBemLL13jzNNMeZd8MTPmXNJdh/gUuDn70YzefJCuGvsg6h+Av23h
         6xUmeddWBo6cuL5k4J2mOoR4fNBGuRurOF6EEoV3O5L/iswkKA2p5U+nSoFYfgpnTu
         cbJlPpD2SbQPrco8Co7hf28Z3+2BsLjHzfgNWvdeS47+fvZdLC8gZvvWSPw5MT+iYc
         ircZ46tU9hoNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F52CF6079C;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mptcp: A few fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164274481358.1814.10002816263958082331.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 06:00:13 +0000
References: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Jan 2022 16:35:26 -0800 you wrote:
> Here are some fixes from the mptcp tree:
> 
> Patch 1 fixes a RCU locking issue when processing a netlink command that
> updates endpoint flags in the in-kernel MPTCP path manager.
> 
> Patch 2 fixes a typo affecting available endpoint id tracking.
> 
> [...]

Here is the summary with links:
  - [net,1/3] mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
    https://git.kernel.org/netdev/net/c/8e9eacad7ec7
  - [net,2/3] mptcp: fix removing ids bitmap setting
    https://git.kernel.org/netdev/net/c/a4c0214fbee9
  - [net,3/3] selftests: mptcp: fix ipv6 routing setup
    https://git.kernel.org/netdev/net/c/9846921dba49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


