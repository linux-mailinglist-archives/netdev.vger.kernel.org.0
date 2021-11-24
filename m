Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA1545B994
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbhKXMDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241885AbhKXMDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 038D561057;
        Wed, 24 Nov 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637755209;
        bh=qJtITQ+iepr0zXYtPOFJt7+4WLuZqFPmprM3pI7EICU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LGlWmdmJxJp5nrgp7QalLEj9nHqLsdHBJ9oquZF9B2EFHYwu77C+fnrSlA+DJC4MI
         nVudVjyeKvZnWouzDj5hqD9U3v33mZ5ORT/WEM6dEeU7jl7m8cZSH2MoDr76kkIO1+
         GpM4P3kDKXMtkLYI6MgD5BpwMhhC+YNtN1Me8Ro5Bsrr7Ekeolc3zeZaiqiWsx7FUR
         9VbdmwM9U4ja90mtlb8wb2fg4AKkPc5mwb0xMA3ED6Z7570zQGMznm+44OY3t1s1xo
         4xO6XqDBIXeJsQ0VY9XxB42UGGPDGRQbL3nMPcJ7YyyWJNc5W1WWpb1ZzUwmF0Wger
         PMYF4smRaaRXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF874609B9;
        Wed, 24 Nov 2021 12:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lan78xx: Clean up some inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163775520897.1662.9302973528616298102.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 12:00:08 +0000
References: <1637748596-19168-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1637748596-19168-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 24 Nov 2021 18:09:56 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/usb/lan78xx.c:4961 lan78xx_resume() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - lan78xx: Clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/45932221bd94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


