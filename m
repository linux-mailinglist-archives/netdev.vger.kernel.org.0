Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78CC5E678E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiIVPuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiIVPu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C658DF87;
        Thu, 22 Sep 2022 08:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBF0FB838AB;
        Thu, 22 Sep 2022 15:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FD38C433D7;
        Thu, 22 Sep 2022 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663861815;
        bh=P6g40CLQGzIX6ifmQmuwtYebzCG5vkEOzxXnaC8NY/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k8yH69AbCMPtTyFcTCZcpyilav0FBq5iuaWbGB0k5iizuxLBnyRR+WiO/xCQbEUXB
         dW1AdF18CIOpc2mMOklhZrYgugWhJdLAjteGRPhjDpl3V4TXwLDjV2KAPkiVSJGE1t
         YNjnFmWiZ7lkeRlEGEuBVw8uIXNRlmJ9RD4mFw/8F6CwHIx6I7BdP/9spERUklKxLm
         rMgs1svBnnpvElmfpwYdD/tzYaYCHLQIFEl+kzmsoGhzDtpDbbKXzivteWWeClDReu
         Ven7J3IpwNuh7MeAxpmOkV9FYnT+alH6Mn+VZVkli9t5xIKgns1jwHg5SvnrPgpCdT
         bmrqV2/Yx6Vgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7505AE4D03D;
        Thu, 22 Sep 2022 15:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: ethernet: adi: Fix invalid parent name length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166386181547.2610.4116048326764999279.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 15:50:15 +0000
References: <20220922063049.10388-1-alexandru.tachici@analog.com>
In-Reply-To: <20220922063049.10388-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.andrei.tachici@gmail.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com
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

On Thu, 22 Sep 2022 09:30:49 +0300 you wrote:
> MII_BUS_ID_SIZE is larger than MAX_PHYS_ITEM_ID_LEN
> so we use the former here to set the parent port id.
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/ethernet/adi/adin1110.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: ethernet: adi: Fix invalid parent name length
    https://git.kernel.org/netdev/net-next/c/2b9977470b39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


