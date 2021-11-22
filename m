Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD864458EDE
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbhKVNDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232089AbhKVNDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 08:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B1AA560F9D;
        Mon, 22 Nov 2021 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637586013;
        bh=fvznHXVCO2jkCGop3iXqSKromcXKmeTKcsQo92J+Koo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NY9W75cLC6w7E+B02qShS+bZ7+3qDNC+bnuSqK8l4F8HlYAyndehhbvkjAXYU79I+
         OAr3NZL2K6kXX5uozS3cvQIA4EfdJ3vUE+YFMtewad6ARP9ilVeAyC+q6fOiFxXB3T
         pdaH4xxokErtALbWlopyC7sorlF0quzPXzQ1r0yHUMIUE/2EeW7NqXnKig4uGMUZNv
         CgA/Kj30fc7O3TAcfxji3NbRn5PvUjNIqOD/Rhjg8WcfVVIMGho/6tu2EI+361O78a
         xHK/Chqi1/CP2akMuCLpDgn7BuvKPWCivgBdaTjQnEgGfLXpu9pdSrkmw3zFFCPuLX
         vTkm4YbmxwaLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A604D60A50;
        Mon, 22 Nov 2021 13:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V7 net-next 0/6] ethtool: add support to set/get tx copybreak
 buf size and rx buf len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758601367.20556.3844471196744210850.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 13:00:13 +0000
References: <20211118121245.49842-1-huangguangbin2@huawei.com>
In-Reply-To: <20211118121245.49842-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, amitc@mellanox.com, idosch@idosch.org,
        danieller@nvidia.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 20:12:39 +0800 you wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> This series add support to set/get tx copybreak buf size and rx buf len via
> ethtool and hns3 driver implements them.
> 
> Tx copybreak buf size is used for tx copybreak feature which for small size
> packet or frag. Use ethtool --get-tunable command to get it, and ethtool
> --set-tunable command to set it, examples are as follow:
> 
> [...]

Here is the summary with links:
  - [V7,net-next,1/6] ethtool: add support to set/get tx copybreak buf size via ethtool
    https://git.kernel.org/netdev/net-next/c/448f413a8bdc
  - [V7,net-next,2/6] net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver
    https://git.kernel.org/netdev/net-next/c/e445f08af2b1
  - [V7,net-next,3/6] ethtool: add support to set/get rx buf len via ethtool
    https://git.kernel.org/netdev/net-next/c/0b70c256eba8
  - [V7,net-next,4/6] ethtool: extend ringparam setting/getting API with rx_buf_len
    https://git.kernel.org/netdev/net-next/c/7462494408cd
  - [V7,net-next,5/6] net: hns3: add support to set/get rx buf len via ethtool for hns3 driver
    https://git.kernel.org/netdev/net-next/c/e65a0231d2ca
  - [V7,net-next,6/6] net: hns3: remove the way to set tx spare buf via module parameter
    https://git.kernel.org/netdev/net-next/c/e175eb5fb054

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


