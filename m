Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC97C34B1F4
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 23:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCZWKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 18:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhCZWKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 18:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02C7661A28;
        Fri, 26 Mar 2021 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616796617;
        bh=8ZjZsS8VjHWtyXkfHW4HcoA2MYqicvhEcQIQarRE5Yg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GmKwzTB1H2B/QriQL5QZ2HXTSfhDSDA5s9Lx7Q9mnA+ZlQOk27cQkEn+Q23XNb2YF
         hKEIKci5IdON2/gvSDaHncOGGcvgHnneNV2fbwHfwiVbVPFrQMKtLV/8DF0WJxmPIz
         WjkrRtIERpD81RktvgWFTe+vTxcOzwn/VEHLGuHlcSQEo/aSQ9J07IoU+Yj5EdLKCo
         H9JOTr/lZMlQoJA+747KKFqCgHhp1wcOhkQcFlvTKcK8m3t920Qs1inO+OjQKJ0VS2
         8v8i4GAMaUeedIySJl7frBjG9TbLlE2cb46Ya2w576nXwGcTMwzrej4PIEh4m6pSlG
         Q0i0PxFBwWPDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7CD160971;
        Fri, 26 Mar 2021 22:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: hns3: add some cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679661674.26244.7267900565932108780.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 22:10:16 +0000
References: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 09:36:19 +0800 you wrote:
> This series includes some cleanups for the HNS3 ethernet driver.
> 
> Guojia Liao (1):
>   net: hns3: split out hclge_tm_vport_tc_info_update()
> 
> Huazhong Tan (3):
>   net: hns3: remove unused parameter from hclge_dbg_dump_loopback()
>   net: hns3: fix prototype warning
>   net: hns3: fix some typos in hclge_main.c
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: hns3: remove unused code of vmdq
    https://git.kernel.org/netdev/net-next/c/43f8b9333d86
  - [net-next,2/9] net: hns3: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/c0127115ee23
  - [net-next,3/9] net: hns3: remove redundant query in hclge_config_tm_hw_err_int()
    https://git.kernel.org/netdev/net-next/c/d914971df022
  - [net-next,4/9] net: hns3: remove unused parameter from hclge_set_vf_vlan_common()
    https://git.kernel.org/netdev/net-next/c/567d1dd3e4bc
  - [net-next,5/9] net: hns3: remove unused parameter from hclge_dbg_dump_loopback()
    https://git.kernel.org/netdev/net-next/c/1e49432b91d6
  - [net-next,6/9] net: hns3: fix prototype warning
    https://git.kernel.org/netdev/net-next/c/a1e144d7dc3c
  - [net-next,7/9] net: hns3: fix some typos in hclge_main.c
    https://git.kernel.org/netdev/net-next/c/f7be24f00702
  - [net-next,8/9] net: hns3: split function hclge_reset_rebuild()
    https://git.kernel.org/netdev/net-next/c/74d439b74ad3
  - [net-next,9/9] net: hns3: split out hclge_tm_vport_tc_info_update()
    https://git.kernel.org/netdev/net-next/c/b1261897b090

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


