Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83494B6F56
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbiBOOka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiBOOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6F610242B;
        Tue, 15 Feb 2022 06:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D34CEB81A6B;
        Tue, 15 Feb 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97BE9C340FE;
        Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936011;
        bh=BTyAeRKUCX4nKPYoAM+bIom35KvgaYtL0Oy8gSmCoDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YejL76nfui5aLYADmVTo96nTaPeaEnTJ02HyrUARC4v5zor6etUqN0+K5WStyL5fE
         3YooPk6lOcE8aRNvxIgvP893jhsYIBli59Lcnvx5PU1eazIjC63IywLGcuj/7uwIy7
         2+1QhDI8a7OypWcHU2u3HocIEQKpIQ4dCuvaK9qcqmHvfBrVHH8Y9sSRdbYCoRHuje
         snAEwJiGXKX2+VxznNVy2WhwEDeRaco8oca11+B8L3O0gQvBacpphbP8jPkKbAOAx6
         etIhHrL6ZdS5IiQsnnjM04DNNyLFA1Ksc/mt/OXW1Jd68LoVeIEZHmvWX6d0w9rjxL
         WfaVPfm5yosWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84E5EE6D447;
        Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hso: Use GFP_KERNEL instead of GFP_ATOMIC when possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601153.31968.17892021066503340871.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:11 +0000
References: <93e4c78983de9a20b1f9009d79116591f20fd1c2.1644865733.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <93e4c78983de9a20b1f9009d79116591f20fd1c2.1644865733.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 14 Feb 2022 20:09:06 +0100 you wrote:
> hso_create_device() is only called from function that already use
> GFP_KERNEL. And all the callers are called from the probe function.
> 
> So there is no need here to explicitly require a GFP_ATOMIC when
> allocating memory.
> 
> Use GFP_KERNEL instead.
> 
> [...]

Here is the summary with links:
  - net: hso: Use GFP_KERNEL instead of GFP_ATOMIC when possible
    https://git.kernel.org/netdev/net-next/c/25ce79db8042

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


