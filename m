Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C683A1ED3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFIVV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhFIVV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BB4E613EE;
        Wed,  9 Jun 2021 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273603;
        bh=RFEwZd8l/MupwYejaz1W8w2YNUyjudF5cvv8ZC+EBAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pUwb0Rt9+x3CT/ZojiaE4rlFhBPfQEX5/O8twUHzl755W0EarST043SJGpV+nsxr/
         R6ADkfp32lvw6GSJRd8q9lg/JjnYRfRe3OFcgjpJ/mshJlHEeJwjFc7FIfW/AZMzhe
         COzBLyTGASDTS1AMMnYxsGIRB8rAj3FG8RH8Kxgml1vJKIAhdldYn/Omf9kbhfnMdn
         kVJ5zDbmq+Fr/7UrIzqiy7aLqlg/fwG9Tb62QHIpZyZnIIvltABZTiftxpQqaBoiVM
         ZRV/Ycee1mcGEY18Qay8OC1ogTiQ+gjoBNCZESXwGYyFuTu9lSYVuXBAvsHREAEt7w
         pAZA5w162Y83A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F8C860A0E;
        Wed,  9 Jun 2021 21:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] udp: fix race between close() and udp_abort()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327360312.22106.3464471649898343499.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:20:03 +0000
References: <2c54e352442c700440158d104c2bbc1ccbdf4ddf.1623232095.git.pabeni@redhat.com>
In-Reply-To: <2c54e352442c700440158d104c2bbc1ccbdf4ddf.1623232095.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kapandey@codeaurora.org,
        dsa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 11:49:01 +0200 you wrote:
> Kaustubh reported and diagnosed a panic in udp_lib_lookup().
> The root cause is udp_abort() racing with close(). Both
> racing functions acquire the socket lock, but udp{v6}_destroy_sock()
> release it before performing destructive actions.
> 
> We can't easily extend the socket lock scope to avoid the race,
> instead use the SOCK_DEAD flag to prevent udp_abort from doing
> any action when the critical race happens.
> 
> [...]

Here is the summary with links:
  - [net] udp: fix race between close() and udp_abort()
    https://git.kernel.org/netdev/net/c/a8b897c7bcd4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


