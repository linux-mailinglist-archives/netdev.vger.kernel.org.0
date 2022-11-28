Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBE63A6CC
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiK1LKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiK1LKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:10:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C013C193C0;
        Mon, 28 Nov 2022 03:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58FCC610FB;
        Mon, 28 Nov 2022 11:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD5CFC43470;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669633831;
        bh=wHP7An3IN//nhGkndn+m0DMYj5VPZfioj+F/jzN/yE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gt+DrNEkKwzyK+tPq8z7RbUE4Tn/fuPO77SZSC6BbX0nCMG7gUFt9P0/BQHSlF9Of
         Zm2M/RFOyyZdtk0vuNTDqO2vyior87uTsm1N8Ra9xl8hIdXbSjsK4nntCGCWfte5oJ
         kBYn1fXs3waY8I04pw2LlMzT0r9iuLB1KXXxWhAxR3PkixxicJ/dhuxvjbVu1vGhNK
         yPVKhjUjPFI28vjNpn3XR8CegKfhrB1dBmFyQOGPgctn1hl6iwRKCvfgSq6PGnL0tI
         uI05ZP+TS3JFdYINTJwI3U4VgD3BFYGtbBUvE5KhgttOczMAtdFvO1wjmiAFqZa5da
         0Q6YP8Qilj24w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89F64E29F3B;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: fix error handling in
 am65_cpsw_nuss_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963383155.22058.1909402777218010175.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:10:31 +0000
References: <1669258989-18277-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1669258989-18277-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, grygorii.strashko@ti.com,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, 24 Nov 2022 11:03:08 +0800 you wrote:
> The am65_cpsw_nuss_cleanup_ndev() function calls unregister_netdev()
> even if register_netdev() fails, which triggers WARN_ON(1) in
> unregister_netdevice_many(). To fix it, make sure that
> unregister_netdev() is called only on registered netdev.
> 
> Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()
    https://git.kernel.org/netdev/net/c/46fb6512538d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


