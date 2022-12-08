Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9730264666A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLHBUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLHBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62038E5A6;
        Wed,  7 Dec 2022 17:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6330961D32;
        Thu,  8 Dec 2022 01:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0835C43148;
        Thu,  8 Dec 2022 01:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670462417;
        bh=NZ7GBoINAk7yYTe63v8Kk4JXgtjmGEpApv+0pFZVHwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=trIoKWz0HA1qcw44qDcftADr6HDYZAJKPrj2pO3/waCod72ehoSjCXZfzIw5cdjA8
         mxoPaSLk4sjIyrqhDkzzPTa11+TK/i12ohGzdwne15zIwGqXJEsXSfCYMLRB7jtfv+
         iQkIcK9/rwE3/PnFYgQOcgdjqveM/0sfpE2Yo930UoLFDaBQ6lbxj886FelnirGZ3Y
         ivyFGsUtnKonkh7aazGfHVfjdoq8k6TMbI4HuIz195bSNk0Vs+JC+EO8qa32Pv4jX3
         5QaQSFRur3INTm0SOPR0soXzaE70N9RvIJ0BZYK7UOvu5L19ypB+MZoNDeATJKEQEE
         5iM7EeGYF+ZnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABBA8E29F38;
        Thu,  8 Dec 2022 01:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: asix: add support for the Linux
 Automation GmbH USB 10Base-T1L
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167046241770.30697.16491193342103336456.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 01:20:17 +0000
References: <20221205132102.2941732-1-o.rempel@pengutronix.de>
In-Reply-To: <20221205132102.2941732-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lukas@wunner.de, linux@armlinux.org.uk
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

On Mon,  5 Dec 2022 14:21:02 +0100 you wrote:
> Add ASIX based USB 10Base-T1L adapter support:
> https://linux-automation.com/en/products/usb-t1l.html
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/usb/asix_devices.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Here is the summary with links:
  - [net-next,v1,1/1] net: asix: add support for the Linux Automation GmbH USB 10Base-T1L
    https://git.kernel.org/netdev/net-next/c/5608e0a817ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


