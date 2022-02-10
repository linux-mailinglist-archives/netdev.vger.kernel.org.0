Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67614B16A9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 21:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243473AbiBJUAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 15:00:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240434AbiBJUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 15:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6375595;
        Thu, 10 Feb 2022 12:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7390AB8273F;
        Thu, 10 Feb 2022 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1A50C340EE;
        Thu, 10 Feb 2022 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644523211;
        bh=aPFaZRZFsiHf+2cGdyFS5YOWWmezSTheEwwrXC7BAgs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YLPS/BCCPthtVMAlscbVkOnLlh/n16PlKh0x+v7kf5FfVS64Me+6YjrWogyNrETq2
         cNAaKUEBAk1GDdmauALtpbo5R8KWsWtLzuD9ZH4odv/ohP5R8bhjPhTqv06u3oKCfg
         0Jq2EmtrmCaBrG3jQrhZRuYgcBLVie1lT444T+SkD8OspAsSinee+GaSeaAkwalDiP
         UyfJ8HToxIv1jigFnxRuWcBswGLzIDDk9P2X3azypZ1tGQ1fF65LXy1wvIdrzoZHlA
         7w7xSlyLEb1W/il+EPXUej7AOQcgE1pkNCz3FQ5P8oIrO1QAx+274jnXYIn2qITC9c
         ls6rR5v/G9zvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6064E6BB38;
        Thu, 10 Feb 2022 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/1] ocelot stats mutex fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164452321087.17968.3479215280295580829.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 20:00:10 +0000
References: <20220210150451.416845-1-colin.foster@in-advantage.com>
In-Reply-To: <20220210150451.416845-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Feb 2022 07:04:50 -0800 you wrote:
> Originally submitted to net-next as part of
> 20220210041345.321216-6-colin.foster@in-advantage.com, this patch
> resolves a bug where a mutex was not guarding a buffer read that could
> be concurrently written into.
> 
> Break this out as a separate patch to be applied to net.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/1] net: mscc: ocelot: fix mutex lock error during ethtool stats read
    https://git.kernel.org/netdev/net/c/7fbf6795d127

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


