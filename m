Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90229455A0C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbhKRLY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343787AbhKRLXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:23:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E167361AD2;
        Thu, 18 Nov 2021 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637234408;
        bh=CoWvvJ5SUlmGMCDBGkTvshowClGajIqZ5Cr0Xwr7xHc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I1vWlZbwHiwLgB8K6biR3K2diYzSBc9Qj3S/u2m4Wu7IiVpD8fUrIzZ0dmw3CWMFp
         RcI9Stk2Br46AyjzK18b9TIxlhp7VPDz3snq2D8mfIIAicc2w3IpbAe22P/T5H/2ld
         tokZVNDyIQ/f6F5ud30HWkanXzL6OGbFLuI5PhyZf+aVxX349aFAflmaPdhSL/QoQR
         80QGOsEbIP4odleYamJrTL7+bZIeipxDTVAlFy/i06PRDrBDB/8Bx6g7/u1RDPro1w
         B62MEyivubZ5+/42E6ugpT/6X96MFBo4a+YuAx0/2Y8rkrIKa6iNYHoYxLHm/wyl6K
         7NyrhyLiI8IGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D487160A4E;
        Thu, 18 Nov 2021 11:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array
 overflow in hns_dsaf_ge_srst_by_port()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723440886.3044.13326844858914802767.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:20:08 +0000
References: <20211117034453.28963-1-starmiku1207184332@gmail.com>
In-Reply-To: <20211117034453.28963-1-starmiku1207184332@gmail.com>
To:     Teng Qi <starmiku1207184332@gmail.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, lipeng321@huawei.com,
        huangguangbin2@huawei.com, zhengyongjun3@huawei.com,
        liuyonglong@huawei.com, shenyang39@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, islituo@gmail.com, oslab@tsinghua.edu.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 11:44:53 +0800 you wrote:
> The if statement:
>   if (port >= DSAF_GE_NUM)
>         return;
> 
> limits the value of port less than DSAF_GE_NUM (i.e., 8).
> However, if the value of port is 6 or 7, an array overflow could occur:
>   port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;
> 
> [...]

Here is the summary with links:
  - ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
    https://git.kernel.org/netdev/net/c/a66998e0fbf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


