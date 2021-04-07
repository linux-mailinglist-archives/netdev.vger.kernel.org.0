Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9DE357745
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhDGWAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbhDGWAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F24C611C1;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617832810;
        bh=xgD0MDNMDguHIA6KX0F0pvqmQYqVd56bNJ9MpF27LKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bLK8d+GpcbALtR903Uxusz8XRGEb5JxgzrfiGsHZKVQLGC1pMb/zXr71u2SBTJuP7
         1kUyg/1l/p8D0WafSEjnqYrtGPZhvE+UjAkKaTFL1zP79Q1y9XHPJGv2ugIIJMUhzV
         wabd3lTec4l8h4wUxf+S2yQg2ue93M1F1EMDHQ5/3vXKz9Jz82Fn5GZvw2cEwzZZG9
         OkvijJwkpvTFI88+ppiRBgko0mhLqJDmlZgdIplo+BXcmMTi6P+ow7oG9ekZkk3SDz
         VvnN+i+aSxPZX0+zdXlhZfWTi3nbjWOL+S0LvmndtKk2cmg00JTPNfo27HBD3t/wtX
         50Z42p4MVlsAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41217609B6;
        Wed,  7 Apr 2021 22:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ethtool: kdoc fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783281026.1764.18302349649104283968.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:00:10 +0000
References: <20210407002827.1861191-1-kuba@kernel.org>
In-Reply-To: <20210407002827.1861191-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, mkubecek@suse.cz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 17:28:24 -0700 you wrote:
> Number of kdoc fixes to ethtool headers. All comment changes.
> 
> With all the patches posted kdoc script seems happy:
> $ ./scripts/kernel-doc -none include/uapi/linux/ethtool.h include/linux/ethtool.h
> $
> 
> Note that some of the changes are in -next, e.g. the FEC
> documentation update so full effect will be seen after
> trees converge.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ethtool: un-kdocify extended link state
    https://git.kernel.org/netdev/net/c/f0ebc2b6b7df
  - [net,2/3] ethtool: document reserved fields in the uAPI
    https://git.kernel.org/netdev/net/c/83e5feeb385e
  - [net,3/3] ethtool: fix kdoc in headers
    https://git.kernel.org/netdev/net/c/d9c65de0c1e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


