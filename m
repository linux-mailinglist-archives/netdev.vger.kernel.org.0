Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5562769758A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjBOEu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBOEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B292DE43
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D4BFB81E2A
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A055CC4339C;
        Wed, 15 Feb 2023 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436617;
        bh=eyiDMeGx1SS3WXxeMgneYJbYi1XRnaebNNXkT/T84cA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xo7sNxFSxeSHiqJvbxKa8PQ9lqW96sirUBhl9oVigXtGRypZmfaflta6uYQyyz2xJ
         agyIrO19Mm9qv8iBTWSXdZczJaLG4kfCEaJkBA7+7Idt0jMQG0CGxKHyLHTJ/f3Dde
         5kufLMMd4Ma7SqcLJT6PbnHLcSsK4fRY8dKi+cp55hemQjHZRB22/H/Otgon8En9Ht
         oKLEe3Ebp8mN2lP+AWY24qaWCT4nCxbD3C+Q7bnjgNrIJV5jr/jpUnvrO73yCsks22
         lLlpY6jRCtx/AD3XNy4fg64rBbgYXeuM20Wjt6n+HuBSTBVKIBwdCTBFaeXDkB98eA
         4vprPKgf55dBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86BE6E29F41;
        Wed, 15 Feb 2023 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-02-13 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643661754.17897.6291221610913990445.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:50:17 +0000
References: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230213185259.3959224-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 13 Feb 2023 10:52:57 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Michal fixes check of scheduling node weight and priority to be done
> against desired value, not current value.
> 
> Jesse adds setting of all multicast when adding promiscuous mode to
> resolve traffic being lost due to filter settings.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: Fix check for weight and priority of a scheduling node
    https://git.kernel.org/netdev/net/c/3e6dc119a37b
  - [net,2/2] ice: fix lost multicast packets in promisc mode
    https://git.kernel.org/netdev/net/c/43fbca02c2dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


