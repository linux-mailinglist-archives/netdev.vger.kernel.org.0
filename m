Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1D93A07F0
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbhFHXmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235550AbhFHXl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 075FD6139A;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195606;
        bh=LnQ+lHGhnwQmcMtw0TxDMw1RWXsvIIVyy88FpuSuKjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=klkGH44vV5p7wrrlmAyNK9z7Nk42v5zghamhO7MM3No/sHq2OkxmbShHq70UHbaqT
         EAoxyh5LlF9qjmOGj/N+FspZb9Y6W0WIA8rSEiYUB0Y0uJFue2GGrDTwdFApNy7wBw
         uyb02R9zE8q1TQZPgqqChInOuM3+KauD4+ym8ABpcfnTlCgt3gw/LUrIjTP2r5WodD
         GMTOPRKNTzGwxjvCxU0cjuf/+5hq0bDFkvrFHDzqQ7QZKNg+5Sooc1AqFGzhXd5IL1
         iMMuDjLW+CFxgno4goC9XOQQpPsgBNnt1pf7ihcnPPJPHK84m9xEmkKJq0G0rpzD5P
         2ksezcWNOAWfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01E1C609D2;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lapb: Use list_for_each_entry() to simplify
 code in lapb_iface.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560600.24693.16569197587430448345.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:06 +0000
References: <20210608081301.15264-1-wanghai38@huawei.com>
In-Reply-To: <20210608081301.15264-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 08:13:01 +0000 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/lapb/lapb_iface.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: lapb: Use list_for_each_entry() to simplify code in lapb_iface.c
    https://git.kernel.org/netdev/net-next/c/e83332842a46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


