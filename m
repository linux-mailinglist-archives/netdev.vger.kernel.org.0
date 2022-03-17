Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107114DBD00
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352817AbiCQCba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243581AbiCQCb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:31:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2891F617;
        Wed, 16 Mar 2022 19:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB56E61358;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31DB9C340F0;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484211;
        bh=aBBtB1WlenW0nX+sTuBbNSZBr6ooYgdbxwcBf+8Je9M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H72f5hcWiBTXVS8NAYJzRj78tRlgoJeyLhy1+Eq97pBRA3y1vcY7Y+/jRUvDRUd8E
         67jlHUm8i2p0hCmZKxqGfFP8jJHGT0Ky/HVQ/DKBYaS4EXvwoxBiseSaB7X/6HF30N
         ER05sOGankmyLxH4As/TT7L59atdFcfHRhvpoiGrjL3JRSVEWTupGUMaaBwVOZ+TeB
         DuKbM/FWmhZd7g1oTq2ZQiaik1njkMbUvv4KQUAopr7Wi9ac87vjYeUVA93jrDDRdF
         Uab5tYvpQyUVX/ytOV5Szlgryd3aUeDWnEMomaN/CfIkZiK2eX4hPiKkPCR0mKey3q
         ApgictnfDYBRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1592CE6D3DD;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hamradio: Fix wrong assignment of 'bbc->cfg.loopback'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748421108.27087.13961135961342141281.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:30:11 +0000
References: <20220315074851.6456-1-tangmeng@uniontech.com>
In-Reply-To: <20220315074851.6456-1-tangmeng@uniontech.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     t.sailer@alumni.ethz.ch, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 15:48:51 +0800 you wrote:
> In file hamradio/baycom_epp.c, the baycom_setmode interface, there
> is a problem with improper use of strstr.
> 
> Suppose that when modestr="noloopback", both conditions which are
> 'strstr(modestr,"noloopback")' and 'strstr(modestr,"loopback")'
> will be true(not NULL), this lead the bc->cfg.loopback variable
> will be first assigned to 0, and then reassigned to 1.
> 
> [...]

Here is the summary with links:
  - hamradio: Fix wrong assignment of 'bbc->cfg.loopback'
    https://git.kernel.org/netdev/net-next/c/a8df216630fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


