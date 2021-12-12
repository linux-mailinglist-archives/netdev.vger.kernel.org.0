Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278B7471B94
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 17:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhLLQaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 11:30:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56854 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhLLQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 11:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DABCACE0BA8
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4377C341C6;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639326609;
        bh=PDEnaeUELzzNy3LpcEoBV+0qA6VUAtoAbd8YjCSAN4Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ua6JddZtIaMTiVcC4UTQ2J+vki0AKsgAcNiLdcJ051KH1oICQC0KEsKypckLd4dEP
         3Am8wJEURqCf1We8KiwydvthIEUnVr1iyJMXkGK/hQD6EB1ezFWrFjSS+pHN5bkI1n
         FyGypPQPXn0eV6L9NYmchESz7zf/oQB7eKcikN9LEoqUAzBmB5BvumWZ4IlJrSU2cV
         TjzvWtTNhnXKedsJ+2RxYKwqLDKLogoFQJ3E+ngfrFKL9FOxN04V7/N3dK4rb8/5V2
         xaJqfJ0iShJKwSkL6m9rA2q28RGpCqEuNj5tMOXt2o6GjZYoNXtF5gRwREumSrB6uj
         4izEEQgn1iQIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B497160A4D;
        Sun, 12 Dec 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: Add duplicate config only for MD5 VRF tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163932660973.2571.6861965592076197339.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 16:30:09 +0000
References: <20211211171130.74589-1-dsahern@kernel.org>
In-Reply-To: <20211211171130.74589-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 10:11:30 -0700 you wrote:
> Commit referenced below added configuration in the default VRF that
> duplicates a VRF to check MD5 passwords are properly used and fail
> when expected. That config should not be added all the time as it
> can cause tests to pass that should not (by matching on default VRF
> setup when it should not). Move the duplicate setup to a function
> that is only called for the MD5 tests and add a cleanup function
> to remove it after the MD5 tests.
> 
> [...]

Here is the summary with links:
  - [net] selftests: Add duplicate config only for MD5 VRF tests
    https://git.kernel.org/netdev/net/c/7e0147592b5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


