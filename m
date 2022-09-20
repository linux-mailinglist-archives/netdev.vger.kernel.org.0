Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF05BEF43
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiITVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiITVkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFBC2F679
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 14:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE3262E40
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 21:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C8E6C433D6;
        Tue, 20 Sep 2022 21:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663710016;
        bh=IntQZ8JNpOPHQWokG6IAyVETGmWDZs9LeMtG5oqmGcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GIfZxUHtzncC+NSwxi7yWSw+qc24KYUO6z/C6vBR0EpCMW/f0pEcXT0OA3nux54Ha
         CiLbXHas1uARDd9JS/KU5mk/A+IBRqg+9g8kcrbIujJKlfea/ftRVlk4YD7z8hcN+f
         Z0e3NbdfPmNr6lGaqAACvtaSDuPb5pLt2Xw4etIY3GCXJTbRfQC6ZfsFbpX8H3c57E
         6r9mekwApmkIDOTxhBaBTBnR8tojb+unUrXLB9BQ+s6j1zmINbWqO/noTskGoiaLxU
         TZnD4j0Qvnr/3OoAvdwTXYnKqBcju3wtdzf3Yx5suU5amubLl9M4khxJgv6tKmf2uc
         I/a0u75Umd6CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74A46E21EDF;
        Tue, 20 Sep 2022 21:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: handle -EPROBE_DEFER when
 getting MAC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371001647.7760.9213204027016815959.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 21:40:16 +0000
References: <20220915133013.2243-1-zajec5@gmail.com>
In-Reply-To: <20220915133013.2243-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, rafal@milecki.pl
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

On Thu, 15 Sep 2022 15:30:13 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Reading MAC from OF may return -EPROBE_DEFER if underlaying NVMEM device
> isn't ready yet. In such case pass that error code up and "wait" to be
> probed later.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> [...]

Here is the summary with links:
  - net: broadcom: bcm4908_enet: handle -EPROBE_DEFER when getting MAC
    https://git.kernel.org/netdev/net-next/c/e93a766da57f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


