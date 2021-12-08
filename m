Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5498146CC8E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhLHEdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhLHEdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:33:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AD7C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 20:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83DEAB81113
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B6D4C341C3;
        Wed,  8 Dec 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638937809;
        bh=5urQPmie4gtGbM6qSFFIW86LLvBbl1EOyNjtY1GZO9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OL/HN+mXj4K0CecGJRVb0nacdY1lPML5IadWQrxgTexPL45VL1y5Bb+eevtxsvouh
         TDjJr0cQgJBCg6mg0yKQlHHcUicy3bYyr8Lhfb3cszf/f3T4rIAMMEiIsT6TQ7PU+l
         RePNxZW7Njsf73Jwat9wBa8GPEBwJlYLiG0H2tdu0hCixhXl9yngp7QHc1EDWr1ZD3
         /h8vKTVgZihVKvsxlJA9i20ouupQZmYaMZcZWpqEloEnVtPGgZ6LltHt9+Ayqz5xW1
         t6FSJY5Ypj0tdULGgsXKb8vRCQpWHiPHe2VOFTZ4e6mUlHywDLZbKAQg4hC0Gqn8D/
         i7nRTp0sxrGYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B15460A36;
        Wed,  8 Dec 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: tls: cover all ciphers with tests 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163893780923.13298.8296705027712028051.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 04:30:09 +0000
References: <20211206213932.7508-1-vfedorenko@novek.ru>
In-Reply-To: <20211206213932.7508-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Dec 2021 00:39:30 +0300 you wrote:
> Recent patches to Kernel TLS showed that some ciphers are not covered
> with tests. Let's cover missed.
> 
> Vadim Fedorenko (2):
>   selftests: tls: add missing AES-CCM cipher tests
>   selftests: tls: add missing AES256-GCM cipher
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: tls: add missing AES-CCM cipher tests
    https://git.kernel.org/netdev/net/c/d76c51f976ed
  - [net,2/2] selftests: tls: add missing AES256-GCM cipher
    https://git.kernel.org/netdev/net/c/13bf99ab2130

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


