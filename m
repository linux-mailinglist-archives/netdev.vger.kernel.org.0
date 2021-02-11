Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00395319608
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhBKWuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:50:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhBKWut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A12864E3D;
        Thu, 11 Feb 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083809;
        bh=YLcAMTkUV11YFc3ffm9nhUFO62Zpva9UP0TMLfLrNJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V90O/U6n+RgkqpJZfzb7O8goFvrsZIXZpsCb47jTsEuljz3tT70M+lvTe0ljxN38k
         neb+89dpsjdfEa2VVjwX8qIGTb20Wh0OadbcJUVNBklp/FnSSrgymOgEm1fizGpPMA
         XpTBaEjWRbfjHesxEV0M7wtrJzQKqvszrYNVOH6ZjCSAUbQV37oxnEsWXxnHjo0P2S
         ZC7vBb1WH7HbU5WGmTFFGdK//XtX0WD8USMkvoRJKm/S7Xe3X/4STEBwmzH0q7WtBO
         1JF/eIPrNsphSkENkyYdxpa9lYQXt/bSpC7nIt6iwy7nhaV+/qOurdmyzj8sLR4gSB
         rsGKMGx7xLz7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3434560A0F;
        Thu, 11 Feb 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fib_notifier: don't return positive values on
 fib registration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308380921.17877.5107096834500250763.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:50:09 +0000
References: <20210211100759.1156998-1-vladbu@nvidia.com>
In-Reply-To: <20210211100759.1156998-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 12:07:59 +0200 you wrote:
> The function fib6_walk_continue() cannot return a positive value when
> called from register_fib_notifier(), but ignoring causes static analyzer to
> generate warnings in users of register_fib_notifier() that try to convert
> returned error code to pointer with ERR_PTR(). Handle such case by
> explicitly checking for positive error values and converting them to
> -EINVAL in fib6_tables_dump().
> 
> [...]

Here is the summary with links:
  - [net-next] net: fib_notifier: don't return positive values on fib registration
    https://git.kernel.org/netdev/net-next/c/6f1995523a0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


