Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFC43A9445
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFPHmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhFPHmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E117610A1;
        Wed, 16 Jun 2021 07:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623829205;
        bh=FlqKBSOWouoOJA/idTKYCzj4gG0KKmyX1IDm3k05lGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lon2TYn+zfVRPoaKQUtydVv8ZvQ0sRblgUJhlsZ45RzGckLQz9ekipQrPqs5HBncf
         3Qk70suFQ+5WX4+6MQZ40+ZUKvGCNcfDvrLi7ihmZ/cP0QB+IO0THy8kPmnor8GwZG
         a0qT81k9tN5lcT2wUcwzcUH/QEbWxTMxYs6k2veu98El3z+aIumhDPUkkrf6xWYwW8
         r2l6KuzHsMbpXIFhqErru9+vzF+E1aMZEqi/t4dOTzCRfXLCAo/8viqKtn+NA9IkgH
         vMXtd+J58i5b1mPOkLp2m6e1WD9jAwU+U3vDq/ZP9Rt8uIw2uShVOSVj9vqcH1Z5t7
         ECpHLhFo/06/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5EBE860A71;
        Wed, 16 Jun 2021 07:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mhi_net: make mhi_wwan_ops static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162382920538.32075.16793809863524684196.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 07:40:05 +0000
References: <1623822790-1404-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1623822790-1404-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 13:53:09 +0800 you wrote:
> This symbol is not used outside of net.c, so marks it static.
> 
> Fix the following sparse warning:
> 
> drivers/net/mhi/net.c:385:23: warning: symbol 'mhi_wwan_ops' was not
> declared. Should it be static?
> 
> [...]

Here is the summary with links:
  - net: mhi_net: make mhi_wwan_ops static
    https://git.kernel.org/netdev/net-next/c/1d0bbbf22b74

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


