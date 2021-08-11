Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351C53E9ABC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhHKWKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232422AbhHKWK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D30A61058;
        Wed, 11 Aug 2021 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628719805;
        bh=sfiCxqp3Tr62LF883T37JTkFScVKn0NPj1hEnJlfHUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HOKnxOKQoUVHyHFnocaYVGBIHmEguGY3H7eJl01RcObKNcTzWhd1yGpp/NUdQ+A5N
         9hs59Uxapb4hh4PYi/U2MFEaYQF6/VOB1wTgudCRht5uifW3+6Tqud2a+RhuO5LSID
         lw1oOgMRm4Av5I84ojbv7VeWbH46MWCwgy4RKBY6SK9NIFbADYgxM54cVj5JSw9svN
         ZUfRw4v17TjrvFM3aCC8ZAzLCFNchaL+1gtBQkmFshRE+OQ8EmQPtYYiAh+1VU5LYv
         b8WB0RI2JlhLjcmrhqilYJCdqPPhcbqiUC9VTaYWzYefJOsKiQB+0TkmW85EK8EYeb
         qdmatIm7Yehbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E4E460A54;
        Wed, 11 Aug 2021 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: switch to my OMP email for Renesas Ethernet
 drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871980551.25380.18133187832227991770.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 22:10:05 +0000
References: <9c212711-a0d7-39cd-7840-ff7abf938da1@omp.ru>
In-Reply-To: <9c212711-a0d7-39cd-7840-ff7abf938da1@omp.ru>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 23:17:12 +0300 you wrote:
> I'm still going to continue looking after the Renesas Ethernet drivers and
> device tree bindings. Now my new employer, Open Mobile Platform (OMP), will
> pay for all my upstream work. Let's switch to my OMP email for the reviews.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: switch to my OMP email for Renesas Ethernet drivers
    https://git.kernel.org/netdev/net/c/0271824d9ebe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


