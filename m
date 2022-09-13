Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F385B6935
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiIMIKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiIMIKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400EDFBA
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF55E6134E
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 08:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16D71C43470;
        Tue, 13 Sep 2022 08:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663056614;
        bh=UoakwJMeYTiBUV6ZoSeai0RH6VkgwHDLntd7rIdALfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MptBX/tZ+1ejrpTPIrrhAYdK2UuryKxmFDz6t0B1W/KN9BNU6mn58PegX+Om/p2iq
         hIuGjW2G/qNaaAKEAGySwRuGYMz2xt1EdBAV8NfeflT/hDU1cUt4J9hqPnngU/Xo62
         kN1J7sUdUZ28DNUnCSvIz8RewPmXchJ0a5uCiMYDPTpi6tzZnr95EuVKdN0ZgXi03b
         16CviwCyhs/1INGvCPqnlkgAwiN3fUiXO3GJHAWhYImLN1F3eyvqORWlVXBDlYJG9A
         nlmiRvWVRG63MDi91RXcdryuIg+QEiU5Vc0a8LZtSNC4UtDunEXYrSWb9tq2OyQ8To
         1RS5x98ElFWuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E84CEC73FED;
        Tue, 13 Sep 2022 08:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: phy: aquantia: wait for the suspend/resume
 operations to finish
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166305661394.26664.5971576545011179692.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Sep 2022 08:10:13 +0000
References: <20220906130451.1483448-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220906130451.1483448-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Sep 2022 16:04:51 +0300 you wrote:
> The Aquantia datasheet notes that after issuing a Processor-Intensive
> MDIO operation, like changing the low-power state of the device, the
> driver should wait for the operation to finish before issuing a new MDIO
> command.
> 
> The new aqr107_wait_processor_intensive_op() function is added which can
> be used after these kind of MDIO operations. At the moment, we are only
> adding it at the end of the suspend/resume calls.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: phy: aquantia: wait for the suspend/resume operations to finish
    https://git.kernel.org/netdev/net/c/ca2dccdeeb49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


