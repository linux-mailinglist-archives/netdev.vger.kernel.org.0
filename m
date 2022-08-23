Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3554B59E8B3
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbiHWRLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344480AbiHWRKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:10:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC75EB3B2B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 07:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89C66B81E1E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50A2CC433D7;
        Tue, 23 Aug 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661263215;
        bh=oKW78WFeG/KloM0AqVuHGJPNopSfXZG33wCU78pl/jI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cqru3B6JWmsjn/Ov8Lam1YRIzOVnSvPcKam9bH+L/ekrFI5FH1mykezspgExUrJy0
         lYz8KNqGR2RLlPgt6Vy3Zfv2IaihLiN0Pbjs6IZwjuK+l3jOnXHxPOvz4mS6OpIKvt
         DmT2N46ZrE9zP7NXBZ93lX/M8xjakrBdVCQEj32bYrivBOGVACqqt6NVgZGwlUAf7w
         1GIK4obc71pYJQwSq9bKlLIV/QFBqeO6ZfM8OwM2M+H8CJGM6WZKLxm4dLT/UTO/Gc
         DJf/paAicSvFs4JpQ3Pt64rbD+eR1KfuB8mqQR6Wo5tTosGtZz8qynfaw91cL2Rk7v
         zZnAPILi8RvwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28AE7E1CF31;
        Tue, 23 Aug 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipvtap - add __init/__exit annotations to module
 init/exit funcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166126321515.14708.11596183369703451173.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 14:00:15 +0000
References: <20220821130808.12143-1-zenczykowski@gmail.com>
In-Reply-To: <20220821130808.12143-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org, maheshb@google.com,
        sainath.grandhi@intel.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 21 Aug 2022 06:08:08 -0700 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Looks to have been left out in an oversight.
> 
> Cc: Mahesh Bandewar <maheshb@google.com>
> Cc: Sainath Grandhi <sainath.grandhi@intel.com>
> Fixes: 235a9d89da97 ('ipvtap: IP-VLAN based tap driver')
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> 
> [...]

Here is the summary with links:
  - net: ipvtap - add __init/__exit annotations to module init/exit funcs
    https://git.kernel.org/netdev/net/c/4b2e3a17e9f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


