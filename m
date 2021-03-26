Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88FB349D1A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCZAAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhCZAAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5685E619FE;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616716809;
        bh=746+1DwfvkmFmn0pmpXn9wAUMizJDVWfr1+nje1i2i0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bDl/o5xnWHPKH4YgvmB/O19Kr5q3mG6K+MctdU8CQ4q8ln9Gl3ngZeIGpmqYLJZJb
         XfBaHQZo+sS+2x372zRQIUU9qQePMdi4RnSsNw2BkmE0T+UM9PZ/qVf2RaC9S4sOBv
         rg+qjUeTDgS1Delp4pdTJzWA2iLO/t5hiPtNSz/36Vuw17OXnYcpvD+YnrDyvnRO5T
         CNclHTHEwZkehr7YRktRXfNn3Q6BahvUoIfMQPY4AwWwWHFJOpYcq336rCTddnmILr
         NPr8isGKPel7CjJ1ftcf4D6hxT1hdrK6xv+Dy1Bw20waxQ9XBSK93A0fd5SradpETs
         mom+vlKh+OJpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4731B6008E;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: usb: lan78xx: remove unused including
 <linux/version.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671680928.21425.1138306429204242003.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:00:09 +0000
References: <20210325025108.1286677-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210325025108.1286677-1-zhengyongjun3@huawei.com>
To:     'Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 10:51:08 +0800 you wrote:
> From: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> Remove including <linux/version.h> that don't need it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: usb: lan78xx: remove unused including <linux/version.h>
    https://git.kernel.org/netdev/net-next/c/a9bada338b68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


