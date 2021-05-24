Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1538DE62
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhEXAbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhEXAbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4BC1961285;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621816211;
        bh=b/aXQGlDYmgAHBpyI09++ZdbYVEwZR4M1M0VJKJ2Tp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K6VQfJFeU5wxZtiSvN3RU/TMff22Vdd7w0CRF5DBQzKcCwsU4vDiXiXQLuHszStaS
         OSBoNRpZBLC6Hy+xZ7ZGNB9y5b9ZazVeMiCWyvZN4+Oy1aiq2WS1/q67i4Qxg+nzCL
         VBrqWhBvYM0g01XSsQ+a2eSjBZXiB6ncFNKOWAPi0EJMxyHDnV31fT6Ejvi78lQYpk
         kRLPsj6nuyzSS6il9MJYuF28+MpGVczMtDlQ9YACHyF4ES/jc6W+qU86E1SB4z4+/S
         ge62fbsq5iz7aC5YIVsGVWbBAP/wQNPHtlktqUz96MCLZKBZBygaC52qir7t4eec7k
         zyNXrJz2V8oFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4127F60283;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ehea: Use DEVICE_ATTR_*() macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181621126.30453.14677567365957496075.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:30:11 +0000
References: <20210523060223.41936-1-yuehaibing@huawei.com>
In-Reply-To: <20210523060223.41936-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     dougmill@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 23 May 2021 14:02:23 +0800 you wrote:
> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: probe_port_show should be probe_port_store
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ehea: Use DEVICE_ATTR_*() macro
    https://git.kernel.org/netdev/net-next/c/0056982f093d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


