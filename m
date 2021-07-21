Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4EE3D131B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbhGUPTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239935AbhGUPT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 24C5461248;
        Wed, 21 Jul 2021 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883205;
        bh=Hj3/DzFRK+WSE5UJ9GE35ks/U5TwH6d8KGwKW+kj1Do=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PlN5pC+lMPlqiKByPW3xVLgXVKyVK751G5Qe0afBs5J2UGiTpH02y4kvxKHh7QC5e
         VioMp1SQ/77p+f3YFN0mndror9kfPE8XCE0Z2l3yIujwX9R6lmzUmUOQLoTvBEs8YL
         fGkfwEoO8cqAdMD0cOrEcYqgtGLOZBdfvJfj+tvExbEzBV1jlnzGkOC868/iChT8+5
         nfiBav38gj8XUqTRaSbuH3VfOSRTY0jWdVHbqkCTqSU/69CIjPyi51mEskwf6OgWTX
         ld3jClFibzA8sbfGACCfUuEWLKSbr5WSFdAY3bl+kzC0DzJuA7FSWZ6w6JkrJ0sY+h
         Ump06j3M+8mzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B50360CCF;
        Wed, 21 Jul 2021 16:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] Fix PMTU for ESP-in-UDP encapsulation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688320510.24738.1172015815729912435.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:00:05 +0000
References: <20210720203529.21601-1-vfedorenko@novek.ru>
In-Reply-To: <20210720203529.21601-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        lucien.xin@gmail.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 23:35:27 +0300 you wrote:
> Bug 213669 uncovered regression in PMTU discovery for UDP-encapsulated
> routes and some incorrect usage in udp tunnel fields. This series fixes
> problems and also adds such case for selftests
> 
> v3:
>  - update checking logic to account SCTP use case
> v2:
>  - remove refactor code that was in first patch
>  - move checking logic to __udp{4,6}_lib_err_encap
>  - add more tests, especially routed configuration
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] udp: check encap socket in __udp_lib_err
    https://git.kernel.org/netdev/net/c/9bfce73c8921
  - [net,v3,2/2] selftests: net: add ESP-in-UDP PMTU test
    https://git.kernel.org/netdev/net/c/ece1278a9b81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


