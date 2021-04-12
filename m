Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5E635D1E6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245683AbhDLUUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237595AbhDLUU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02BE361370;
        Mon, 12 Apr 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618258809;
        bh=BzOuTQ9+zmgAJVx5ZXDs2kgrGA0FvVgEAQASfiyfHwQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VqsDDAmWy5C/Cqcac8fSxvx5OdvmczLf2W2KMuZDv8Ra9YHsdbsTIVUqG/jYRDzKY
         ria+tJ5NEzq2Z9HozxMgP9KyKc+eJQV75nwLFT8ar6y5QsZfE36nvuXumZxDRVfjgj
         3FFD389JLM9zbIq9/TQSx9BkYzJFKktBnBXdOTSTqpmhMILJYxza37KfbGogDBDOuP
         lVlGI9ho0sXsXyIhnWOzhgNUYIU0ZpUueQIFWT6+V41zom6oxeidCYEaN7HhbTSDLZ
         VkJM+imo+CMca+Kuki+Fg2Y620eTNxY7pzgrAa8LyCgpI2PQC87Lf6SKU6vlKJqjf5
         XAkTckmdFpO+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAA5260CD2;
        Mon, 12 Apr 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: Fix potential null pointer defererence of
 null ae_dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825880895.1346.11497783869109240984.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:20:08 +0000
References: <20210409163726.670672-1-colin.king@canonical.com>
In-Reply-To: <20210409163726.670672-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        zhangjiaran@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  9 Apr 2021 17:37:26 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The reset_prepare and reset_done calls have a null pointer check
> on ae_dev however ae_dev is being dereferenced via the call to
> ns3_is_phys_func with the ae->pdev argument. Fix this by performing
> a null pointer check on ae_dev and hence short-circuiting the
> dereference to ae_dev on the call to ns3_is_phys_func.
> 
> [...]

Here is the summary with links:
  - [next] net: hns3: Fix potential null pointer defererence of null ae_dev
    https://git.kernel.org/netdev/net-next/c/d0494135f94c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


