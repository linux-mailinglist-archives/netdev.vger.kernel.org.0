Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B912B3F7351
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbhHYKa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239770AbhHYKaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C7DCB613E6;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629887409;
        bh=e/LAykflif0RBhpsIOZvQ3sVJ8TY37/rhNRX4Fg3+uo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kU1Ver5TI2MtY7Bg18qsmxcezb9mC9bRS/ryBhFqpA82PhEiaELLUkRnNXs/VEFUn
         4/9BvpGq96iwLNV1+1/FFdGCEW5fS7KrZlAl0R+kTIaLruh0tKRGzvAGJF0cZq35Ei
         1GUTLWn+vy1VWzbiFukOhCPG6DudT7iHh1cXrP+9stnkQ1h8uBrCjjh1ecIdbAvchH
         A6NMskVsgofymFp4ZP2W4unF1VlU55hIj31aprO0owbIjO055QFaTYNq+u2/03v8En
         9t3ZH8V/XDfNlpHyE9cBi3yDbeZgOEplvM3ZOHjMrZtOFs0MSBAaTy9YQEvZ+Rl4fV
         EPjh+LVpgZn7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BDB1160A0C;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mctp: Remove the repeated declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988740977.13655.6240015284304517437.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:30:09 +0000
References: <1629873271-63348-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1629873271-63348-1-git-send-email-zhangshaokun@hisilicon.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, jk@codeconstruct.com.au,
        matt@codeconstruct.com.au, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 14:34:31 +0800 you wrote:
> Function 'mctp_dev_get_rtnl' is declared twice, so remove the
> repeated declaration.
> 
> Cc: Jeremy Kerr <jk@codeconstruct.com.au>
> Cc: Matt Johnston <matt@codeconstruct.com.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> [...]

Here is the summary with links:
  - mctp: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/87e5ef4b19ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


