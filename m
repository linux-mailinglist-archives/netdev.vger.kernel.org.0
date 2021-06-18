Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CDE3AD25E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhFRSwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhFRSwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:52:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FC4D613E9;
        Fri, 18 Jun 2021 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042207;
        bh=xwJrzaiVjJUsX2kGV3cg9XlnlhVQDpsGA6ECu0DhPZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GDcwcT2P6QGGesY+VU1j0QUvzWefpmnKwYUzYn0X2rDiuX5lFiInaWU6vYY/cmORQ
         eRVYb7RCRuJ30OxQ6f1axAWi3X6U17vq/0bPvx1+4hYMbHQLVn2IAgNk/tN8RgvLSr
         lrJJ5M9dr0cC42wodpBBfolrRUK5GBxCakh8xga8RNOk36KQ/JweG0SqZ4aHbVIh6f
         AqpNjKvfdkHxLVbZwnwUH96cKwbO1WNIw7NBVZgajIZhDplVjkxato8RlAEmCObFAT
         3+YxPvTrjpj+dP2w4WZ2Zu+m/K0AFl++yqnBGuXC/Nhf3TRnt6sI3bxNeGlyNQiELb
         kAylJUkbij6bw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 838BF60C29;
        Fri, 18 Jun 2021 18:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/7] net: hostess_sv11: clean up some code style
 issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404220753.29148.4485679312661505691.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:50:07 +0000
References: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
In-Reply-To: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
To:     Peng Li <lipeng321@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huangguangbin2@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 10:32:17 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> ---
> Change Log：
> V1 -> V2:
> 1. Add patch "[patch 5/7] net: hostess_sv11: remove dead code"
> suggested by Andrew Lunn.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/7] net: hostess_sv11: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/fefed8af5ed4
  - [V2,net-next,2/7] net: hostess_sv11: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/fe9be8daef8a
  - [V2,net-next,3/7] net: hostess_sv11: remove trailing whitespace
    https://git.kernel.org/netdev/net-next/c/534f76d46245
  - [V2,net-next,4/7] net: hostess_sv11: fix the code style issue about switch and case
    https://git.kernel.org/netdev/net-next/c/9562aef3c0c3
  - [V2,net-next,5/7] net: hostess_sv11: remove dead code
    https://git.kernel.org/netdev/net-next/c/d25a944693c7
  - [V2,net-next,6/7] net: hostess_sv11: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/67c1876897da
  - [V2,net-next,7/7] net: hostess_sv11: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/7d40bfc1933e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


