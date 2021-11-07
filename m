Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9F447542
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhKGTcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhKGTcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E1FE61208;
        Sun,  7 Nov 2021 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636313407;
        bh=VeJIKIbzY6KnrBQrQeHSK+XFH0ryb4xdT9nxm7kt1UY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e3sGpaKwB4u4QBfWHZv7reSN/wf9X5ZBsChv7EmCAEHmz9l0O0oesa4seZS/eS22T
         usWlOgUmLje4uqZFD9qlq+0ILiv8EOWGR0OcpCzl6o+kyarKwsHc4Urv7Cl8MKNSK9
         TXYgK9XnsQyLfoN18pjjGJzJzkCB9bhkt08JEV3am5FNtcND9a5VSxsYW4Pj7LscUm
         HoS06pklenOrjyaflfBM9T5PDSmnx82RZhU1tgHChidwxVR5LUgUz7QDKQstLDWJrV
         uH83Zi82EH3ujHR7+pJerg1POu80YI4DFG53fVefK3mBWGCFGKcWQ72V5hVBhoyhPS
         x7afEPsUOB6og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 423D460AA2;
        Sun,  7 Nov 2021 19:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] net: hisilicon: fix hsn3_ethtool kernel-doc warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631340726.13867.614351698615394170.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:30:07 +0000
References: <20211106031441.3004-1-rdunlap@infradead.org>
In-Reply-To: <20211106031441.3004-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, lkp@intel.com, lipeng321@huawei.com,
        huangguangbin2@huawei.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 20:14:41 -0700 you wrote:
> Fix kernel-doc warnings and spacing in hns3_ethtool.c:
> 
> hns3_ethtool.c:246: warning: No description found for return value of 'hns3_lp_run_test'
> hns3_ethtool.c:408: warning: expecting prototype for hns3_nic_self_test(). Prototype was for hns3_self_test() instead
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Peng Li <lipeng321@huawei.com>
> Cc: Guangbin Huang <huangguangbin2@huawei.com>
> Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
> Cc: Salil Mehta <salil.mehta@huawei.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [-net] net: hisilicon: fix hsn3_ethtool kernel-doc warnings
    https://git.kernel.org/netdev/net/c/85879f131d78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


