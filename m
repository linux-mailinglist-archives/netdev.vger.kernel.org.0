Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A353897BE
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhESUVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhESUVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12279611BD;
        Wed, 19 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455610;
        bh=/CnjdlXdsHM2gN1aHWvsXgOja2sz8dV4T0A41nGaqjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HiRj3t/Dw1SXB2RU0hCIGjvSlk1HoTWpUXyM7+RLjZ7SJFHzbnO2iQWzkdIXMvMER
         /EaA7n7QCN9b9r/Cqoop0ZAs35cijfMohQxlZCQ0oZHHVNf8ZrPu31zSrupnYDoONn
         S2917r4BIJMqZ4LPGex7SoBlhJ91JI7HN+CwvEYJ9wnWzoMZtIyc8LY75rmWvaNitg
         6t93r2Pa8lmqecV0DK11sASRE0kVrzW8xX2/xQw2yQc4B8Gt+/uugDLPWb5QgExlBP
         KaNosOrFYE6fHKg+bAGqsXg6zBiteBJcpeMcII5hyAfINOFFb+riWRYBSn9fNkYRVl
         S0iKbvR5t2j1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02BDE60CD2;
        Wed, 19 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hso: bail out on interrupt URB allocation failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145561000.14289.2318045523146834591.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:20:10 +0000
References: <20210519124717.31144-1-johan@kernel.org>
In-Reply-To: <20210519124717.31144-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, dan.carpenter@oracle.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 19 May 2021 14:47:17 +0200 you wrote:
> Commit 31db0dbd7244 ("net: hso: check for allocation failure in
> hso_create_bulk_serial_device()") recently started returning an error
> when the driver fails to allocate resources for the interrupt endpoint
> and tiocmget functionality.
> 
> For consistency let's bail out from probe also if the URB allocation
> fails.
> 
> [...]

Here is the summary with links:
  - [net] net: hso: bail out on interrupt URB allocation failure
    https://git.kernel.org/netdev/net/c/4d52ebc7ace4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


