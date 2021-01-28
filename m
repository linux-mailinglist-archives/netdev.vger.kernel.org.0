Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B82306A91
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhA1BmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhA1Bkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:40:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A905664DD5;
        Thu, 28 Jan 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611798010;
        bh=L25+jcLFjF6ZQOr2FLiBUNfjqAkFVIqfpNX1aDjhvTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BC9LOA5LtNJkmoxidFiNEOWNFmqQux4U2XzB+Cijl6uz35rbjFRHa8gyY1PQcaD9S
         +Mjag/liaQylfqyq5iBqd5JqetbwayeVjByhl9Em9dzJEPjBmD2QqebHdtFWFu1GQk
         4JkSjRhoCHuiKs7voSV7/XA8O0C1EoEdrkIlAMTDVGACRGc7O7kfwiIqMk9Qoq1+tr
         Q+mkBlWPxeQi6yGpHrlo+2N4BmtQ2DfYZuFBvUwpYFg/VpzHX3T7f/fTCEeJg3ImXl
         PPoDP5AtKjB1OSalB7cScRH/xa59jOh4nHYxLIxYeaUx5oEa1Pxf0i1OIfxyKPVWJk
         /X0an5bdDGfqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A36F365307;
        Thu, 28 Jan 2021 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rocker: Simplify the calculation of variables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179801066.342.6043089310099129367.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:40:10 +0000
References: <1611648783-3916-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611648783-3916-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 16:13:03 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/ethernet/rocker/rocker_ofdpa.c:926:34-36: WARNING !A || A
> && B is equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - rocker: Simplify the calculation of variables
    https://git.kernel.org/netdev/net-next/c/1d96006dccf0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


