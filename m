Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE763BEA14
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhGGOxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232190AbhGGOwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 10:52:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6434E61CC0;
        Wed,  7 Jul 2021 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625669403;
        bh=B8MzcQmAtXxgDPCm+Z4PhmuS7paw4HJDcRg0+aqtLwQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ARc4lSlVHflnHnjo1kq0nQMae7k51KY6FZwgKj1BYf0bNDz+edavwRSPgj4+St5LH
         C+z8rdI7U/o0zRplFXAkZ6ShOhlfeVNQdlESwLE31dYjQNVczN4x8lUKyyzwGWaOVa
         qZl/5m4XG1OKJsnD1/ohenlb+t8ERuyC49GAl2AnFAJeN2H6QlCloGS26zCzXG4nh2
         3FHD1j9xIdSSBae8CcivVPWBe/L31E07fEtNCB0u51Jei2HVwoafAWVapi8qHlwM2Y
         1xK3pAQc0gMImDlTqr4zie/4Wg2lcqAKC7lCl3UgQa3L+TAYjqgsQRig0uxQBFadqK
         leHfcxK9TpwrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57B36609E6;
        Wed,  7 Jul 2021 14:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv5 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162566940335.13544.6152983012879947638.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 14:50:03 +0000
References: <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
In-Reply-To: <20210707122201.14618-1-alexander.mikhalitsyn@virtuozzo.com>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, avagin@gmail.com,
        alexander@mihalicyn.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (refs/heads/main):

On Wed,  7 Jul 2021 15:22:01 +0300 you wrote:
> We started to use in-kernel filtering feature which allows to get only
> needed tables (see iproute_dump_filter()). From the kernel side it's
> implemented in net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c
> (inet6_dump_fib). The problem here is that behaviour of "ip route save"
> was changed after
> c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> If filters are used, then kernel returns ENOENT error if requested table
> is absent, but in newly created net namespace even RT_TABLE_MAIN table
> doesn't exist. It is really allocated, for instance, after issuing
> "ip l set lo up".
> 
> [...]

Here is the summary with links:
  - [PATCHv5,iproute2] ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=459ce6e3d792

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


