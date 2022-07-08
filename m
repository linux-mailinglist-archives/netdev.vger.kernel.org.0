Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BE656AF60
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiGHAaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiGHAaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5542AE09;
        Thu,  7 Jul 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A39B824AB;
        Fri,  8 Jul 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5B29C341C0;
        Fri,  8 Jul 2022 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657240213;
        bh=XB7ifxqGEl7mXBY1gyv6Cs9btJjNPa4OanwsWsf9RIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cVvlr90n1BKThX08hAIwtoq69GAUuhRl8H6hvQXHQuFUjS6xxgSV/wGZ5Pal5UpiB
         Q25jWlEIgwoxkORsl1reViLbl5GuXvKZCW+gXFQC8T5TfMgVJPoRzVeap+UyzyxxIX
         fp88Ome8epUFdl3jcMvaDfb2sy2HcffmKdWSdJZV/tKwc2mVGRcgcHno6V9FfRqhLV
         ++Sit58GL34lmxSE6m5zYqYuGCqlKcsGZpOEdoCOY8Y81CL/xCqgs13+PZz1btEtXR
         WfmuyVJ5OA1YZ67MurJDt7TYqLYIurSf1gKZwGs5dDBeTCyAaIH4UiGBIaJdBw7a9Z
         uFz1P1EDgzVqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1F76E45BDA;
        Fri,  8 Jul 2022 00:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: ethernet: ti: am65-cpsw: Fix devlink port
 register sequence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165724021366.12828.14742361369221807453.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 00:30:13 +0000
References: <20220706070208.12207-1-s-vadapalli@ti.com>
In-Reply-To: <20220706070208.12207-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, vigneshr@ti.com, grygorii.strashko@ti.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 6 Jul 2022 12:32:08 +0530 you wrote:
> Renaming interfaces using udevd depends on the interface being registered
> before its netdev is registered. Otherwise, udevd reads an empty
> phys_port_name value, resulting in the interface not being renamed.
> 
> Fix this by registering the interface before registering its netdev
> by invoking am65_cpsw_nuss_register_devlink() before invoking
> register_netdev() for the interface.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: ethernet: ti: am65-cpsw: Fix devlink port register sequence
    https://git.kernel.org/netdev/net/c/0680e20af5fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


