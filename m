Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD44645057F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhKONdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhKONdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2057363223;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983009;
        bh=6D7iu5jHZmXFfjtWvrd/W7Mk+l+OY/sLVDnDqy/Cp4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HvzTyKc02n4fYpqCv8RchTAhOUmiOcs6I2xlSXXqZqREM7Glwuf5lepz42sKldKw2
         zfKjKa2WFPKnDjkXEfh7GET94Q7JXQq+b91t8MoPwyXVzuj76VoPQA5iIZeOSrasDy
         r3sxpdvJGae+NDrSloo2KNHTmp+sjNLOJJhsmv9BAyDZKYUGyqI/ANsDP1pEDOCTwn
         cAZKy4rGnAEgrCNUGJgJihCegrF4rZJIW/ZmbbZ8WuLyAhCoeMu8yYJKTy6g3G+qP5
         mqyuOD+8oFmf2KBEbrp0DNPkpsGDxSCmB+KgG4ypzbSC/aDqWTwIeIg0J7DoMjrWIz
         ykRMsIAuY2Jmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16F1B60AA1;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: ipa: HOLB register write fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698300908.26335.7637724260645823466.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:30:09 +0000
References: <20211112222210.224057-1-elder@linaro.org>
In-Reply-To: <20211112222210.224057-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pkurapat@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Nov 2021 16:22:08 -0600 you wrote:
> This small series fixes two recently identified bugs related to the
> way two registers must be written.  The registers define whether and
> when to drop packets if a head-of-line blocking condition is
> encountered.  The "enable" (dropping packets) register must be
> written twice for newer versions of hardware.  And the timer
> register must not be written while dropping is enabled.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: ipa: HOLB register sometimes must be written twice
    https://git.kernel.org/netdev/net/c/6e228d8cbb1c
  - [net,2/2] net: ipa: disable HOLB drop when updating timer
    https://git.kernel.org/netdev/net/c/816316cacad2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


