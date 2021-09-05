Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF640111D
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 20:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhIESLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 14:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhIESLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 14:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55EB160F5B;
        Sun,  5 Sep 2021 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630865405;
        bh=QSqrKLY/xqY4uM+Kl6BcRDNKB0MgCiqJMZ6bpGnJEe8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c9tf4/6Ski+SL1tovVd5vUScJ8rlHGNNzMIOT9YWfV0JKovNaZZtVOnIOF9V0LKp1
         Yy8tyvHIwYaTt1yiSQo+YWULDk4JK8fTBAz04rjsFSq7mK6HrIkfbAycVeSm8g1ebM
         1RHTgl6ftvE2Ah9qt7hRcVDleiPYgKNuMH8StIqBa71pdvAXwvou9T7QvakKeIDYAo
         b0qlKYNqKHDRkYywsQzLNa59DEl6r1L3svZM66IiEInP+G3AOiaZ128SYs6WNuDkdd
         lJr8gpB2MVmYNedfAInV1JGauhZTreQs7dVvCJQmIG9JjrDCmV0C9726cA8SNEMXJF
         ZP/hbh59ehgVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4327460A49;
        Sun,  5 Sep 2021 18:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Sep 2021 18:10:05 +0000
References: <20210905172328.26281-1-zajec5@gmail.com>
In-Reply-To: <20210905172328.26281-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  5 Sep 2021 19:23:28 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Broadcom's b53 switches have one IMP (Inband Management Port) that needs
> to be programmed using its own designed register. IMP port may be
> different than CPU port - especially on devices with multiple CPU ports.
> 
> For that reason it's required to explicitly note IMP port index and
> check for it when choosing a register to use.
> 
> [...]

Here is the summary with links:
  - net: dsa: b53: Fix IMP port setup on BCM5301x
    https://git.kernel.org/netdev/net/c/63f8428b4077

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


