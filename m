Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ABE6749AA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjATDAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjATDAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099629F3A1;
        Thu, 19 Jan 2023 19:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B4D61DE4;
        Fri, 20 Jan 2023 03:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC71CC433F1;
        Fri, 20 Jan 2023 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674183618;
        bh=TUlF/UkyYMykIbN2dcybW735XtmZNjZttJvL4i2P4nM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OuV3oWSWIEcM0DzZTPHNGaauZRSkoRQgixXE5LS6dxyzaBQkYnB4rIKgUOco/EAVT
         jDFNle8WGxJQ+jQJOoOoyba0K6bQaVS7wA6bodQC8Jvi3QCO+fx25GW7gyxESw9uwe
         01/TLzTS28fDD/+cm4+Q33p2nMieAN3rEKbbBpF6XpCjFYvT5KZlADBOZDCXo85vzB
         0b28sctnPSjjDpYk9hKN74GofpfCmcPfXdqcVDzl/NDapUZUEacdHPd3yFA6lO8ph2
         BPktCmdprfYC3FigV2YjLqq8x+lRXlRdWMHstO0I6qu9y8Z+AsFeETFfZ2ODa5WWFc
         6Bk95kofxggFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8748E4D01B;
        Fri, 20 Jan 2023 03:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: microchip: ptp: Fix error code in
 ksz_hwtstamp_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167418361874.28289.5370339181727219172.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 03:00:18 +0000
References: <Y8fJxSvbl7UNVHh/@kili>
In-Reply-To: <Y8fJxSvbl7UNVHh/@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     woojung.huh@microchip.com, ceggers@arri.de,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        arun.ramadoss@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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

On Wed, 18 Jan 2023 13:28:21 +0300 you wrote:
> We want to return negative error codes here but the copy_to/from_user()
> functions return the number of bytes remaining to be copied.
> 
> Fixes: c59e12a140fb ("net: dsa: microchip: ptp: Initial hardware time stamping support")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/net/dsa/microchip/ksz_ptp.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: microchip: ptp: Fix error code in ksz_hwtstamp_set()
    https://git.kernel.org/netdev/net-next/c/a76e88c29425

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


