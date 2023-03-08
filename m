Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5615B6B0820
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCHNNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjCHNNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:13:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A83D5CC33;
        Wed,  8 Mar 2023 05:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96C86B81C9B;
        Wed,  8 Mar 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EE7BC4339B;
        Wed,  8 Mar 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678281018;
        bh=3cxnD/ZMdmr0mBswJvXILrvG6xeiPKdXCa+JkV4t7L0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mGkTJ/O0xfDihmhQ5R3q1pCdYkG6EWXZC+xloAwvhtqSnBKpsSOgeZzcv2gjzrNiQ
         8oX/zJ2H5B01kik4waXCV4Wipgr01BRUOvgLn8S90xUSjMLueBaBXxFEjJrTznguAn
         Ep5/0oxYbx04et4Z900y7+3asBNB/ES2AAQvpnLybFyV7dGrMabMV5gXIhDuuo1XIO
         7GfOnEyFPZGqVAEhvgZAEoyh14L/9ADJDvZY+7Hq9a72suAS+Sp4cVbGuCo+yAlePM
         +KF7mH60DviGNruNSKkw/eI50VY4pn9CZQeurb7T4dV4eidtMJjdArNWsUYH12IbgR
         RD86/CMV9mdlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32A2AE61B61;
        Wed,  8 Mar 2023 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: microchip: sparx5: fix deletion of existing DSCP
 mappings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167828101820.17807.5367103917799593646.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 13:10:18 +0000
References: <20230307112103.2733285-1-daniel.machon@microchip.com>
In-Reply-To: <20230307112103.2733285-1-daniel.machon@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, error27@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 7 Mar 2023 12:21:03 +0100 you wrote:
> Fix deletion of existing DSCP mappings in the APP table.
> 
> Adding and deleting DSCP entries are replicated per-port, since the
> mapping table is global for all ports in the chip. Whenever a mapping
> for a DSCP value already exists, the old mapping is deleted first.
> However, it is only deleted for the specified port. Fix this by calling
> sparx5_dcb_ieee_delapp() instead of dcb_ieee_delapp() as it ought to be.
> 
> [...]

Here is the summary with links:
  - [net] net: microchip: sparx5: fix deletion of existing DSCP mappings
    https://git.kernel.org/netdev/net/c/cdd28833100c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


