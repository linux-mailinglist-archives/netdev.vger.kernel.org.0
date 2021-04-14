Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72235FC5C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhDNUKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234020AbhDNUKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D0C16117A;
        Wed, 14 Apr 2021 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431009;
        bh=QE9JFgm0jH9ht40adNIXbgQ0aB9HmM1BuBRrGzquCOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PQmotXE6oyb/shJEHqvKfrcy2DT5nu86LToVF64qFcUi/PAy5p/3RmHf5WBGc66rh
         jI8Bg+fGuaIfpMHA2cdp7OJAaMbgNjDnKstdQg7smxaKdfKDtpBeGZ9FWKUhAS77pL
         QiWu/Al2rkhU6jHvd1rltxR9CyDQNVSgzEgdI87ctjX26t+smxECkztf/sB5bih/tv
         N2i47xXOPjPL5+0BZGXpkN0HqDhfcPw5SDElC5Np+/TEljUzMgBnOMMsbO/rrQqKic
         4qhfin7wJGqqyVkw8BNsWlMkEDfBM3wAfvPBvrvHra0qipAOrnu/tyPo+21hw5YUBG
         NTGTYHnPUdLWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8EF5660CD1;
        Wed, 14 Apr 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] r8169: don't advertise pause in jumbo mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843100958.9720.9040134833766292706.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:10:09 +0000
References: <1fcf6387-f5ee-40f7-d368-37503a81879b@gmail.com>
In-Reply-To: <1fcf6387-f5ee-40f7-d368-37503a81879b@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, stable@vger.kernel.org, rm+bko@romanrm.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 10:47:10 +0200 you wrote:
> It has been reported [0] that using pause frames in jumbo mode impacts
> performance. There's no available chip documentation, but vendor
> drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
> do the same, according to Roman it fixes the issue.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
> 
> [...]

Here is the summary with links:
  - [net,v2] r8169: don't advertise pause in jumbo mode
    https://git.kernel.org/netdev/net/c/453a77894efa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


