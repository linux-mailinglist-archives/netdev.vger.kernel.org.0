Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756FD36F2C3
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhD2XBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhD2XA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 19:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D458061476;
        Thu, 29 Apr 2021 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619737210;
        bh=VmQwPldmlN2nyv3cnGWLqCsvMgb7xgrToKOX+Ho0tE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ckGGHShyvUtvil0ENv0LDYksqTZ1O9GMe1Xd4z+j29OCvu7O6wWM6q3pBhhBDdFX7
         83/25YrgVQNATilbaA3Ighhvf4MKcr8nYUdMKeJP+gvi37HXgxnb7jxt3SSGXNeYS3
         xohSNIDMBVq0eLpV7Y/u3f1kzIcqGUGaqlmoLj8mwD81k3z1Z2JNDmOlh1+lZqRFxS
         purCF0Y4MYPKREOcWhKfbx9Izx8tBHmbjmKqo5BegbTcnmQTcDymVz7QrmprhXa2mu
         T5rFmCQ+Py9NjlUfSmIVRqMDNkOgFBl3SftTOzpbnH/PPdMd9/A5+84oXZWGk6AlB2
         gh/DoxNGBhI0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C888260A3A;
        Thu, 29 Apr 2021 23:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: Remove redundant assignment to queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973721081.25365.11886420591596326237.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 23:00:10 +0000
References: <1619691946-90305-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619691946-90305-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Apr 2021 18:25:46 +0800 you wrote:
> Variable queue is set to bp->queues but these values is not used as it
> is overwritten later on, hence redundant assignment  can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/cadence/macb_main.c:4919:21: warning: Value stored
> to 'queue' during its initialization is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - net: macb: Remove redundant assignment to queue
    https://git.kernel.org/netdev/net/c/bbf6acea6ecf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


