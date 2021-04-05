Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF335487F
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242717AbhDEWKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242652AbhDEWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1D62613DA;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660609;
        bh=PHEF6eyH5ket9wzLT9jo9CV1f0m3V2zFioMjBk21KZU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pkjsn44ZB3xxTFG5aTaswK3LOQ9uIcQTBTqbYXYWV0K4i1YwH6bG36I4eqYRdKhl1
         oXlp+WxkhoSQRIKZmejPeheyfuH0NheHGloHofv/XeQuL/poxvoM5aGgNL7tfmkK+h
         qCswScg1C7qMovh80XU3dK+YnW8SAW6sK72tMloN0YP0s/kAsoVPAdbBdhXj3TF8N+
         Hg76s/IwmIxMOJZ/FVKibZX2bURs9HvD5MJaTSOeKTmi48vkVTHZ9eIlwTCdpTZMJc
         jNuz4096sbaT1eIWu/5ZNZVHjXXYRpVvnwroQGVxXurvv58eiIXrWJL7XDHAD9AK+a
         ZIF1oe2XiK+BQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC4AF60A00;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Allow to specify ifindex when device is moved to another
 namespace
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766060970.24414.3057452106128976357.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:10:09 +0000
References: <20210405071223.138101-1-avagin@gmail.com>
In-Reply-To: <20210405071223.138101-1-avagin@gmail.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        christian.brauner@ubuntu.com, alexander.mikhalitsyn@virtuozzo.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  5 Apr 2021 00:12:23 -0700 you wrote:
> Currently, we can specify ifindex on link creation. This change allows
> to specify ifindex when a device is moved to another network namespace.
> 
> Even now, a device ifindex can be changed if there is another device
> with the same ifindex in the target namespace. So this change doesn't
> introduce completely new behavior, it adds more control to the process.
> 
> [...]

Here is the summary with links:
  - net: Allow to specify ifindex when device is moved to another namespace
    https://git.kernel.org/netdev/net-next/c/eeb85a14ee34

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


