Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F32F0420
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbhAIWkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbhAIWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 66D722388A;
        Sat,  9 Jan 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610232008;
        bh=L1THga5bn+Mp5xzjJQt1ke6wC/abUslwlyjj5YxfVFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LmG9ePkblryIFPQCvNvO2Wl/VoIPIFp0H1/uBcIxZV1IOS98xW2jrryQkbhuPgsSD
         eQmMR/96FDumpEHnC/4PCHGM47Kvt6NAOR55MxYpK/3a/Oz7V14zzMyg0vH10bQjYn
         iuT6+cDVkMiiw8G5DNEBkMNgyVqHilkfRhscnmyU6lHJrHxQFDTxmF22RXeOF49tHa
         3FOo15WCUIWoeJu4AuMDRg+FdDP3D7i9jOGNTzzyHl6MuD/XDwm9+Co5t1wHg/19OE
         2Y2I2cMoaZlJi9Sx04xsXB/P2VKT7V4FPJEWffwceCpR1hfYMUpPihenVb1zujzZwC
         HyJNkHTG4JZKA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 58215605AE;
        Sat,  9 Jan 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] selftests/tls: fix selftests after adding ChaCha20-Poly1305
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161023200835.10389.10058094748383571716.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jan 2021 22:40:08 +0000
References: <1610141865-7142-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1610141865-7142-1-git-send-email-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, borisp@nvidia.com, aviadye@nvidia.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  9 Jan 2021 00:37:45 +0300 you wrote:
> TLS selftests where broken because of wrong variable types used.
> Fix it by changing u16 -> uint16_t
> 
> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> [...]

Here is the summary with links:
  - [net] selftests/tls: fix selftests after adding ChaCha20-Poly1305
    https://git.kernel.org/netdev/net/c/3502bd9b5762

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


