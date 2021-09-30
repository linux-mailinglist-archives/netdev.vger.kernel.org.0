Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCAC41D9AD
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349948AbhI3MWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349892AbhI3MWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 127A961206;
        Thu, 30 Sep 2021 12:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633004462;
        bh=HfZSIaK/rZ2WKxs8KybbgYVxLc79s3chtJDKVQOdgzg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F5MZDtpdmeQkmD3ipKZ60MUhZQH/VHXcjJuLtRKjHEycBzOb/RdM8H44m9Mj78JPb
         hF04DmkHoiVQ4ZK53SaXO7cE5FPVgXTsQHerVrA45NfIoStv3VUyB9SH0mp8XwpIIL
         78gEwm7rYXfZGcycwRPgxHgg8/5Z70NUgCcf1bpCSOXgpynmr0lkqQLTjOdvgXb43t
         RXNj4laScqphMHY3i8HUne4wJK4WGpLTATzTFxmS6D6uBRMqq76zUd+dQAjz+WquSk
         w6EuNblvt2va6ijCqcWYlsmJCXMjaXt3DzbVJ67hOfoKkUi0QWiICYZCmjzh5BdAxR
         0nk7/Q71o5S7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BB4460A3C;
        Thu, 30 Sep 2021 12:21:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: ptp: Switch to gettimex64() interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300446204.20045.2966055646414550316.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:21:02 +0000
References: <20210929120739.22168-1-lars@metafoo.de>
In-Reply-To: <20210929120739.22168-1-lars@metafoo.de>
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     davem@davemloft.net, kuba@kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 14:07:39 +0200 you wrote:
> The macb PTP support currently implements the `gettime64` callback to allow
> to retrieve the hardware clock time. Update the implementation to provide
> the `gettimex64` callback instead.
> 
> The difference between the two is that with `gettime64` a snapshot of the
> system clock is taken before and after invoking the callback. Whereas
> `gettimex64` expects the callback itself to take the snapshots.
> 
> [...]

Here is the summary with links:
  - net: macb: ptp: Switch to gettimex64() interface
    https://git.kernel.org/netdev/net-next/c/e51bb5c2784c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


