Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512D532F527
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCEVKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 522D8650AC;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=m/rUIqLPWADGD0R2avGUe5AEv6r0FxUd/ZNvpibpZuo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dWqTdHDLDnAbex7Tetm4yfvbiQ8Cuc4UeRDXTvk6czIVuis4WEQYO3FouAMmUwLP3
         RAiEQHAs4LLQLJ+9eSlVnUFFgBEFDXhd4fKNShN7QgSycUSUiv8yXUolSboSCoMpWc
         RhAU0abaq1r2UcwaFrRvFik841Nf53RHLS+afJ1wWfg2mNSXK5BpRb0PCzUER7YLRF
         9lGNIWSAUIAmu4xApIEXQ7H+HXDe2j43TyM7aTKEi/1FIB2PhLz0cbHnGnXvZi/jnR
         w4qQ6eBsUbUqWgkcCKCwJ0WTJZTCHRcvJQioUqDFDTKr7Glo+LKrMDaAaQIGpa2pox
         hiidpG/tCvExA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4BB3C60A3E;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: intel: iavf: fix error return code of
 iavf_init_get_resources()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860930.24588.6617205222590161114.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305031010.5396-1-baijiaju1990@gmail.com>
In-Reply-To: <20210305031010.5396-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 19:10:10 -0800 you wrote:
> When iavf_process_config() fails, no error return code of
> iavf_init_get_resources() is assigned.
> To fix this bug, err is assigned with the return value of
> iavf_process_config(), and then err is checked.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: intel: iavf: fix error return code of iavf_init_get_resources()
    https://git.kernel.org/netdev/net/c/6650d31f21b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


