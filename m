Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC17C45F554
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhKZTp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:45:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbhKZTn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:43:26 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAAD8B82878;
        Fri, 26 Nov 2021 19:40:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A1A56008E;
        Fri, 26 Nov 2021 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955610;
        bh=w1b7XWA9tNv+Nab5II8UYjlJWkCRhNumycNwmGRIRmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AZOY+szSkWOJRVBS53sHwINGMlnhXjul5UjJ8qHrb/RupEs3jzCxSFuEZp7HUMG+t
         qqfWHXnPsKZgXx3vMB1UjMFGE3FYDCOH62/PTPEMwS+RRR/MjC9UbXjyEO6hu8VtdO
         yXqPOxeZ28IV8i7rdTqhDv1enX3SqH6x0Qb9PeHhwFLE4fgCLJxUaDoYOH6ir2BtbY
         xNFK4jMRHJVoxiafmZzZIQpYZ8SRzVeOLyOgiD7oUbsdTI02j+asFoM/mgDqeLmvWg
         MxS9vRL1m4NQYXOiuhcwHQxnsTM/CG2M8KyLt5svY52FA8eD8xSF5n5k8NtirAH6XL
         T1LOhNgigVP5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E95AB60BE3;
        Fri, 26 Nov 2021 19:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qed: fix the array may be out of bound
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795560995.18431.9745144977645514241.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:40:09 +0000
References: <20211125113610.273841-1-zhangyue1@kylinos.cn>
In-Reply-To: <20211125113610.273841-1-zhangyue1@kylinos.cn>
To:     zhangyue <zhangyue1@kylinos.cn>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 19:36:10 +0800 you wrote:
> If the variable 'p_bit->flags' is always 0,
> the loop condition is always 0.
> 
> The variable 'j' may be greater than or equal to 32.
> 
> At this time, the array 'p_aeu->bits[32]' may be out
> of bound.
> 
> [...]

Here is the summary with links:
  - net: qed: fix the array may be out of bound
    https://git.kernel.org/netdev/net/c/0435a4d08032

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


