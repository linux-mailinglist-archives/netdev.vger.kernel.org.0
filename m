Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06793355FBC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344799AbhDFXuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344773AbhDFXuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96880613B3;
        Tue,  6 Apr 2021 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617753009;
        bh=XB8uvK3LjPTesxavhFL8ObIU4sl1tHDs0U1LPEIvY+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N87Nq3bJEIZdSU496cTgMZHh7DOTLQPBstjZKFuofdgF5d6cPZld3kIZgD/gdqSR0
         91Qf+4D/kqStzQz8v+2ffSgpaPNvExhrVL6jYLv77x+W4/RJ0vITnzOrK6pL4d7rbQ
         0SjQmRVuL1muyWbdKPKAiWkuPnl6mPmSO+tZYWDNkYyXcV59ZYelwQrarTk1g9i9tc
         elhGPhmmecHSXedJk+IaJ87vBCaNjrSDJLmXkCRFnyADF7qEOwXaJhEuTujFf3l+3Z
         Fa44Gju70zX4mVd10dF82BIL/07qoCIpzh/Cs2IpZA0xYsfVeSt4WRhNDAOaeSJvTQ
         +2Dh+b2mwIgJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87C81609FF;
        Tue,  6 Apr 2021 23:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns3: clear VF down state bit before request link
 status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775300955.25054.4398950872585819723.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:50:09 +0000
References: <1617714643-25535-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1617714643-25535-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com,
        huangguangbin2@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 6 Apr 2021 21:10:43 +0800 you wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> Currently, the VF down state bit is cleared after VF sending
> link status request command. There is problem that when VF gets
> link status replied from PF, the down state bit may still set
> as 1. In this case, the link status replied from PF will be
> ignored and always set VF link status to down.
> 
> [...]

Here is the summary with links:
  - [net] net: hns3: clear VF down state bit before request link status
    https://git.kernel.org/netdev/net/c/ed7bedd2c3ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


