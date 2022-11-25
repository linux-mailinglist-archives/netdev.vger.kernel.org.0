Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B75F638662
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKYJkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKYJkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8889230F49;
        Fri, 25 Nov 2022 01:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B80B82A16;
        Fri, 25 Nov 2022 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7E35C433C1;
        Fri, 25 Nov 2022 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669369216;
        bh=NbyfoG3Fi4CJ3iXyWGQeSWLYsbPnDW+RHnyZytSKhs0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Frr+kDw+cgtPdkeig/GGd0KTRKGG9AXlS5VARVMRwwVGJ0QDei6NvSjgUrxS4hGzZ
         kqdUaY/JINRYqT6cfXPNv4feHV/53ZL1Cj/SQAFGC+tIBkdpr206LBoDO4teGmAhbf
         s/pgs3HwxRHBT6JYNKPgndVbjtk6KOz7A19U/2lea3YBAaRJIBi+XOB5GK57Lj+d6e
         qgE1FayE7ebVswyX2nNj1FLzN9UZrMmQ+0Z1cCeQuUliWCYWxl6vIHDUbYr6YDW1Id
         nc6J/idT/Iz6VqPpgdfu8f6fzC7F50eQTGjQAePJXCVIOwWSjD3Nzcdqs62r3mX0pO
         jBqix9vU0N7zw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9C45E29F3C;
        Fri, 25 Nov 2022 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: don't reset irq coalesce settings to defaults on
 "ip link up"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936921675.2800.4020168798324451407.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 09:40:16 +0000
References: <20221123133853.1822415-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221123133853.1822415-1-linux@rasmusvillemoes.dk>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 14:38:52 +0100 you wrote:
> Currently, when a FEC device is brought up, the irq coalesce settings
> are reset to their default values (1000us, 200 frames). That's
> unexpected, and breaks for example use of an appropriate .link file to
> make systemd-udev apply the desired
> settings (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
> or any other method that would do a one-time setup during early boot.
> 
> [...]

Here is the summary with links:
  - net: fec: don't reset irq coalesce settings to defaults on "ip link up"
    https://git.kernel.org/netdev/net/c/df727d4547de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


