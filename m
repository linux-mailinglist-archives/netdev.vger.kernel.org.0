Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8253A886C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhFOSWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230344AbhFOSWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E25A9613C7;
        Tue, 15 Jun 2021 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781209;
        bh=ncCycJhel+/pni9Iz4PmO3JvKx741e7c5REqu/N0SGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qYdjHgQyCIGDIraH/XV9T/d9hnbv1v7ZBTlV0mXcekbyArsWudyTPGEvgZhDBicf+
         LrdY5N7NArPB33YoUFs6mJvisjA8bymXojxC+X426zOYsVPJmUbC3RjBGmf2jBVdsK
         Jhuh1wzzeOHMfdW1lA8NqI+PMxNNsXMqPtXyUpdeXgNwwaO53VQYWMxRGi3Z7qn7Hi
         YupEg8PHSqqyT8EFx1hNRYnKEs8fdxpao1UF6gqDAmduR+v/UGogl36ihDdb35ydH2
         lmo8m8TodiXn8cHRzoFjF81ptncsCb2EHz6Y5sgPlf3bxUJND3p1Rk9MPa47j8kyRi
         PWK/uFmLdYHTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D999160A0A;
        Tue, 15 Jun 2021 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 00/10] net: z85230: clean up some code style
 issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378120988.26290.16640447282305942755.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:20:09 +0000
References: <1623725025-50976-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623725025-50976-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 10:43:35 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> ---
> Change Log:
> V1 -> V2:
> 1, Remove patch "net: z85230: remove redundant initialization for statics"
> from this patchset.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,01/10] net: z85230: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/336bac5edaa7
  - [V2,net-next,02/10] net: z85230: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/61312d78e1d4
  - [V2,net-next,03/10] net: z85230: fix the code style issue about EXPORT_SYMBOL(foo)
    https://git.kernel.org/netdev/net-next/c/e07a1f9cbd4d
  - [V2,net-next,04/10] net: z85230: replace comparison to NULL with "!skb"
    https://git.kernel.org/netdev/net-next/c/b55932bcfabd
  - [V2,net-next,05/10] net: z85230: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/c6c3ba4578e8
  - [V2,net-next,06/10] net: z85230: fix the code style issue about "if..else.."
    https://git.kernel.org/netdev/net-next/c/57b6de35cf32
  - [V2,net-next,07/10] net: z85230: remove trailing whitespaces
    https://git.kernel.org/netdev/net-next/c/a04544ffe889
  - [V2,net-next,08/10] net: z85230: add some required spaces
    https://git.kernel.org/netdev/net-next/c/b87a5cf65655
  - [V2,net-next,09/10] net: z85230: fix the code style issue about open brace {
    https://git.kernel.org/netdev/net-next/c/00a580db9e2a
  - [V2,net-next,10/10] net: z85230: remove unnecessary out of memory message
    https://git.kernel.org/netdev/net-next/c/2b28b711ac5d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


