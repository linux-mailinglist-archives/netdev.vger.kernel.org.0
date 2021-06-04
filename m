Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366B139C241
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFDVVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhFDVVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 71DA9613F4;
        Fri,  4 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622841604;
        bh=y6Qj86uHWpJ8H7+B6PkcxmZsSOheafQHQeMFRQUyIlY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hSsdmEFzkOEU2L76w69Hnje1ayXtzCZitc8+ObMrqdpo/m4fJU+cfWo+9Lgjm6Zsm
         mYZ6JxGJXCvMoJISzB3gK9YanSLicR+52HhtXPeDgkpXTFoySYEFpXg4gzQAuPbU5Q
         bk9MI7XjhHHPS7Ficu8lTOSgKWtNrNE9x7d+nNy+Ryp54D1AH/PlenHSdaCWFE11Z8
         N9d5RSA5t5qbHarbZQizz+6DXvA3KQvdGof9RQE849esDBMQM9+XpbBMdo8fWM4kYv
         myXbrY0xEdU/TpgcEq5Rn3BsQA7u/9zJ0ybYonp33CusIw68KhJm9SZCun4QPo2o2k
         gyzYiJShvqS+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F87560CD2;
        Fri,  4 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284160438.23356.17911968954229324185.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:20:04 +0000
References: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
To:     zhengyongjun <zhengyongjun3@huawei.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 4 Jun 2021 09:47:02 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/tipc/link.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] tipc: Return the correct errno code
    https://git.kernel.org/netdev/net-next/c/0efea3c649f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


