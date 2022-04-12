Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10134FCD5D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbiDLECs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbiDLECd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:02:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3C427B03;
        Mon, 11 Apr 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72ED66176E;
        Tue, 12 Apr 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47111C385B4;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649736015;
        bh=Og37zLvNTYtINm9dkZ2PhXXYIso0cAOuj31rpYiLeNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TStTsT+p5ok/fCi2B9C0wx2pXd0hkr/BrOmaIo7Fl87n5uSvYpYIF7QtkzC/3byx+
         hIFnyO9RiWOZ8L7nY4H/TANLW0T1zKw1nYERjSByYODxRCjvoay/9SINX55MmbiNgC
         m+P4QyolFk6Z2OcR4AjacALHJiPIqK/AJJO81RTbmiUHYtPfLqITN7oUk+Zj2LW3NB
         H4V1wpr7L+sloXWabZeWYgcbbCWZ0vrHpKf9/b9fZ5Ghcxv78nIqcSERhAF83NVnof
         4021aixcO1/f4c6V1ayiBwadkGs5rHxnMdunYKt6dK9sxvbPJyvyCjcHVq9D34dZGC
         pW1kq0FZfBYFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D1BDE8DD63;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/cadence: using pm_runtime_resume_and_get instead of
 pm_runtime_get_sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973601517.30868.9155139360828245200.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 04:00:15 +0000
References: <20220411013812.2517212-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220411013812.2517212-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn, zealci@zte.com.cn
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Apr 2022 01:38:12 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net/cadence: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/b66bfc131c69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


