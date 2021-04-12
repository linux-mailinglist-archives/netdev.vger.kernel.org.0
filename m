Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A28835D279
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbhDLVU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237908AbhDLVU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 17:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A0106135C;
        Mon, 12 Apr 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618262410;
        bh=/otzDCu4HiRiPpWbjclA88n13z+yv7RMQ+tvGVeFm38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iKddUJHNaQw3aB7H+Bap3VRTr/iqEr6cBaxxOD2XvvPaMimsBi3PXuef60kdG97S9
         V8VPC0zbpBeoL4QbaRFGFZDppka7iwlcuas2p7sfbKOajH65nSEoxgbxiL0x3xEsAC
         naXh9TgBF9l1lvWhh1+MyvwEhERY7OZvpcikMiPMEJtNsCwHwBshBJ+70kGo2HuO9i
         a4Vc6zM0wg8duDlib+vhoApvr4WT/Xr6JqnkvEOww2TzZ57v6U0JFCzY2C89Mn5sFk
         zc8F8R9qi4dfMwknZ3A8zoiVZyjO1ueEUsB1VnWuui6vm2zrjqjrxWxWO0P3mZrVQi
         YuTNx8SElAraQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B5EC60BD8;
        Mon, 12 Apr 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ibmvnic: improve error printing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161826241010.26087.6059678057571902073.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 21:20:10 +0000
References: <20210412074128.9313-1-lijunp213@gmail.com>
In-Reply-To: <20210412074128.9313-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 02:41:26 -0500 you wrote:
> Patch 1 prints reset reason as a string.
> Patch 2 prints adapter state as a string.
> 
> Lijun Pan (2):
>   ibmvnic: print reset reason as a string
>   ibmvnic: print adapter state as a string
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ibmvnic: print reset reason as a string
    https://git.kernel.org/netdev/net-next/c/caee7bf5b0a9
  - [net-next,2/2] ibmvnic: print adapter state as a string
    https://git.kernel.org/netdev/net-next/c/0666ef7f61ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


