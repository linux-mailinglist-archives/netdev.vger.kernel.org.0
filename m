Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2939ABD4
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFCUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhFCUbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AF87E613DE;
        Thu,  3 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622752204;
        bh=v33Y8hzSzAz8bXs5qBcy2kpzpIi3EjMSZcslhv84Ksk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cgEokcKE6eEj27mtzb4wTWSyg8cwjcQd7A/iX/HuuC7L74OpIeXArzS+a1xcUNjpA
         qhOs+IXcwKrfR5i1L482dHKTJlUD/62quTgvN7ZnLYUhLJDIqANcqL7XVJAHP2/Mtd
         q/35Qn2XxGMTmz7k/4UVYzHiJ6sR1cyLJhVjA8ovrAOws5qqMWnqTDA6/P/4OekKq+
         l651YjlCETde5pJIC3+VO2SyA7UDPdpIzt7xW/M1ELt29PsvL96neB5X6nCb/GHsdQ
         LzvnCbGo4P+48/SPsZeY0PLb9TLWDpS8b11lXxg5GAz6zkgWhKyTVHfFssGvZiFqLS
         JN0mWsuJ0+fWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DB2760A6C;
        Thu,  3 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] libceph: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275220464.19203.17231827580306620053.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 20:30:04 +0000
References: <20210602065635.106561-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065635.106561-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        idryomov@gmail.com, jlayton@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 14:56:35 +0800 you wrote:
> Fix some spelling mistakes in comments:
> enconding  ==> encoding
> ambigous  ==> ambiguous
> orignal  ==> original
> encyption  ==> encryption
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] libceph: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/dd0d91b91398

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


