Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E860461A1E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378832AbhK2Opf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:45:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43666 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379173AbhK2On2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:43:28 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DF3B61536;
        Mon, 29 Nov 2021 14:40:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 533686056B;
        Mon, 29 Nov 2021 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638196810;
        bh=0QZyL1/omFoFM0oSe+ruCABogOsAksI9L44Xdvjnsro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CyubTxm4PWvQqaAVi9bm7PZ5E5QhVkNOTe67JIDwap1mE0Vb1WbMGNnaVTytxdHNT
         2v14XBX1ThLLQGcjVEj71sQugEQrJa8D9pr0oOF1Me+4XVYNmnSBSeevAS2rFADBrO
         TWNqu+LH7EPUfMG82vf1fDlJYgrN4zDmHyFnLKVL7j/t45WJ0FXHEay2YoQRtfi2MP
         g3GszrQCumJbi/XTVFW7riOiNIGFRN9qe4HbuFxvLL7/vtMcbEHUYqH1EqAtSdghAy
         0mPZ+EbJsQDUwtzmuySDw/xSoHjk7vUp8/t0cLX8R3Fy+2Y/LaUfQq9pNmrq7cP0Zq
         RTQf9wUxFM7+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AED860A88;
        Mon, 29 Nov 2021 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: hns3: some cleanups for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819681023.20833.8288126722128597970.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 14:40:10 +0000
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 22:00:17 +0800 you wrote:
> To improve code readability and simplicity, this series refactor some
> functions in the HNS3 ethernet driver.
> 
> Guangbin Huang (3):
>   net: hns3: refine function hclge_cfg_mac_speed_dup_hw()
>   net: hns3: add new function hclge_tm_schd_mode_tc_base_cfg()
>   net: hns3: refine function hclge_tm_pri_q_qs_cfg()
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: hns3: refactor reset_prepare_general retry statement
    https://git.kernel.org/netdev/net-next/c/ed0e658c51aa
  - [net-next,02/10] net: hns3: refactor hns3_nic_reuse_page()
    https://git.kernel.org/netdev/net-next/c/e74a726da2c4
  - [net-next,03/10] net: hns3: refactor two hns3 debugfs functions
    https://git.kernel.org/netdev/net-next/c/e6fe5e167185
  - [net-next,04/10] net: hns3: split function hns3_get_tx_timeo_queue_info()
    https://git.kernel.org/netdev/net-next/c/a4ae2bc0abd4
  - [net-next,05/10] net: hns3: refine function hclge_cfg_mac_speed_dup_hw()
    https://git.kernel.org/netdev/net-next/c/e46da6a3d4d3
  - [net-next,06/10] net: hns3: add new function hclge_tm_schd_mode_tc_base_cfg()
    https://git.kernel.org/netdev/net-next/c/7ca561be11d0
  - [net-next,07/10] net: hns3: refine function hclge_tm_pri_q_qs_cfg()
    https://git.kernel.org/netdev/net-next/c/e06dac5290b7
  - [net-next,08/10] net: hns3: split function hns3_nic_get_stats64()
    https://git.kernel.org/netdev/net-next/c/8469b645c9a1
  - [net-next,09/10] net: hns3: split function hns3_handle_bdinfo()
    https://git.kernel.org/netdev/net-next/c/2fbf6a07f537
  - [net-next,10/10] net: hns3: split function hns3_set_l2l3l4()
    https://git.kernel.org/netdev/net-next/c/1d851c0905f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


