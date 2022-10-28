Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A152F610EFA
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiJ1KuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiJ1KuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF3E5073C;
        Fri, 28 Oct 2022 03:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E244AB82950;
        Fri, 28 Oct 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D40CC433C1;
        Fri, 28 Oct 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666954215;
        bh=ZxXioDfVkXsgBZIisE7RUwBlBfkuXIE9EtRaC0E0uD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=phZoO9j6GBlNOBYNbmh1EzJzYjq73jPLhN+aY0VFDEwwLqxHco2m3uK+M1AJ2yiNK
         S0JJt7UPrwYPBG53Y745dKE9LhAMKRriabZhwf+AMdnoqy6SK2zpBwcoCyqFW9abBe
         qoF1YBh++AO3/mqOpQ1Lt80zJalmV5MK9oRXSxfdRTxFs50ZRg/TWA+3DAxVcHZgQr
         DzbIpm8QxgmkZmdf6jnIqAc+IqxlKPgEcZzVmgYdFbAuwqPbfYkNqmn9KyXZnNu16R
         7kV1+dwFI4E4F4+x/rb6eruRb3fNV0WbbnuCsIrSoh/CAY4M53sOl732pMdr6pti8Z
         kkykw6H5umSsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DEAEC41670;
        Fri, 28 Oct 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: emaclite: update reset_lock member documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166695421544.17248.14616815887812482981.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 10:50:15 +0000
References: <1666797324-1780-1-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1666797324-1780-1-git-send-email-radhey.shyam.pandey@amd.com>
To:     Pandey@ci.codeaurora.org,
        Radhey Shyam <radhey.shyam.pandey@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@amd.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 26 Oct 2022 20:45:24 +0530 you wrote:
> Instead of generic description, mention what reset_lock actually
> protects i.e. lock to serialize xmit and tx_timeout execution.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: emaclite: update reset_lock member documentation
    https://git.kernel.org/netdev/net/c/8fdf3f6aba7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


