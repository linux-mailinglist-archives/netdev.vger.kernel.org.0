Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D29A4395B4
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhJYMMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232007AbhJYMMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10FED610A1;
        Mon, 25 Oct 2021 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163815;
        bh=koFxXocC3YjVAm5SuzKLHRym9G3aqQH3HmK8My9uLIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LmblA27JYRi6tQAkX+E8DypxfRhYMIom080m+m8Rx4ZLkGPuDabJ513OwkQyyOiu2
         o1ALzZ37W/p3SDISbqhfhMaf92q3YRvMHCwWUBlzD13/n4fc4HM2hdkA0m0BM72HiY
         Yt6qxML0UKHZP55RDwIwVSICHgUA2Ngdl47rUzlK62P09cUEHAhXsJSyy7Egvv/imC
         l76OvTfh+kFs9rcczRDsiP+gXeLnC1MZUH05xl6cToKp7qoYTVmfXGZj/zgU0oqsa+
         mQ283IrwRf9uXQbNK7d0mrI94aAoXq9Q05a8H2v5A/iZTdW9uIvCyUs1rLvN9HcRVp
         7u0XdOF53p4Rw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09B1560A21;
        Mon, 25 Oct 2021 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-10-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516381503.1029.6173392363724316205.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 12:10:15 +0000
References: <20211024204325.3293425-1-mkl@pengutronix.de>
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 22:43:10 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 15 patches for net-next/master.
> 
> The first patch is by Thomas Gleixner and makes use of
> hrtimer_forward_now() in the CAN broad cast manager (bcm).
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-10-24
    https://git.kernel.org/netdev/net-next/c/12f241f26436

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


