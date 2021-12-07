Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B05646AF48
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378493AbhLGAnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:43:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34148 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351421AbhLGAnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:43:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 192EAB81643;
        Tue,  7 Dec 2021 00:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8D88C341C6;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638837609;
        bh=K5+G2lzUOIu3xknoyJ22h22pld0La0AnHbIsZlitdts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nuIhysBwZ3SnlaY7hOBUcAifNC34rRTehJvQM/joCUq5t4UU911wEKwhgCjqIMrQ2
         UBzReozbnTxpxm7QYwqo6haYiNUOfYIC44TPXOv2dwoJRslidRS9FHToDvhXMAy9Yh
         KcjvbSaYHljVZvTUMfoo9HFoa2ngHUJPzUVYEuKHnNzU1Hey/Dr0Tzfontk59+yUBB
         HZkPWvvokjmhu7vG4LQ6DtVQOOvdmPyFuZVWZytQnF/qsLhamyayCjGijoBtkKxX6t
         VXy9FKdk8DrNGI77wZXqigtUzvxxjgdC6CzsF7ChOHn+IyoOsJZl9pAGueYu1+L9wO
         msVwGeQmtdw8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 99CC260A39;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: hns3: add void before function which
 don't receive ret"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883760962.11691.5545557231991693749.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 00:40:09 +0000
References: <20211204012448.51360-1-huangguangbin2@huawei.com>
In-Reply-To: <20211204012448.51360-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 4 Dec 2021 09:24:48 +0800 you wrote:
> This reverts commit 5ac4f180bd07116c1e57858bc3f6741adbca3eb6.
> 
> Sorry for taking no notice that the function devlink_register() has been
> already declared as void, so it is needs to revert this patch.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: hns3: add void before function which don't receive ret"
    https://git.kernel.org/netdev/net-next/c/364d470d5470

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


