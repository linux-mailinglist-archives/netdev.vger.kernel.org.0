Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A55587B2E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiHBLAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiHBLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:00:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE38272B;
        Tue,  2 Aug 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C08DCE1C40;
        Tue,  2 Aug 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB801C433D7;
        Tue,  2 Aug 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659438013;
        bh=0ASmGze/PTUrX6y2Ztjb7HH/oEgrz8ukg+sZwDf7hGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GZptDqETzwQOf5E7/MyhTrC2bLncMioK3JtTQ6JTSZjnjbTC+n4Dsmj4912TlguAF
         tP4YmhCv5qn6f8KP1Ir8llO0hkMmEm7y5Cg82VCJHP54o1HUiAizalhz1L5cXQ70Tv
         7uBmwPJZGpQYffrELWAp+I6DUdAYQkgCqHUkQVO6EB302UcFPzgYwj6lNRwlYmyyZL
         BKSmqbiL5UVjH9yxWmcN1UnvNxhSjRLF8urRRI5/S97S73dd6VqZpbYSivUOTfiBbI
         cShpcE0E0t8WUvEcZSMzWi/MzoZKLZtR3sFpHa/RjlRN9G/3DWNG4mD5ZODr6+yHPW
         EVU4IUZIjE1SA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C361C43143;
        Tue,  2 Aug 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: usb: ax88179_178a: Bind only to vendor-specific
 interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165943801356.21664.8346442629133964190.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Aug 2022 11:00:13 +0000
References: <20220731072209.45504-1-marcan@marcan.st>
In-Reply-To: <20220731072209.45504-1-marcan@marcan.st>
To:     Hector Martin <marcan@marcan.st>
Cc:     jackychou@asix.com.tw, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 31 Jul 2022 16:22:09 +0900 you wrote:
> The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
> chipset, but exposes CDC Ethernet configurations as well as the
> vendor specific one. This driver tries to bind by PID:VID
> unconditionally and ends up picking up the CDC configuration, which
> is supposed to be handled by the class driver. To make things even
> more confusing, it sees both of the CDC class interfaces and tries
> to bind twice, resulting in two broken Ethernet devices.
> 
> [...]

Here is the summary with links:
  - [v4] net: usb: ax88179_178a: Bind only to vendor-specific interface
    https://git.kernel.org/netdev/net/c/c67cc4315a8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


