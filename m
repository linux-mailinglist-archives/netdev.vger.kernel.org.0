Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B6346CD63
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhLHFxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:53:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35808 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhLHFxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:53:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 478D1B81FA2;
        Wed,  8 Dec 2021 05:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E64FCC341C6;
        Wed,  8 Dec 2021 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638942610;
        bh=Q94yLMqif3oBKdzrwBHEtHwpQlbQGS2dmCLgjkzA9wU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ka+teff+sRB9h5PV6wAzU0dNRzMh0k05AuG4F2hMiMz3ykSwSnUkbMimSGKlnH474
         4HB5LsmUATQ2mDjL1WUXj8divc5jbB4vunhNXlcyBjlHwSzTLRdLTiqZeEOieaHEGh
         dmO8LJZZds9zIQc2fT4UbczPjTWME3+n9cXR6SQrGOEQQVMvfEk60BqmSqvbJoxvic
         3e1u3h0qQglxb82m987JS4PvPFVq/4tYu6hnQHe6Ju628BwE527uyDDnaKE0ZBBOFT
         vVcbYFJW+Lzc4VAwQZzM0rWd260+0/QDsUJH04cPTjcs/SV1P1FoO5ZpCwuae5eSO4
         HSCw2cV2Q/8hA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CEF1C60A36;
        Wed,  8 Dec 2021 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] net: phy: Fix doc build warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894261084.12550.7172357748660578217.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 05:50:10 +0000
References: <cover.1638776933.git.siyanteng@loongson.cn>
In-Reply-To: <cover.1638776933.git.siyanteng@loongson.cn>
To:     Yanteng Si <siyanteng01@gmail.com>
Cc:     akiyks@gmail.com, linux@armlinux.org.uk, siyanteng@loongson.cn,
        andrew@lunn.ch, corbet@lwn.net, chenhuacai@kernel.org,
        hkallweit1@gmail.com, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 16:12:26 +0800 you wrote:
> v2:
> 
> * Modified Patch 1/2 under Akira's advices.
> 
> * Add Patch 2/2 to fix warning as:
> 
> Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1657: WARNING: Unexpected indentation.
> Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1658: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: phy: Remove unnecessary indentation in the comments of phy_device
    https://git.kernel.org/netdev/net/c/a97770cc4016
  - [v2,2/2] net: phy: Add the missing blank line in the phylink_suspend comment
    https://git.kernel.org/netdev/net/c/c35e8de70456

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


