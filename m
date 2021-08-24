Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DF73F59C6
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhHXIUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233692AbhHXIUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 04:20:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF23761181;
        Tue, 24 Aug 2021 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629793205;
        bh=mqmpd9sYd655gIANpDvD3HSFTmTHrLBsUw20TsmUbh0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s6IJE1O99ahxqsXzXygx/QvECgiDs0xV7dIfOWimwh7PvpGahzijluALHRmPMerg/
         zAEpdaHBRIOi2LUJjqTCDqVWmAa3Y0WNgxHORXPLxtuqrzI/HOwe0SGsWbY4IWs11r
         0d7e8uC5bwCr11LsmvQR4K1eHGk4qinlmhXfDFilnMQeuYS/kaoMRk75IKN+7VqDeJ
         uj/6xs+ZUDQn2qEnihhlPBIHG8rp0M9lJDf7wy/WrQdlxRsDsE+haMm7Hegask6ZKa
         8DoVutNvMFYwZWpYBWE+1hHGwJR3QJvRV0YnBqrU6BNv9JB0+7L68YFLc+cqCMvhXb
         Qr1h96iKSSA1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C21456096F;
        Tue, 24 Aug 2021 08:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: improve printing NIC information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979320579.21005.10173575606898451524.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 08:20:05 +0000
References: <8b4286fe-b16b-d29e-4e26-f7f225b83840@gmail.com>
In-Reply-To: <8b4286fe-b16b-d29e-4e26-f7f225b83840@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     rajur@chelsio.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 19:20:42 +0200 you wrote:
> Currently the interface name and PCI address are printed twice, because
> netdev_info() is printing this information implicitly already. This results
> in messages like the following. remove the duplicated information.
> 
> cxgb4 0000:81:00.4 eth3: eth3: Chelsio T6225-OCP-SO (0000:81:00.4) 1G/10G/25GBASE-SFP28
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: improve printing NIC information
    https://git.kernel.org/netdev/net-next/c/1bb39cb65bcf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


