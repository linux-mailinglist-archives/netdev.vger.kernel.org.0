Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633E06DB854
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 04:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDHCuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 22:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHCuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 22:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F1ACC15;
        Fri,  7 Apr 2023 19:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 496E26547A;
        Sat,  8 Apr 2023 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61363C433AA;
        Sat,  8 Apr 2023 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680922218;
        bh=9Zf7vpnaTfpnr9O36+SChFzROoUJBxTzwsqg70avb8A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q3icXknEI2nbJFdYZt/ZRHqOS4niE+kwbrK20vvXCccBGEsYMvGJySdFAY7lzQt6s
         gcMPLcDJkh0YPXzfqI7C/0JoKOAKO4c+SBKL2o7qPH0MzwnzJf8jIhxlBKpsHqSfH8
         HlbJ7WxPBJxqOPwmI4ghPIzr8CRw/gOQ/vxUtSPmkcygX19licIJ0o5o02EudcMPzK
         xwuKHFJFQNXjpDguxKBdEop2vDBX0TzasQm91Y41n9lk5z64kcaKxb4LgaApoa9/cG
         rR/5CjvFbJriP9ufi7LuCpAJuDne8MU7exYJl/ZYSDbPn7T2onp03kx5EZnqapQltP
         HsDXZtCDkyqEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42BCAE4F0D0;
        Sat,  8 Apr 2023 02:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix unsigned long
 multiplication overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092221827.13259.13795368691080730995.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 02:50:18 +0000
References: <20230406095953.75622-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230406095953.75622-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Apr 2023 12:59:53 +0300 you wrote:
> Any multiplication between GENMASK(31, 0) and a number bigger than 1
> will be truncated because of the overflow, if the size of unsigned long
> is 32 bits.
> 
> Replaced GENMASK with GENMASK_ULL to make sure that multiplication will
> be between 64 bits values.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow
    https://git.kernel.org/netdev/net/c/bdaaecc127d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


