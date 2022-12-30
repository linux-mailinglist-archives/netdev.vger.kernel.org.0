Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1B46595E9
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiL3HuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiL3HuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68210040;
        Thu, 29 Dec 2022 23:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3172F61A70;
        Fri, 30 Dec 2022 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8659DC433F0;
        Fri, 30 Dec 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386616;
        bh=dRfTWcimoeqlfeLamBb9cWZ6GOHkUMpkXehBHdmtwRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VVwuxewveMRJzUbh8pVe0MWtSe8wqghtsvSQoHOQorsGNuqUpKxNB7uorMGS8GD2l
         eeze9+I8snNlegixBx34poMh/DL4PyKo4gcOg9rotS2Ii850ayem870eXCJBA2Ye9H
         JGknydqJMt4o1D/CINVICIM7xq4ZLkTr+5h0TQ9mli6r98QcN/EEZhcaSvv1r1o0sK
         kDfetqRnrf7R19pAvgXJ74Pz2iuwrvy/rG+gko6JryDIDEgde4un+kU7ok0PgG74+k
         iqhUAOkX+ruocAsgn1a7TTJj7ThJa6V3Pu+M5NfW2kKq2UIqPuf1cIEDMqnVUZ4k40
         NAnARFZBVc9xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C42AC395DF;
        Fri, 30 Dec 2022 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: xgmiitorgmii: Fix refcount leak in
 xgmiitorgmii_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238661644.5828.309710303192630633.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:50:16 +0000
References: <20221229062925.1372931-1-linmq006@gmail.com>
In-Reply-To: <20221229062925.1372931-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com, f.fainelli@gmail.com,
        brandon.maier@rockwellcollins.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

On Thu, 29 Dec 2022 10:29:25 +0400 you wrote:
> of_phy_find_device() return device node with refcount incremented.
> Call put_device() to relese it when not needed anymore.
> 
> Fixes: ab4e6ee578e8 ("net: phy: xgmiitorgmii: Check phy_driver ready before accessing")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/phy/xilinx_gmii2rgmii.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
    https://git.kernel.org/netdev/net/c/d039535850ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


