Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481AB3012B6
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbhAWDk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbhAWDku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 46FFF23B26;
        Sat, 23 Jan 2021 03:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611373210;
        bh=nR44mHtYmBvzJsq6CLie+0E1thcNCHX3ocxyZhWHBAI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P+pq5POeyDFp4ISqFhQW85X8srMKR9SRKSrdQ6xIQGFgDK7ndDReAPLcFMCj+mNHM
         9USWrR0MUQDV5vaJmTXyxbkkUP/psX5h5bMHkjk6ZkSQ1fLVyob2GO5dj72cY1jOck
         JVtF+tCHbLL4OcILe9raTbj5ePEoZ1Lx4caYqL53Tig+tj4jIDhAeZvfV/E8LzLJeU
         hFMiccLA2TGiBp3/NoSCb1siNKCw6EypbP5iKd+DI+V87V8dTsnIph3M9Tzv9XY2cx
         /m5DvI8RUaQpU4FegH81yQUqFDdrrKsqqD+5BNlMwhl2N3t3SZLa+zm0ZgPkx6UwBT
         I/hhCZ8YbDmiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3867E61E44;
        Sat, 23 Jan 2021 03:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns3: replace skb->csum_not_inet with
 skb_csum_is_sctp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161137321022.2325.16423382603110600875.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 03:40:10 +0000
References: <3ad3c22c08beb0947f5978e790bd98d2aa063df9.1611307861.git.lucien.xin@gmail.com>
In-Reply-To: <3ad3c22c08beb0947f5978e790bd98d2aa063df9.1611307861.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, alexander.duyck@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 22 Jan 2021 17:31:01 +0800 you wrote:
> Commit fa8211701043 ("net: add inline function skb_csum_is_sctp")
> missed replacing skb->csum_not_inet check in hns3. This patch is
> to replace it with skb_csum_is_sctp().
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: replace skb->csum_not_inet with skb_csum_is_sctp
    https://git.kernel.org/netdev/net-next/c/b9046e88f6be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


