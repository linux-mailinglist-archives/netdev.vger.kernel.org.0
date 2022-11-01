Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A54614F3A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiKAQa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiKAQaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4B81CB3C;
        Tue,  1 Nov 2022 09:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AB376168E;
        Tue,  1 Nov 2022 16:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E32D0C43144;
        Tue,  1 Nov 2022 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667320216;
        bh=MqX5Xq+81ySRhF8S5eHYXE3jionRZDIjpot0OnG7gwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T3/amttyDcFJPMsq7wYH74tVy/NULQPEZuncBAQspRXD688wcVD7XOQShoihLE4yO
         JFAQX8ScJ4crTgomxNyZ2F4j4LKosvXL+joV6Utx05IiRL0DGOEzJLVTyQ2yi3MkzO
         C+NjuI0rIokYmgNnpxsEobYUFj34RK99Q9EEH5Ud/9Y/x21Ugrs24QuPZShH+TGtE6
         qQOqv2OfPceU7zEKPL7UbFpwXpdCCyFSCNn3IsnagBibe4QeOMmyGQnlKvNMcBFIYH
         jTATZJg0P8XNBWi5+7l0No3py8D+Y2PX67Oinia+pgK1TiYVEL0I4YGlD4SEtHPixf
         EZEvPlpJKeVZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0749E270D4;
        Tue,  1 Nov 2022 16:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: Fix an error handling path in efx_pci_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166732021577.5316.3437690780501399004.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 16:30:15 +0000
References: <dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jonathan.s.cooper@amd.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 29 Oct 2022 22:57:11 +0200 you wrote:
> If an error occurs after the first kzalloc() the corresponding memory
> allocation is never freed.
> 
> Add the missing kfree() in the error handling path, as already done in the
> remove() function.
> 
> Fixes: 7e773594dada ("sfc: Separate efx_nic memory from net_device memory")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - sfc: Fix an error handling path in efx_pci_probe()
    https://git.kernel.org/netdev/net/c/6c412da54c80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


