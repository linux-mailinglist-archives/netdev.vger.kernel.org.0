Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECE138DE8D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 03:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhEXBBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 21:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhEXBBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 21:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9792F611CC;
        Mon, 24 May 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621818009;
        bh=IJCBZy0bLfcVnY1Igy7njpQmormYRMAMJFq6XLkGtdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a7wB2czDoCf5Obt5PsguKxQ04dRSQciM8em+pDQ0xXV7eiTUitgw2ER45oXHd8wqE
         HsLT0q5VsCUxi44UdHz+qbHfHgIM9x7noc78NqlFwGDGJliMA2bAFXcuR2oWyuhj/t
         TpQZp20ObSfXUdrk6qTRE6XfzNXCNCVLOFxsMT15SL1pzEdCepW/8vCdJ8HOflTzdk
         A0NuuWTjHQaGG6z5s/Vz6qdPcraqraUjTGmg8GqsMrSPAplVBlhYJfPem+hLelKUCY
         uPBDTdwtFEs3xjQ8ifEnp34ExfHzfekp+UX6k2lhhMoEQa5Zkp7Yplg/cpSrOY/lLN
         qvvwbxRzVEIUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BBC9609ED;
        Mon, 24 May 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: nfcmrvl: fix kernel-doc syntax in file headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181800956.10357.9521863900425218837.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 01:00:09 +0000
References: <20210523210909.5359-1-yashsri421@gmail.com>
In-Reply-To: <20210523210909.5359-1-yashsri421@gmail.com>
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     krzysztof.kozlowski@canonical.com, lukas.bulwahn@gmail.com,
        rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 02:39:09 +0530 you wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> The header for drivers/nfc/nfcmrvl follows this syntax, but the content
> inside does not comply with kernel-doc.
> 
> This line was probably not meant for kernel-doc parsing, but is parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc.
> For e.g., running scripts/kernel-doc -none on drivers/nfc/nfcmrvl/spi.c
> causes warning:
> warning: expecting prototype for Marvell NFC(). Prototype was for SPI_WAIT_HANDSHAKE() instead
> 
> [...]

Here is the summary with links:
  - NFC: nfcmrvl: fix kernel-doc syntax in file headers
    https://git.kernel.org/netdev/net/c/4dd649d130c6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


