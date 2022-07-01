Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03056338E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbiGAMkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiGAMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0653B02C;
        Fri,  1 Jul 2022 05:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 873A7B83014;
        Fri,  1 Jul 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C146C341CB;
        Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656679215;
        bh=buwRP++rh+8XQf7AI0IC+vvqzS8C1QYs2pdmZ29AddE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=APJg9koryoPo3ki5sq8W136gsxVg4MGfpcxx6d5FSV1MqQ2E0agygPhtia0sVTi1G
         IkT4otFUzts2CTX4ZoK6fk1vyOSLUvAepVBBn5DtBFbjAlddFMd4+I4sSS3lmbK5aq
         tCZNjTb2I1VJgNz+yjrqMTjmgqwagzNLI1d92hv8KAyVWldSoLEDEyn4Ww6ukQyqI4
         rNq/4QQboQOp/krDaXiHqc1qfr7JZwTQEWedcorKJZ3uEP30r1njq9zVNa2zH2zsFT
         zWxBh7SsZZUdqxNm10guLBQs+PKTOq6acthKwZPumXP+X3pRuoHXwogbaYeWM25Z6x
         tzVEwNY+HoCJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18743E49FA0;
        Fri,  1 Jul 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cdc-eem: always use BIT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667921508.18764.8286780084229794603.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 12:40:15 +0000
References: <20220630115109.7522-1-oneukum@suse.com>
In-Reply-To: <20220630115109.7522-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Jun 2022 13:51:09 +0200 you wrote:
> Either you use BIT(x) or 1 << x in the same expression.
> Mixing them is ridiculous. Go to BIT()
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/cdc_eem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - cdc-eem: always use BIT
    https://git.kernel.org/netdev/net-next/c/7fa2d1707d41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


