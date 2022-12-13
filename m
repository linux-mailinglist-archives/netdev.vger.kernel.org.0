Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E8364AE77
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiLMDv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiLMDvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:51:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1361F2E7;
        Mon, 12 Dec 2022 19:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78551B808BB;
        Tue, 13 Dec 2022 03:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E9D7C433F1;
        Tue, 13 Dec 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670903416;
        bh=BT8OHaV2tjYMg1V3salQG9z9OJouBX098LNgTtQQFQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J5Dv3P5dOIhTaiZGoctHcYrBMaUynTGk+lHJUsPWglPqWh+Y4fNNPma5G3brsTEMt
         MDpxao80aMlu4QsJep/Cr1w8TjZgCA8sJi+ZuB+I6Go/7BXXvQG72813MiqKOd0nXt
         WYfdDvxMM4/kmBYc8/Jb9CQV0e+Qlf2rkz4kkGMnnztOv2dq1rjVy3IkB8pI7oQKBp
         yOhGWThG2eUpLkjlAw1/oqJAMOPYy8zGBiSPdVmjzezJNPFfPcWMnMFITHO6GUV+Vk
         8E3sIanjYS8DOYj8bcwZluGetF+am+QAAnDPyb98IwtPNs4REjPUup18cJlHHLBmh+
         pT6LyBnWBkHWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 174D3C41622;
        Tue, 13 Dec 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Remove a useless test in
 lan966x_ptp_add_trap()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167090341609.4783.16305690023365204184.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Dec 2022 03:50:16 +0000
References: <27992ffcee47fc865ce87274d6dfcffe7a1e69e0.1670873784.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <27992ffcee47fc865ce87274d6dfcffe7a1e69e0.1670873784.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
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

On Mon, 12 Dec 2022 20:37:16 +0100 you wrote:
> vcap_alloc_rule() can't return NULL.
> 
> So remove some dead-code
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: lan966x: Remove a useless test in lan966x_ptp_add_trap()
    https://git.kernel.org/netdev/net-next/c/d1c722867f80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


