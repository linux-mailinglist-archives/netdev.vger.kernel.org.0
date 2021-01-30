Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED79309293
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 09:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhA3Ieq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 03:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhA3Fav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D8AA864E0F;
        Sat, 30 Jan 2021 05:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611984606;
        bh=rdpSo4rq7U+L1NjoMRqs11+D6Z5rbeq5JYAGFBqI2Oc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SKoF/aHwas0y5b7aKnvwhLiTEgQkbxg0ZhlOqsIHZfSzJTCvT688qdzRi8RE0BQLi
         oFXVdutyYSCc3T8sKsgTpNthgLRj7FZMNAb0EXWyN9vOwHXqZBcnfA2PYl965nQ2Ws
         Hg8+cR2RV47Z6d7zHwZlGchobzexbp56fnS1Qtghrel64Bp6Zn//Ajdy2IAJHwE0Av
         xcBn8hjK6qB+xV7IGSS3dOFiLzYIswYcieSItLb3CDbQFkt9ndyvVXeb4OPu4exokM
         FOLR0ie/hIzu4di+JvGJW1snDH+skdCQZZd7WSyiYCXrKgG0pse9sV7WU8TVYmTOPg
         6VUEGSQUGnwxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C78B560984;
        Sat, 30 Jan 2021 05:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] r8169: work around RTL8125 UDP hw bug
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198460681.29299.1019594890157760832.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:30:06 +0000
References: <6e453d49-1801-e6de-d5f7-d7e6c7526c8f@gmail.com>
In-Reply-To: <6e453d49-1801-e6de-d5f7-d7e6c7526c8f@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 28 Jan 2021 23:01:54 +0100 you wrote:
> It was reported that on RTL8125 network breaks under heavy UDP load,
> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> and provided me with a test version of the r8125 driver including a
> workaround. Tests confirmed that the workaround fixes the issue.
> I modified the original version of the workaround to meet mainline
> code style.
> 
> [...]

Here is the summary with links:
  - [v4,net] r8169: work around RTL8125 UDP hw bug
    https://git.kernel.org/netdev/net/c/8d520b4de3ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


