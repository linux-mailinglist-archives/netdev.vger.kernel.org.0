Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B7E5E70C0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiIWAkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiIWAkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77D7B72A8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 17:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 375C6B834DC
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C696BC43470;
        Fri, 23 Sep 2022 00:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663893616;
        bh=Whndml1pHxD/nV4R1RDlui0LtTgeLyDx48Sp3KOhd2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KgPXFTd+2IDJAt4KCjdjR7r2QaJkvyuWqlzKKTQ1Ym0Z9VdwFrWLInp3FBnG0gOep
         sV/jqu6lGjYN7k+4JTMeI2HEZEWimJwi6FOr5Tbmec01HzISfFeaKWTDI+oXO3Q7sf
         //tMNfUYEeqrzNHVa1PKxW9gVRUCNao3bsyu1vYa4hFtp04SO82hKsUocUu7sIVXEP
         KKfLLD8QIoeBPzS/SAUVSEZdjKC6VIx0ascnbUPe22yRMrxIDPaChD8mqlYucdlKlf
         /yfDf3SvSe0zLh14Q725JHguSALeZavPvkeTFyYbw3u3ljZQsLzroYbr7Qnp5cxgtZ
         USvGpzuKZmIZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4759E4D03D;
        Fri, 23 Sep 2022 00:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] bnxt_en: replace reset with config timestamps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166389361666.358.15863956184982535662.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 00:40:16 +0000
References: <20220922191038.29921-1-vfedorenko@novek.ru>
In-Reply-To: <20220922191038.29921-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
        netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        richardcochran@gmail.com
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

On Thu, 22 Sep 2022 22:10:38 +0300 you wrote:
> Any change to the hardware timestamps configuration triggers nic restart,
> which breaks transmition and reception of network packets for a while.
> But there is no need to fully restart the device because while configuring
> hardware timestamps. The code for changing configuration runs after all
> of the initialisation, when the NIC is actually up and running. This patch
> changes the code that ioctl will only update configuration registers and
> will not trigger carrier status change, but in case of timestamps for
> all rx packetes it fallbacks to close()/open() sequnce because of
> synchronization issues in the hardware. Tested on BCM57504.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] bnxt_en: replace reset with config timestamps
    https://git.kernel.org/netdev/net-next/c/8db3d514e967

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


