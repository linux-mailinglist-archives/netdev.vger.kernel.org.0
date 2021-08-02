Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074AA3DD2F8
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhHBJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhHBJaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B46D610E5;
        Mon,  2 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627896606;
        bh=uJ8qBOBoWCPvozYRggQhKBkhxaIW6EfP4lOXQasvmZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RKSLcT5pw38pVftGXYpYNmWVlzQujXWVFWu6fN+ErPBSbCDoQp/udk5tzGmEdsq1x
         fra+za/uIsInRD3n2L+XIbJPwO9m81DBBYlnN+X2dGlgYGiYkT9i2QpTQrn9ilNJSN
         1TgRnnJ9BhsYnXfd6WRhXwh41CVwkEW1mCkwwsQiJibV8/E8HrTYwqxJVMjbxM68Yz
         1KnzbGP7KHYevgJZ/5//A22UBymWezVRT7j+AFLTi8QYth43IxMZssCfmblps4un+I
         IVTFrSc4ozThCLiTYJsySFjN3df2bJmBeVP9uuSMIouNWMdLdTcx2d4Er2crt3deYt
         K3O+EaoDL07sQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9084A60A38;
        Mon,  2 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] bonding: 3ad: fix the concurrency between
 __bond_release_one() and bond_3ad_state_machine_handler()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162789660658.5679.14400779141118515659.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 09:30:06 +0000
References: <1627611551-33333-1-git-send-email-moyufeng@huawei.com>
In-Reply-To: <1627611551-33333-1-git-send-email-moyufeng@huawei.com>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jay.vosburgh@canonical.com,
        jiri@resnulli.us, netdev@vger.kernel.org, nikolay@nvidia.com,
        shenjian15@huawei.com, lipeng321@huawei.com,
        yisen.zhuang@huawei.com, linyunsheng@huawei.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        salil.mehta@huawei.com, linuxarm@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 30 Jul 2021 10:19:11 +0800 you wrote:
> Some time ago, I reported a calltrace issue
> "did not find a suitable aggregator", please see[1].
> After a period of analysis and reproduction, I find
> that this problem is caused by concurrency.
> 
> Before the problem occurs, the bond structure is like follows:
> 
> [...]

Here is the summary with links:
  - [V2,net-next] bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
    https://git.kernel.org/netdev/net-next/c/220ade77452c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


