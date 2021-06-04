Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3455639C2EC
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhFDVvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhFDVvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 34ED961159;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622843404;
        bh=/Drn2Nl1d8JZnUkF3vnGxSzLgOMl6p3utlvoZrWigOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nHrNVh7Ws1HHu+0sSqUdSgpOU5YQaOKxOtHZCym6JXRwqyJCSm6zkT6sohZsDcJ7V
         W+IXo5fuo6+npSUpsvigHLoll9ZzS9PUOsV23axFD9vtafLIai8w8hH/iCRpQrPleW
         F03ujwZWpFAVHwiu7/kICwnJPtv9i3f75+rHo8xEgB32xKyAtuNmD0XIWfF86QO/81
         zEUs0lj0TNpXt8bo+c8qhjEcNsZxK0ieY7o0y5NLVDxRP4isdwH2rB1t1W/+Jwj4Dh
         rbH4E1cojCwUzUz2vqT7ua6hDloxxop/IylYolylCPJIBXIZo8JnFwbfqD0TC/ooqF
         KGVD0N3fyWEsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23C26609B6;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_htb: fix refcount leak in htb_parent_to_leaf_offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284340414.5449.12585313149011194303.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:50:04 +0000
References: <1622804598-11164-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1622804598-11164-1-git-send-email-wangyunjian@huawei.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        maximmi@nvidia.com, tariqt@nvidia.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, dingxiaoxiong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 4 Jun 2021 19:03:18 +0800 you wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The commit ae81feb7338c ("sch_htb: fix null pointer dereference
> on a null new_q") fixes a NULL pointer dereference bug, but it
> is not correct.
> 
> Because htb_graft_helper properly handles the case when new_q
> is NULL, and after the previous patch by skipping this call
> which creates an inconsistency : dev_queue->qdisc will still
> point to the old qdisc, but cl->parent->leaf.q will point to
> the new one (which will be noop_qdisc, because new_q was NULL).
> The code is based on an assumption that these two pointers are
> the same, so it can lead to refcount leaks.
> 
> [...]

Here is the summary with links:
  - [net] sch_htb: fix refcount leak in htb_parent_to_leaf_offload
    https://git.kernel.org/netdev/net/c/944d671d5faa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


