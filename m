Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F2545500B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbhKQWDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhKQWDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CB43061AA7;
        Wed, 17 Nov 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637186408;
        bh=kqJEV/l6WEFj8ATHWNuOevwh3Oh/tZLgW5Dy9MB0TtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JBCsnEVA26Pat0rqzzBxtCw6ZiWA7T4U2VeinQaQ0UDSU/upxpslAehFEVMUCogTb
         95+AHag9VTnwCHmk2YeoQw79FstfWrMGpwU04qMo3wt3jZnr9U6f1vHQVqsikaLVZs
         V/4RxNoAxKs79fRRtIO7SKlh9b/Nm39FH1i1ukk/g3+Vv/ZjGeSWB/3QiPPH9bfPYS
         MmmruWMB7JSrvdvJg3OEXIgnDPn4yJj/OeWMdtz47vouuRhacgB1P7JLW5CPMtKmTY
         WE6hx4t9GVaymsNW10dAEJKhJDuEnHuIXxmaN/wL9hmzvZAhr2EbsZSX8eaju6rzZD
         iTbMdze2chskA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BEA2560A3A;
        Wed, 17 Nov 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] tc/m_vlan: fix print_vlan() conditional on
 TCA_VLAN_ACT_PUSH_ETH
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163718640877.17413.14201097251820086763.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 22:00:08 +0000
References: <091bdc88-9386-288e-25ba-7d369ad9a6b5@gmail.com>
In-Reply-To: <091bdc88-9386-288e-25ba-7d369ad9a6b5@gmail.com>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 17 Nov 2021 21:05:33 +0300 you wrote:
> Fix the wild bracket in the if clause leading to the error in the condition.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
> ---
>  tc/m_vlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [iproute2] tc/m_vlan: fix print_vlan() conditional on TCA_VLAN_ACT_PUSH_ETH
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=0e949725908b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


