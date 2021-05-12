Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30CF37EE9C
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348040AbhELVz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1390994AbhELVVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 760F36127A;
        Wed, 12 May 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620854410;
        bh=Yaxc7gL6yCS09mkl0lIZL0MqqFavlr8qUrjdvgTMZPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VuyEynL2js7+4CyuGAOcU/b1XH3tG8G5850PZiVC9Qh9viNYmUJ0yrExoLqJBm1za
         moWfdpy4Srjan5kZi64QBGEuQ6TPALNn0rGnZS6om1ACTvTxZCowPVayWuoKgB7xDZ
         4XWEh8ymfnjQpbZotFGlfmDYIF2f01oxxqGnuddTNuCp9XzvjA2RuQfI7zqySgXDJG
         kDU8mXy29gazQzJbqx6I8+VTr7IO/s2QP7wUIafMMBTlI2k/5Sf0BlGwG6lpO7Mu+c
         CQCIdMUOIpNhQ7G6vqAkL24SO/3/SX7saBR2H4IfxMaakZY3BcULITr9KXE6v5uKm0
         61OgUdOj6xldg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A77960A48;
        Wed, 12 May 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] =?utf-8?q?MAINTAINERS=3A_nfc=3A_drop_Cl=C3=A9ment_Perrochau?=
        =?utf-8?q?d_from_NXP-NCI?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085441043.10928.5241551842564319875.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:20:10 +0000
References: <20210512140046.25350-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210512140046.25350-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     charles.gorand@effinnov.com, andy.shevchenko@gmail.com,
        kuba@kernel.org, frieder.schrempf@kontron.de,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 10:00:46 -0400 you wrote:
> Emails to Clément Perrochaud bounce with permanent error "user does not
> exist", so remove Clément Perrochaud from NXP-NCI driver maintainers
> entry.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - MAINTAINERS: nfc: drop Clément Perrochaud from NXP-NCI
    https://git.kernel.org/netdev/net/c/ca14f9597f4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


