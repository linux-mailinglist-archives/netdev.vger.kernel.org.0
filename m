Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240A250B48E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446337AbiDVKDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356188AbiDVKDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:03:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B55B633A;
        Fri, 22 Apr 2022 03:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98AA61E22;
        Fri, 22 Apr 2022 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 222EFC385A4;
        Fri, 22 Apr 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650621612;
        bh=cVZ2hdGXyNfp3bPgzaWVpNPl0RnZDzkmgcgmnhrdSPM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JoCVVRmcu2oNpA+njb6RpJJkr3khphXI5Nrx9WRRZHSbgJvc3hCdoqLKGdiFhS3bM
         Nb7YkzkAxAh1kNA7qKoEEuhi/OqIFROLsVXYhe6aW2jq3TaUQAeauQAb4aLabVBYGe
         BwcFfwOxdprI67bdb/5WLOA4hVodcHw5VZawQ6y1AViL8UWFasGAhgRTK5Tasp+Amv
         rqsWvYwvKmQCgZQRpbqrKLdAbBCkWarUKFOKH/Y1j4wux7vn5JcL22WLxkBFvRlN+u
         KoUJNtywbeakIcvCc9wBouKCAm1kj+r5HHVGChlfxliv6WQkgHvJ9lOjKAZpJqlyWI
         ZIc/wwY+rLFPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06777E8DD85;
        Fri, 22 Apr 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw-ethtool: use
 pm_runtime_resume_and_get
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062161202.6174.6961390379696554091.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 10:00:12 +0000
References: <20220419110352.2574359-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220419110352.2574359-1-chi.minghao@zte.com.cn>
To:     Lv Ruyi <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 11:03:52 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. This change is just to simplify the code, no
> actual functional changes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw-ethtool: use pm_runtime_resume_and_get
    https://git.kernel.org/netdev/net-next/c/e350dbac3c09

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


