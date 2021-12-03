Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90A467617
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380341AbhLCLXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:23:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49170 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243475AbhLCLXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:23:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAC9AB826A9;
        Fri,  3 Dec 2021 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 983E4C53FCB;
        Fri,  3 Dec 2021 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638530410;
        bh=Z7cZ4l8YkeJ1v/9e4ilGEV8+Xpxrup9MldY1JYiGHaQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=erATOlhDkkpnNDqlze2ZUdM2pFHz056l5R8EZ86WK4QA+04lN40nZw9kmrfAsO/+j
         bznsYX1ILonvsLZeJJziGZStL0eFetWH+ixZRMO0CcIJz1gREPrGLdg7yDfOmd0xI+
         mupYWfms6YHIZSN4c3NTCWzSTIZAaDfVLW1A/AtFEwd9+MxTsunvRyhNH3qNmkf003
         WrOmsPfJSB+NNUYKteywROazdjGXJYO4QLlaq2NgPRPjxnCml6MMljh2vjx53sUiCC
         a4zQWDQJI/MIfkVMZeUh7dNQeCL8q+srvta2SG6SfKv5lHggKCgsj0wny0MZ9lDlFi
         SKk+zo4fGS03A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7781C60BD8;
        Fri,  3 Dec 2021 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] net: hns3: some cleanups for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163853041048.14824.13199561450233466918.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 11:20:10 +0000
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
In-Reply-To: <20211203092059.24947-1-huangguangbin2@huawei.com>
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

On Fri, 3 Dec 2021 17:20:48 +0800 you wrote:
> To improve code readability and simplicity, this series add some cleanup
> patches for the HNS3 ethernet driver.
> 
> Guangbin Huang (3):
>   net: hns3: refactor function hclge_set_vlan_filter_hw
>   net: hns3: add print vport id for failed message of vlan
>   net: hns3: modify one argument type of function
>     hclge_ncl_config_data_print
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: hns3: optimize function hclge_cfg_common_loopback()
    https://git.kernel.org/netdev/net-next/c/23e0316049af
  - [net-next,02/11] net: hns3: refactor function hclge_set_vlan_filter_hw
    https://git.kernel.org/netdev/net-next/c/e7a51bf590e3
  - [net-next,03/11] net: hns3: add print vport id for failed message of vlan
    https://git.kernel.org/netdev/net-next/c/114967adbc3d
  - [net-next,04/11] net: hns3: Align type of some variables with their print type
    https://git.kernel.org/netdev/net-next/c/0cc25c6a14ef
  - [net-next,05/11] net: hns3: modify one argument type of function hclge_ncl_config_data_print
    https://git.kernel.org/netdev/net-next/c/72dcdec10fad
  - [net-next,06/11] net: hns3: align return value type of atomic_read() with its output
    https://git.kernel.org/netdev/net-next/c/9fcadbaae8ea
  - [net-next,07/11] net: hns3: add void before function which don't receive ret
    https://git.kernel.org/netdev/net-next/c/5ac4f180bd07
  - [net-next,08/11] net: hns3: add comments for hclge_dbg_fill_content()
    https://git.kernel.org/netdev/net-next/c/4e599dddeea4
  - [net-next,09/11] net: hns3: remove rebundant line for hclge_dbg_dump_tm_pg()
    https://git.kernel.org/netdev/net-next/c/40975e749daa
  - [net-next,10/11] net: hns3: replace one tab with space in for statement
    https://git.kernel.org/netdev/net-next/c/7acf76b1cd01
  - [net-next,11/11] net: hns3: fix hns3 driver header file not self-contained issue
    https://git.kernel.org/netdev/net-next/c/184da9dc780e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


