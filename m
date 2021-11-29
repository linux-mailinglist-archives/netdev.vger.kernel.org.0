Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925674618F1
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378630AbhK2Ofg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:35:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37996 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378536AbhK2Odd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:33:33 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5165961528
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 14:30:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id AC6F86056B;
        Mon, 29 Nov 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638196209;
        bh=icyoYRPpEyzydcir8h7mlqhsF52HfbtAbbxubYTF9SM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RNk0Cx16h8npiLkf3UeM4vPVUpqkWyA+jpHaapyl1dC2zoa/RGkjVPQ2I5PpSSY9P
         krj4THJCWZMloGSpHvQ6ckbtb57CJPCiSz4uCI0bGJc8OwpqwkA5eJh8c6gy8l0FZ6
         CLjwNypjzNIWrGmvKToNF+S8m87NG1EsiX8X8xSzsAEG4xvVZzXPzEkySkq0TsukM1
         h9NMPWe7unG8szARAqntL2FncTX5uE8Buy75qMRnKfWvQg37TCB82MGfYcJUaMSKpt
         3GEeGjE7adSZRhBispzTLEZWbA9RiuBfBAifJWFvI0ke/MoMlck9VPk7yCoPCUr0Nb
         DvzpLOKv946tA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CC64609DB;
        Mon, 29 Nov 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] net: atlantic: 11-2021 fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819620963.16432.4147550340393495530.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 14:30:09 +0000
References: <20211129132829.16038-1-skalluru@marvell.com>
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, irusskikh@marvell.com,
        dbezrukov@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 05:28:22 -0800 you wrote:
> The patch series contains fixes for atlantic driver to improve support
> of latest AQC113 chipset.
> 
> Please consider applying it to 'net' tree.
> 
> Dmitry Bogdanov (2):
>   atlantic: Increase delay for fw transactions
>   atlantic: Fix statistics logic for production hardware
> 
> [...]

Here is the summary with links:
  - [net,1/7] atlantic: Increase delay for fw transactions
    https://git.kernel.org/netdev/net/c/aa1dcb5646fd
  - [net,2/7] atlatnic: enable Nbase-t speeds with base-t
    https://git.kernel.org/netdev/net/c/aa685acd98ea
  - [net,3/7] atlantic: Fix to display FW bundle version instead of FW mac version.
    https://git.kernel.org/netdev/net/c/2465c802232b
  - [net,4/7] atlantic: Add missing DIDs and fix 115c.
    https://git.kernel.org/netdev/net/c/413d5e09caa5
  - [net,5/7] Remove Half duplex mode speed capabilities.
    https://git.kernel.org/netdev/net/c/03fa512189eb
  - [net,6/7] atlantic: Fix statistics logic for production hardware
    https://git.kernel.org/netdev/net/c/2087ced0fc3a
  - [net,7/7] atlantic: Remove warn trace message.
    https://git.kernel.org/netdev/net/c/060a0fb721ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


