Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B244633E1
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbhK3MNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbhK3MNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:13:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A133C061746;
        Tue, 30 Nov 2021 04:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99D61CE192C;
        Tue, 30 Nov 2021 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1571C5831B;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274210;
        bh=GG5gJi5phItLljHVZy0IEn8y7Jq0hiWTkPmB3enRPwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M0n34TzVcoZFxRfr6aHmwHn1w5GXS8o7SK/q95BQmYHPekE4hV/ioXUT8Qv9rwv9t
         aBnw31NgzJgDhiZ4rTwEh8bZPfVmWoWS6piJUjjWi3yoVUkxyuPNDPzs4TRfBOXIjH
         qYsWikEYoOFit3imf8hdbbWIP3qGrEmtcomglbpK392SkT1R/8xeu+xNXMmedWO0Jy
         xVSe5RBeTru5Y/m2ewnBjSw8N0bk8ZgGKjdTvi7YbFiLn6truYF6/TWFzeRXEvKIgj
         xC3KLRxKXzAzqsotDxU6GVBw0/A8MSCC2XAr19f3CmTBF2g/ilLTYnagSZ5f5doN05
         M/L5wFsAv0Byg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A263560A7E;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tls: simplify the tls_set_sw_offload function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827421066.23105.18043406195005544947.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:10:10 +0000
References: <20211129111014.4910-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20211129111014.4910-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 19:10:14 +0800 you wrote:
> Assigning crypto_info variables in advance can simplify the logic
> of accessing value and move related local variables to a smaller
> scope.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  net/tls/tls_sw.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)

Here is the summary with links:
  - net/tls: simplify the tls_set_sw_offload function
    https://git.kernel.org/netdev/net-next/c/dc2724a64e72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


