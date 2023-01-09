Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20945661F3C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbjAIHa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbjAIHaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D7C1275A;
        Sun,  8 Jan 2023 23:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B5B3B80D23;
        Mon,  9 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F434C433F1;
        Mon,  9 Jan 2023 07:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673249417;
        bh=rxvMuB+GUrbXVcEBUczCRIGB/h1hv6C2Y6PHV/qwSOU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F3nF1cqMIaYD+rzSmxWaxC32u4ihYxUNqNH5O9ZACtUI60FqDIyYjs7JPe/bZTF68
         5yfrNedkc6ryumVmw3RvyPJX31mK1hJn6pc5O8XRPIcw2RXumrE+bFf3NxLG3/f1Ev
         IpUsxyq1RVbo9EkAbX7YwaCTmNEYfZeDM2VVUGPVqLqAw/s/B0cgw4EVqL5C/TU+AN
         4EhUCV0wMkUmwrMIPd6IEhRDNVazUanlnYSBmW/k5DQVaoZCAoB+BkHOdfDFwKtS0n
         fwjOYREhDEf982oJKNdmSKlW4pngZmgPI+n6LDUAaXqGU0ZSjRgWV1fw1AFoLsCZ8c
         YG1LWCN1Bqxsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFBBBE21EE6;
        Mon,  9 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 0/2] Fixed warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167324941697.24554.3531681744260203489.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:30:16 +0000
References: <20230106082905.1159-1-Divya.Koppera@microchip.com>
In-Reply-To: <20230106082905.1159-1-Divya.Koppera@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        alexanderduyck@fb.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 6 Jan 2023 13:59:03 +0530 you wrote:
> Fixed warnings related to PTR_ERR and initialization.
> 
> Divya Koppera (2):
>   net: phy: micrel: Fixed error related to uninitialized symbol ret
>   net: phy: micrel: Fix warn: passing zero to PTR_ERR
> 
>  drivers/net/phy/micrel.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> [...]

Here is the summary with links:
  - [v6,net-next,1/2] net: phy: micrel: Fixed error related to uninitialized symbol ret
    https://git.kernel.org/netdev/net-next/c/d50ede4f53e1
  - [v6,net-next,2/2] net: phy: micrel: Fix warn: passing zero to PTR_ERR
    https://git.kernel.org/netdev/net-next/c/3f88d7d1be42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


