Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1F76823B9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjAaFUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjAaFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FD1C662;
        Mon, 30 Jan 2023 21:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF9161414;
        Tue, 31 Jan 2023 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A40C1C433D2;
        Tue, 31 Jan 2023 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675142417;
        bh=xEkpRyZMmVKHQ/F824JRcCvTZiUdLYj8Iw9KBkVQY9Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dbzyTS63jadRO/Holk42L2QhJeMpbv95JOh/Rs6MsWh6FVRyRLB4l0kZfxom1YbZF
         HywbRiPrVBUNXrdSNNePQeKmMXmCLVVfqfEyZeYskJrqz4mL8tRFtvMI71z8uq600I
         qI4BYPcwHx1X5FJSVffwuWuZE9iAPUA1IFxE/F2NSCPTz7Nfv6FcACPKs+TAVMy088
         phTkaR1Vf9ZtRpB2EhL2BOmMS9DJhxfg3r98LIU3qxLvfazaq5pQ7ZcIsI7uHpmb6C
         zv0VXh01RWFLGJkp0/1xxEbOfiLnMc2ZpuiLZmMVqQ5NuwNzGEuMh8Izgvd+XOmz4K
         vjEtJtTQtugGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89ABAE4D00A;
        Tue, 31 Jan 2023 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/tls: tls_is_tx_ready() checked list_entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167514241755.16180.8588548790499579737.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 05:20:17 +0000
References: <20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it>
In-Reply-To: <20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        vakul.garg@nxp.com, c.giuffrida@vu.nl, h.j.bos@vu.nl,
        jkl820.git@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 28 Jan 2023 16:29:17 +0000 you wrote:
> tls_is_tx_ready() checks that list_first_entry() does not return NULL.
> This condition can never happen. For empty lists, list_first_entry()
> returns the list_entry() of the head, which is a type confusion.
> Use list_first_entry_or_null() which returns NULL in case of empty
> lists.
> 
> Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> 
> [...]

Here is the summary with links:
  - [net-next] net/tls: tls_is_tx_ready() checked list_entry
    https://git.kernel.org/netdev/net/c/ffe2a2256244

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


