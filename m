Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A506B36E0C0
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 23:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhD1VK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 17:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhD1VKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 17:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F0E5A61441;
        Wed, 28 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619644210;
        bh=YlK2arpaWlpw9mRpWyiecub5pgdbqlhz0GUCbX0ykb4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h8ZyFDzsFUJFJXFRf31uvwDoGplft0GArTcbpHnkv2kox0dSJQ5Ysr7X+ZlJKCsTR
         pPp3EsqW/crtSTWfhbbX07FUTE8/ZMZzFIIWcZeE2X7xEL3bZ3W97tNODaQk8UBKvQ
         gmPYHdxg17vfuzuJTPnx2Sle2cR+qQav0Ms0UWxm5gqn6M60bWaL0BDiix7Pu5Qum1
         /AwOeHhvT5lpDwwRbsltQrzzIfpUOutrFkCYSHFmg4ZOl42iOAj1xsW2B3BwJnQ78J
         Z+fGoTO5uUYfNL1biKjo7H7cuI8ofMbeWfNUX4GsZ8ICS7ctTYoGRpUf0hT7C7Wapq
         yYd19gJVdCwrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E539E60A36;
        Wed, 28 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: tun: Remove redundant assignment to ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161964420993.17892.2389378404589308179.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Apr 2021 21:10:09 +0000
References: <1619603852-114996-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1619603852-114996-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Apr 2021 17:57:32 +0800 you wrote:
> Variable 'ret' is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/tun.c:3008:2: warning: Value stored to 'ret' is never read
> [clang-analyzer-deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - net: tun: Remove redundant assignment to ret
    https://git.kernel.org/netdev/net-next/c/808337bec736

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


