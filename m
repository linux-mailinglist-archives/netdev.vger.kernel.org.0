Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3969C843
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjBTKKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBTKKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E0FCC22;
        Mon, 20 Feb 2023 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9EFD60DBE;
        Mon, 20 Feb 2023 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 423CBC4339E;
        Mon, 20 Feb 2023 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676887816;
        bh=aw3B4QHqZ58TWWioz2LhXTopj34mwZYGDnu7RFLVSaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t4R62qU1EsweFIRZ3QhdZr7Y/kmxMuNcdeqOWeBsektJPDboL07JFy+adUemQirPm
         4p1iQm42XOC9XADaCH7nYoNlERH+r7z3cSm9qt3T+zJpanFk6OXaCW+hPqmNdCuvDs
         wuuHOhc64GMO2jRySrN0GazEifNdN7r9vWdKYOqoUXyJABWFhooFFXRzy8/7lss0AY
         qaPY2v1HKCqjv9RZeO6U5dZwa4dTm6LZn6ySza4yV1xBYNeGMV/87VB3w3k/ABcGh3
         lQXTVpOU/sgopBDbwzx8k9OQzIAURyHwpijtPDkrsWdwtkaKiHLBig3zg0s13tmyxA
         xRjFsVxrJXqog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2807FE68D20;
        Mon, 20 Feb 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: fix MoCA LED control
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688781616.25409.16537804406709327496.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:10:16 +0000
References: <20230216194128.3593734-1-opendmb@gmail.com>
In-Reply-To: <20230216194128.3593734-1-opendmb@gmail.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wahrenst@gmx.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 16 Feb 2023 11:41:28 -0800 you wrote:
> When the bcmgenet_mii_config() code was refactored it was missed
> that the LED control for the MoCA interface got overwritten by
> the port_ctrl value. Its previous programming is restored here.
> 
> Fixes: 4f8d81b77e66 ("net: bcmgenet: Refactor register access in bcmgenet_mii_config")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: fix MoCA LED control
    https://git.kernel.org/netdev/net/c/a7515af9fb8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


