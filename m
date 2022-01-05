Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787FF485811
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242828AbiAESUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiAESUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:20:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B607C061245;
        Wed,  5 Jan 2022 10:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1866B61892;
        Wed,  5 Jan 2022 18:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F791C36AE9;
        Wed,  5 Jan 2022 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641406809;
        bh=DW3S2gMIxM8Lbfygp1hYOyCa870Kg7987NhtR2TSfbw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WvxU/8R/fOiFY1oSCV+U1KgA5LSOdWkVHuZKlNkDpmG0XejywqL0hdK6zEOSQvV5m
         OUDUrVce4Ncy4UgAzP8JkdAGXq2noEXpdr3YkLd/J8Af50V6ohwoZjSlOw4bk8rgqi
         Cn1AhhBcZ/3LZ8ZjfR+fK25ijxqsJSIPgfE4o6kQQW5XipsWkYkKpnrWdsOd8yzFMB
         xq25DvKeAK4+HP1GSki7n1sCVwkfrly9weCwLL3a/eJwk9oaaTl4ooLxRF4DFDUcwC
         JvZTbkB+3KHA7fRoq8Opkzmmj5D4K8WXLSwwxAwzTf+xZWtHiKWEYV+QMdUhgvjPmk
         b0SoboBuXLRYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 559BEF7940B;
        Wed,  5 Jan 2022 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Revert "net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140680934.15806.13427483893385945695.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 18:20:09 +0000
References: <20220105155102.8557-1-aaron.ma@canonical.com>
In-Reply-To: <20220105155102.8557-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Jan 2022 23:51:02 +0800 you wrote:
> This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.
> 
> This change breaks multiple usb to ethernet dongles attached on Lenovo
> USB hub.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> 
> [...]

Here is the summary with links:
  - Revert "net: usb: r8152: Add MAC passthrough support for more Lenovo Docks"
    https://git.kernel.org/netdev/net/c/00fcf8c7dd56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


