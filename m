Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E72633488
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiKVEuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiKVEuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D573D27B18;
        Mon, 21 Nov 2022 20:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724F061550;
        Tue, 22 Nov 2022 04:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEDAAC433D7;
        Tue, 22 Nov 2022 04:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669092615;
        bh=EOdWD9SwiMIEl+SpC1QPNe9H5Uk2/vmmkj2LKlBpGTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t/Lc3lPz4VCkTMTdIFUKwDhFWI3iY7YUopJfSTOMCPo14a5xf4EJ6yxqy9eKn56FQ
         03CgkHV5W03DImhcBo5e4EhbIXQ0Mzz2jy8OPseBlkXOW8n3GBwhgaiyr77OqvbvOj
         GaIpw9LrzUbI/mHrtuwngleG/dS95C9Hb+fyUimaINofnxnq1255wmHdoUXAwoa8mg
         VThpg7ACgUqACxn4l3N+g+T5iiXzsZo7xgq6xr3W8E7FtwOnfCOHF+HCLfFDIRcHJ8
         tCHbUmS0hc58amaR8NwESGBt1OYpYq7DdqMAgIRogkb5FASA/5UKNTVwWEVVCb+tv/
         uWlU9ZbZbtKtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9AACE270C3;
        Tue, 22 Nov 2022 04:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bcmgenet: Clear RGMII_LINK upon link down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909261575.32298.18279636613345935570.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 04:50:15 +0000
References: <20221118213754.1383364-1-f.fainelli@gmail.com>
In-Reply-To: <20221118213754.1383364-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 13:37:54 -0800 you wrote:
> Clear the RGMII_LINK bit upon detecting link down to be consistent with
> setting the bit upon link up. We also move the clearing of the
> out-of-band disable to the runtime initialization rather than for each
> link up/down transition.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bcmgenet: Clear RGMII_LINK upon link down
    https://git.kernel.org/netdev/net-next/c/696450c05181

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


