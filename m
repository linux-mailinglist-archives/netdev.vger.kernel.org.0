Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA53234C0DF
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhC2BK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhC2BKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D735F6195F;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980209;
        bh=uxqCy1Q8ewPy84goGF3BL8xHEYJXXKhXXCyhwr4IewI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MuCBOo2i7vRQ32Jjdw1u2D0jbCWPQJbtcd7boIpmi83pCrZFuzmxF9xWJeoxWRid4
         8PJ/s0tHIvh66GiT4V9KrrxlRrpja3izaOtry2ST0hGBci6yzCkwsmTlw1GNi7G4sH
         cCSQ9HnY1g5w0FttxU0O0m4GtuVQWyDhrvrxJjhs7jcPJ16GWV5IijZzhgbqY6hDLn
         0DbAEODMvKS/fb6SqWGQitjrWoNjzFScCDH/ZwC5tZi8tXJ89HHb9UfUsh/4bt42V+
         G+Qd7RneM0xyl6fVbifzzx0bqyMYBGYfZlTzhFzu2qrkcRHNX0wsvZGomy8jbgYjR/
         GQBI9rZOH2PVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D2CEA60A3B;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: moxa: remove redundant dev_err call in
 moxart_mac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698020985.2631.8264272839432509104.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:10:09 +0000
References: <1616841474-9299-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616841474-9299-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net,
        christophe.jaillet@wanadoo.fr, wangyunjian@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 18:37:54 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: moxa: remove redundant dev_err call in moxart_mac_probe()
    https://git.kernel.org/netdev/net-next/c/9d0365448b5b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


