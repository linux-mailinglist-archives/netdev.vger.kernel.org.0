Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2EC3F72D9
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbhHYKV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238879AbhHYKUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C14D61245;
        Wed, 25 Aug 2021 10:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886809;
        bh=AS6ibLEPKOlEYDokPrqMgy+rvlkkBKvEg6DWn9rIQyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rxpuKbP9bxFdU8uMglaUFhTcuvSdJih74p7St/pKQlVj/YBmDozivBOz5g8TCbV9E
         Wg/rH3BTWJpLRwt9fd07OMDKGFq82oKKjVUw39vyECHtGxKZ078vAyOnQGOEWH/f3U
         vunyBQFJXOLWszHhrFtc6jlWeoZcUVd5GYkNa7OPbIuqzYX6TPbk1FTq1kWWkNSCnP
         ssivRO2sOV53A16s6yLI2GjfKvbpyGWFZbh7vBpcr5veeI5j3Ro5AmtWK3TdWjGaca
         BwN+wQDlmPd577m8MgkOjqjiLeU5IMergo7pXE4JEv6yEOLj/NX05t6JR2liZej2TS
         nNreqsnKo7ZAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0494160A0C;
        Wed, 25 Aug 2021 10:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netxen_nic: Remove the repeated declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988680901.8958.696460214508460246.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:20:09 +0000
References: <1629860815-37361-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1629860815-37361-1-git-send-email-zhangshaokun@hisilicon.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, manishc@marvell.com, rahulv@marvell.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 11:06:55 +0800 you wrote:
> Function 'netxen_rom_fast_read' is declared twice, so remove the
> repeated declaration.
> 
> Cc: Manish Chopra <manishc@marvell.com>
> Cc: Rahul Verma <rahulv@marvell.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> [...]

Here is the summary with links:
  - netxen_nic: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/807d1032e09a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


