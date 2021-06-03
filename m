Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3CE39AE14
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFCWb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhFCWbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD1F261415;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759407;
        bh=82opp1R6c6w+OH9D20F388KzxcIs9OjI1tPESvUXMH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ICnZNZdeksxveS6OtdhPtE+R+JkzmP8DXBSsHPfsAilZLPDUD6a3abIAkaIt6O75A
         1XM/JQk6WLMC3ac3oYzbT4aizN+baOYXcsSAx/V/fzQqfq1LzWP7lHKX5jWFWyxAGZ
         gWwB6B3YErL+Ivj1lpXfq+p1nD4iR17+QOV5qMp8C5BNxq//R+5ljYg3LxqgKqxH5x
         P8e+EhXq+L010H6AetBG1jsgpTKGJ+KDqTx20CPgNl73U9VW8JtF8BtaLICghUPkbe
         ZPwFzYjRrV5MiUageB9jtx9Bt8h5DOassHT/PiJ+LkjjMyIT1Za5/uCKCA4ZlNzSU7
         mQEMXAwyjY9Ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE86160A6F;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sch_htb: fix doc warning in htb_add_to_id_tree()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940784.8870.14994575928756160799.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:07 +0000
References: <20210603140749.3045725-1-yukuai3@huawei.com>
In-Reply-To: <20210603140749.3045725-1-yukuai3@huawei.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 3 Jun 2021 22:07:49 +0800 you wrote:
> Add description for parameters of htb_add_to_id_tree() to fix
> gcc W=1 warnings:
> net/sched/sch_htb.c:282: warning: Function parameter or member 'root' not described in 'htb_add_to_id_tree'
> net/sched/sch_htb.c:282: warning: Function parameter or member 'cl' not described in 'htb_add_to_id_tree'
> net/sched/sch_htb.c:282: warning: Function parameter or member 'prio' not described in 'htb_add_to_id_tree'
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> [...]

Here is the summary with links:
  - sch_htb: fix doc warning in htb_add_to_id_tree()
    https://git.kernel.org/netdev/net-next/c/a10541f5d9fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


