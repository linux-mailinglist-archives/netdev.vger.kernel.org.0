Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D096F38B9E2
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhETXBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231967AbhETXBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 19:01:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C71B610CB;
        Thu, 20 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551611;
        bh=RodYAsenl4WrJP+FTPtI4LSzG6NrUntKxs5yYrfyaCQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P029qtln04p09be/HaxbydPchEkslAhGEYq0iYz5fdp4DYTFwXP3D7k+tyi5zBdwU
         osyVzcRTBPWJ4JeQ0pGdoJIPc7ysH67iPv6QoC07DHzyIpTj093q52B7UG7t7OP0nC
         a2VobC4YifIsUXTihoa31vJWSeofVnmC2u6mVX5Cd+aIegnj3Jf4ThO4bjpsH7dO76
         cCPkBEXSoHqJjQ/WEWDdhjxFjbP+Y+dL0EVMUTd5MOF6g3/iwfc4FYA+gSFRcXKyEj
         ATnYOvXk3t/1fco0m83bMCNt2VZT3js2TPJ/zcnrEAXMIP14FzgN4dbJ73pcVxCV+c
         pp6l0ft/Qr07A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 063EF60A38;
        Thu, 20 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: atm: use DEVICE_ATTR_RO macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155161102.31527.6723659556894141191.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 23:00:11 +0000
References: <20210520133645.48412-1-yuehaibing@huawei.com>
In-Reply-To: <20210520133645.48412-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 21:36:45 +0800 you wrote:
> Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/atm/atm_sysfs.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] net: atm: use DEVICE_ATTR_RO macro
    https://git.kernel.org/netdev/net-next/c/48afdaea04eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


