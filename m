Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D286C5E7A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCWFKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCWFKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC8F1EFF0;
        Wed, 22 Mar 2023 22:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C3EB81F10;
        Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8355C4339C;
        Thu, 23 Mar 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548218;
        bh=r7P7kw12H9TuPuFgRi+IMR3BhvoS7usSeUE7n9RlHj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OfvmzJ2iPJiF8NYSut70GEFHI+KyDngSWI7X3MXKRliZU1DBeOs5Qhl6Wu3fMa7vl
         KodpKka6uxiqV2z+yZDq4wQAoEU210bjuqBcUxuurlmjBm/72tZ4q0ZuBSDLsXNqES
         B6kcVdDlTQOqTIEkKIS0youhZ3++kLmeiDxV+FJ9X/sjFcFFG4Ysj5U0UDbbtccw9N
         JYwFFoTRXmTaoMzkN1imY0UoVgnLpjOLW8/ANY0zLacucToADq4iZdF7yGPmntIjCG
         wUMod5Cs9GEVlH41hScAMoApnfaOdH7eMraw3mDuoW9JgweiFtQAsvJ+glDUbLHOiT
         okjwxFzDb7rmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C906CE21ED4;
        Thu, 23 Mar 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv6 net] net: asix: fix modprobe "sysfs: cannot create duplicate
 filename"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954821780.28676.14135490297791050064.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:10:17 +0000
References: <20230321170539.732147-1-grundler@chromium.org>
In-Reply-To: <20230321170539.732147-1-grundler@chromium.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     linux@rempel-privat.de, paskripkin@gmail.com, lukas@wunner.de,
        eizan@chromium.org, kuba@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        glance@acc.umu.se
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 10:05:39 -0700 you wrote:
> "modprobe asix ; rmmod asix ; modprobe asix" fails with:
>    sysfs: cannot create duplicate filename \
>    	'/devices/virtual/mdio_bus/usb-003:004'
> 
> Issue was originally reported by Anton Lundin on 2022-06-22 (link below).
> 
> Chrome OS team hit the same issue in Feb, 2023 when trying to find
> work arounds for other issues with AX88172 devices.
> 
> [...]

Here is the summary with links:
  - [PATCHv6,net] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
    https://git.kernel.org/netdev/net/c/8eac0095de35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


