Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9D23B3769
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhFXTwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhFXTwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12C1C613E1;
        Thu, 24 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624564204;
        bh=wRfzpCYHsqQZNbYRsceTZn6SPg3fxXS1baFEZlvB9jY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=leTrnrdPFtmtMQ5D8PPdQeHwdm8IQI/bpryQclrzwYuYlc5M6VCPmzxEJKiJwiCnp
         nZYTb4aRaSl3C0oP12GHUtCsVvYxZa+LCTxqh0maNI5WKf5OhY1HS7fkAiUGu3QgIo
         2qNNezM9oWvQUjbVf8OdMlB0QVPSk3slOCycLelIUBOmmjwmvGaJtGidqaKWU7EDMj
         /e8hoSZwoKC+MbpjA4ldXXY3MByfsuzN9/5lmY/3uzhVDc+mYJocCEG9iRwmmeaYiJ
         gWQQDfNhhpHT19GiBcyZbG93Q3GbGvUdPFqV9g80cFv3CR+UWdLP20l29D3SWHNdzb
         c8ai0ui9a8WiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 05E2260A3C;
        Thu, 24 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: macsec: fix key length when offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456420401.10881.7685764529566631071.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 19:50:04 +0000
References: <20210624093830.943139-1-atenart@kernel.org>
In-Reply-To: <20210624093830.943139-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, sd@queasysnail.net,
        andrew@lunn.ch, hkallweit1@gmail.com, irusskikh@marvell.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 11:38:27 +0200 you wrote:
> Hello,
> 
> The key length used to copy the key to offloading drivers and to store
> it is wrong and was working by chance as it matched the default key
> length. But using a different key length fails. Fix it by using instead
> the max length accepted in uAPI to store the key and the actual key
> length when copying it.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: macsec: fix the length used to copy the key for offloading
    https://git.kernel.org/netdev/net/c/1f7fe5121127
  - [net,2/3] net: phy: mscc: fix macsec key length
    https://git.kernel.org/netdev/net/c/c309217f91f2
  - [net,3/3] net: atlantic: fix the macsec key length
    https://git.kernel.org/netdev/net/c/d67fb4772d9a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


