Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406C1488DCE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiAJBBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237723AbiAJBAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C1DC061748;
        Sun,  9 Jan 2022 17:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D91CB8107A;
        Mon, 10 Jan 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C15FC36B11;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=7+otGPkYH4sDjaNmEi2KF255l+yGGwmulscIWmkXOVc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jVSuUCN2ZxKdDdQyelMAidiJfwhGcr52upFfeajmJPC4LrKp2ZHVeO0B///bUkcbC
         zqpHm56Epre8q+V2lY4QKXcl/hVIeITIriLLd+djhvcJMXFDerBZAFGsVb/TQY4ZgL
         60VovYNrXZl2BwBo5U3rnTScZIlDxkk7RT7kAMNXUVZLED+h4c1I2ykUOKSnUwb35e
         plQfV+6W269NYGVprkAlftA3OcY9jPkq4Ytk2YuHp2YL+Ags/Rls0idNJ/Vf69vjJP
         d7rcJ0OdKJLa/71Oc7S7ZXzLoWcx5/l51WSPZU3MMqmA/aXqHbN7IlAvib2bqsDI/l
         XBz8wMpS2m4lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B05FF6078E;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] page_pool: remove spinlock in
 page_pool_refill_alloc_cache()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641423.18208.18113929340653001001.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <20220107090042.13605-1-linyunsheng@huawei.com>
In-Reply-To: <20220107090042.13605-1-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 7 Jan 2022 17:00:42 +0800 you wrote:
> As page_pool_refill_alloc_cache() is only called by
> __page_pool_get_cached(), which assumes non-concurrent access
> as suggested by the comment in __page_pool_get_cached(), and
> ptr_ring allows concurrent access between consumer and producer,
> so remove the spinlock in page_pool_refill_alloc_cache().
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] page_pool: remove spinlock in page_pool_refill_alloc_cache()
    https://git.kernel.org/netdev/net-next/c/07b17f0f7485

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


