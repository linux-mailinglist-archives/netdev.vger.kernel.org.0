Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35B45330AD
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiEXSuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbiEXSuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA93167C3
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 11:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B1C4B81B0D
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 18:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA042C34115;
        Tue, 24 May 2022 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653418216;
        bh=5EIEMjDzYlFXhbx8koo0lcyZnfjjno77U3weL9Eiev8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nSNjJWCAvVyFbHEiJvIL+c5EMO6el2fXK4+DASWDAzcoJ2K6SWIPkFZBv4kzZBJJd
         KP2KP2v1ngBiBudhYaX+zv0hKIqoEZLgHAcQY2a0CefkrYKeJFAZuk9ElME0RwTvja
         TGmaS25f2yngrvkLu2Ai1Hfs9xKR/KNc6s/fsBIi8CAR189Qocb629eKwxOmt91Y21
         P9Oncfvy0pcK1Lam7+2aeo1IDF05B1lIXg5g0F6heRl0OryO2ZpaQ7CDGeywBJ13bM
         F8PFtB6BnJXJ6/V1+3tOKH5Iu6mw60f/h49fkXwOyTK/PhZ6l5uK8UUPiyTw4Ojjqw
         BOKrw03Hcz4nA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2487E8DD61;
        Tue, 24 May 2022 18:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/10] ptp: ocp: various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165341821585.16038.869813459483414820.git-patchwork-notify@kernel.org>
Date:   Tue, 24 May 2022 18:50:15 +0000
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 14:21:43 -0700 you wrote:
> Collection of cleanups and updates to the timecard.
> 
> v3->v4
>  Remove #ifdefs around PCI IDS
>  Clarify wording in debugfs patch
> 
> v2->v3
>  Remove inline keyword from function wrappers
>  checkpatch style changes
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/10] ptp: ocp: 32-bit fixups for pci start address
    https://git.kernel.org/netdev/net-next/c/8119c9ee7854
  - [net-next,v4,02/10] ptp: ocp: Remove #ifdefs around PCI IDs
    https://git.kernel.org/netdev/net-next/c/3a35e53a11bc
  - [net-next,v4,03/10] ptp: ocp: add Celestica timecard PCI ids
    https://git.kernel.org/netdev/net-next/c/81fa652e1685
  - [net-next,v4,04/10] ptp: ocp: revise firmware display
    https://git.kernel.org/netdev/net-next/c/5a728ac578c0
  - [net-next,v4,05/10] ptp: ocp: parameterize input/output sma selectors
    https://git.kernel.org/netdev/net-next/c/aa56a7ffc0fb
  - [net-next,v4,06/10] ptp: ocp: constify selectors
    https://git.kernel.org/netdev/net-next/c/3f3fe41c0bdf
  - [net-next,v4,07/10] ptp: ocp: vectorize the sma accessor functions
    https://git.kernel.org/netdev/net-next/c/caab82cdbfe4
  - [net-next,v4,08/10] ptp: ocp: add .init function for sma_op vector
    https://git.kernel.org/netdev/net-next/c/ee4cd7250c8f
  - [net-next,v4,09/10] ptp: ocp: fix PPS source selector debugfs reporting
    https://git.kernel.org/netdev/net-next/c/b88fdbba931e
  - [net-next,v4,10/10] ptp: ocp: Add firmware header checks
    https://git.kernel.org/netdev/net-next/c/3c3673bde50c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


