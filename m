Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA739E7A0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFGTl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhFGTl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 15:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C0B161185;
        Mon,  7 Jun 2021 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623094805;
        bh=04sozYDym0UmShT6KnGNpFHlUkKfQ04l+kP+f9TaD84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uvjJz/eIlijpuPuISlzHs9Zodck0mPsMmhd7UgakyLleNiJazT5bJH2gXeX06vuHM
         +p/AMoMIQjxJhb2+Flk3Pzxazp2zwkoihBaeA0NjMJjHkx7or9rd4NBqWcxfMJbtdt
         DcyiwKj/4aK+WAiBN6udM7LW9OOhFQd/CCtQdt0JBf7Swc8f3nT/zGoMSW2JHklMu7
         RwqjnO1j7t33po+sc1DtiQ1brnupvjI3bK3T0P2TH9dPtEit2FYBL34zw+Fqm1XsQk
         WdQRDtOsB65zDlDrgeuKhkCinJn6NVk8q9mexkrVYrCetPsoeRj+F/AHGNkCpQ0jro
         tg7Q93QoKCYbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DF45609F1;
        Mon,  7 Jun 2021 19:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/13] fix dox warning in net/sched/sch_htb.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309480537.22793.7835105473549146742.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 19:40:05 +0000
References: <20210605101845.1264706-1-yukuai3@huawei.com>
In-Reply-To: <20210605101845.1264706-1-yukuai3@huawei.com>
To:     yukuai (C) <yukuai3@huawei.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 5 Jun 2021 18:18:32 +0800 you wrote:
> Yu Kuai (13):
>   sch_htb: fix doc warning in htb_add_to_wait_tree()
>   sch_htb: fix doc warning in htb_next_rb_node()
>   sch_htb: fix doc warning in htb_add_class_to_row()
>   sch_htb: fix doc warning in htb_remove_class_from_row()
>   sch_htb: fix doc warning in htb_activate_prios()
>   sch_htb: fix doc warning in htb_deactivate_prios()
>   sch_htb: fix doc warning in htb_class_mode()
>   sch_htb: fix doc warning in htb_change_class_mode()
>   sch_htb: fix doc warning in htb_activate()
>   sch_htb: fix doc warning in htb_deactivate()
>   sch_htb: fix doc warning in htb_charge_class()
>   sch_htb: fix doc warning in htb_do_events()
>   sch_htb: fix doc warning in htb_lookup_leaf()
> 
> [...]

Here is the summary with links:
  - [01/13] sch_htb: fix doc warning in htb_add_to_wait_tree()
    https://git.kernel.org/netdev/net-next/c/4d7efa73fa26
  - [02/13] sch_htb: fix doc warning in htb_next_rb_node()
    https://git.kernel.org/netdev/net-next/c/274e5d0e55aa
  - [03/13] sch_htb: fix doc warning in htb_add_class_to_row()
    https://git.kernel.org/netdev/net-next/c/996bccc39afb
  - [04/13] sch_htb: fix doc warning in htb_remove_class_from_row()
    https://git.kernel.org/netdev/net-next/c/5f8c6d05f390
  - [05/13] sch_htb: fix doc warning in htb_activate_prios()
    https://git.kernel.org/netdev/net-next/c/876b5fc0c0fb
  - [06/13] sch_htb: fix doc warning in htb_deactivate_prios()
    https://git.kernel.org/netdev/net-next/c/4113be2020a8
  - [07/13] sch_htb: fix doc warning in htb_class_mode()
    https://git.kernel.org/netdev/net-next/c/1e9559527a9d
  - [08/13] sch_htb: fix doc warning in htb_change_class_mode()
    https://git.kernel.org/netdev/net-next/c/4b479e9883ce
  - [09/13] sch_htb: fix doc warning in htb_activate()
    https://git.kernel.org/netdev/net-next/c/8df7e8fff8da
  - [10/13] sch_htb: fix doc warning in htb_deactivate()
    https://git.kernel.org/netdev/net-next/c/9a034f25e472
  - [11/13] sch_htb: fix doc warning in htb_charge_class()
    https://git.kernel.org/netdev/net-next/c/0e5c90848a28
  - [12/13] sch_htb: fix doc warning in htb_do_events()
    https://git.kernel.org/netdev/net-next/c/2c3ee53ea663
  - [13/13] sch_htb: fix doc warning in htb_lookup_leaf()
    https://git.kernel.org/netdev/net-next/c/9977d6f56bac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


