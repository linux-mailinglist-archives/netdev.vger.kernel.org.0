Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7054E34C0C5
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhC2BAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhC2BAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DA5861958;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979611;
        bh=W1qeAEFIfsXDcu+115/TzLdpYEjvwNT6YlM9+KzHrDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=onLZgzp2DgxDqEY4kpIuRaqJsWqQoaE8XXJoiKkCVG0VWnTYXqWeKvzo0jXWPRjxc
         Vt2EJocLXDWEoR0dECyL8Zv8VMJAJ1TGftGb9QfuNewBhV1ngWE3W5wMFvduZeSYtm
         9FvgVwF5+Xzy7ZUuedbSlFHYsZIr4pnC5MCf22DrNMMD6e9TbKBkAGANxclhlc0D1G
         zNbNMLnEr4sO7YduAqKsiYEoaYODoBWZ5/ATtli9cNNoa/gAlg3kgC0ApTuUsdbmHA
         4l2TUQwjZ6I3GGDJ8tZt6yD8266x5nsC25kON2Y3PiJxxsSeFLR9vdZ+uwrL+EiRk0
         vrtR860ocxF5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 54FD360A3B;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns3: no return statement in
 hclge_clear_arfs_rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697961134.31306.3915167274003383134.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:00:11 +0000
References: <20210327043339.148050-1-liujian56@huawei.com>
In-Reply-To: <20210327043339.148050-1-liujian56@huawei.com>
To:     'Liu Jian <liujian56@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com, kuba@kernel.org,
        tanhuazhong@huawei.com, shenjian15@huawei.com,
        huangguangbin2@huawei.com, liaoguojia@huawei.com,
        moyufeng@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 12:33:39 +0800 you wrote:
> From: Liu Jian <liujian56@huawei.com>
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c: In function 'hclge_clear_arfs_rules':
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:7173:1: error: no return statement in function returning non-void [-Werror=return-type]
>  7173 | }
>       | ^
> cc1: some warnings being treated as errors
> make[6]: *** [scripts/Makefile.build:273: drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.o] Error 1
> make[5]: *** [scripts/Makefile.build:534: drivers/net/ethernet/hisilicon/hns3/hns3pf] Error 2
> make[4]: *** [scripts/Makefile.build:534: drivers/net/ethernet/hisilicon/hns3] Error 2
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [scripts/Makefile.build:534: drivers/net/ethernet/hisilicon] Error 2
> make[2]: *** [scripts/Makefile.build:534: drivers/net/ethernet] Error 2
> make[1]: *** [scripts/Makefile.build:534: drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:1980: drivers] Error 2
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: no return statement in hclge_clear_arfs_rules
    https://git.kernel.org/netdev/net-next/c/54422bd436e0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


