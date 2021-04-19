Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5778E364E6C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhDSXKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhDSXKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:10:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 411DB6135F;
        Mon, 19 Apr 2021 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618873809;
        bh=xsCEHMiEkUY6pdh4Mocbir2/6LjGRFtrorAxhJOu+XY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AaF75wZ+12PFT20oUTYcp1Hc8BZK6V9SeaSaRYGA4dQrtCDMFqeInfVVjBoSnqui9
         SaLNA3vPVWYBJoX8z3qg3Zqz/3kgFnfzRyeiUzM/HKmeq83pm9E5zNBhZK8LGIKL2g
         C0MWHp/PAXot19CEz4iIk5JYofP05V03YAuxPYNXIxdEnkJLwvR5Px68F4+548lv7F
         42581HRgPRWGL/s8ARi72j04TW3Vd3YBU5XEdmAbHH/sc6nqJ7HCcBF97u8f3BoTfY
         lZA+ZQPOF6hYLNOqx4WkhA2jmL3ZF4H7MZq14WkgDr2uejFf1trNO2OD12Ciu7XjOr
         AF7KFXD2FwHhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35D8F60A13;
        Mon, 19 Apr 2021 23:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: fix a data race when get vlan device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887380921.661.11556898241153478379.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:10:09 +0000
References: <20210419135641.27077-1-zhudi21@huawei.com>
In-Reply-To: <20210419135641.27077-1-zhudi21@huawei.com>
To:     zhudi <zhudi21@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linyunsheng@huawei.com,
        netdev@vger.kernel.org, rose.chen@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Apr 2021 21:56:41 +0800 you wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> We encountered a crash: in the packet receiving process, we got an
> illegal VLAN device address, but the VLAN device address saved in vmcore
> is correct. After checking the code, we found a possible data
> competition:
> CPU 0:                             CPU 1:
>     (RCU read lock)                  (RTNL lock)
>     vlan_do_receive()		       register_vlan_dev()
>       vlan_find_dev()
> 
> [...]

Here is the summary with links:
  - [v2] net: fix a data race when get vlan device
    https://git.kernel.org/netdev/net/c/c1102e9d49eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


