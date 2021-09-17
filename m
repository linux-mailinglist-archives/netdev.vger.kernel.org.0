Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0145D40F5F0
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242975AbhIQKbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242755AbhIQKb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 06:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C6BCC610A7;
        Fri, 17 Sep 2021 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631874607;
        bh=OEwXboo4G5mexF0vNJnJmMqRMDixVxC/vQo4+4xSK9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H8bTWELMHR+y5NMaDCUi5vRbzogfsHYag76TMKQC37jGnuVbAJ+vwFg+eyJA7/DZT
         P2VE4AIq2S/p2FuEtOoBwuG9OahqCvO8ox4GtCcZCdSepc+FOcLD/iPHVox13UwP4U
         85+h5veNmcqnIK9f1dKSsoWvJ7DBg8dDOcIGlsNEK1VMGYEqYHbNwjXn8PV6tDVN0c
         s+qB+EluYctIkcDRhkujdtK2bSWcgeZk0SpGspeFuaH0FtIusqG6EW5CMoZsXzRF6e
         8GjVTKovcxUdmpAuKl0Pg3KnFgKHNmNYRUxQ6+6eoV8bImn1CUVeA7XjjfhntjBsoM
         cnC/AWHJ+8oGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B911B609AD;
        Fri, 17 Sep 2021 10:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hso: fix muxed tty registration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163187460775.15760.14685007430504576754.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 10:30:07 +0000
References: <20210917101204.10147-1-johan@kernel.org>
In-Reply-To: <20210917101204.10147-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 12:12:04 +0200 you wrote:
> If resource allocation and registration fail for a muxed tty device
> (e.g. if there are no more minor numbers) the driver should not try to
> deregister the never-registered (or already-deregistered) tty.
> 
> Fix up the error handling to avoid dereferencing a NULL pointer when
> attempting to remove the character device.
> 
> [...]

Here is the summary with links:
  - [net] net: hso: fix muxed tty registration
    https://git.kernel.org/netdev/net/c/e8f69b16ee77

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


