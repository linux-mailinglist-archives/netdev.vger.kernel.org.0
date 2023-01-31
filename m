Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3B68239F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjAaFKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjAaFKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D8E24490
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D61612FB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5389AC433EF;
        Tue, 31 Jan 2023 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675141816;
        bh=jKedFnEceM72ZEAj9b+ooelG7j0c7YwzlDaQVlauPkE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b5RsJUuM6mgd2GzdHOxsOzliwLYWoQ3Avyu6w+oHSGboykxmTifhKRWSLyylducOZ
         Ga8OKc3ON7J7IMlNzZge8y+njGCaXsKDl9Lliasi/Qt0W8FC/v5XzOXhk3fXGJv9vc
         UhVMHF3wGO6fiG1a6XZbfnu9QZKuGHeIwurqUeC7Edq9Q38oeZcXD37kw6/OzH07+C
         1iAWI2fISfUY9XBomHCVGH4FULK83OowfjzkiB1opCz/7W6HxaVz3jeUldvG3AnIeS
         bVa3ezCn2GWd+qLdtN7ZXEPpTfohigPwLueZ5B6iKG69OiC5IHjR545pfdSP4OP5Th
         frF2DBr3bj1kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B7B7C1614B;
        Tue, 31 Jan 2023 05:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2][pull request] Intel Wired LAN Driver Updates
 2023-01-27 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167514181623.11863.2652098386821137448.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 05:10:16 +0000
References: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, leonro@nvidia.com
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

On Fri, 27 Jan 2023 14:53:31 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Dave prevents modifying channels when RDMA is active as this will break
> RDMA traffic.
> 
> Michal fixes a broken URL.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] ice: Prevent set_channel from changing queues while RDMA active
    https://git.kernel.org/netdev/net/c/a6a0974aae42
  - [net,v4,2/2] ice: Fix broken link in ice NAPI doc
    https://git.kernel.org/netdev/net/c/53b9b77dcf48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


