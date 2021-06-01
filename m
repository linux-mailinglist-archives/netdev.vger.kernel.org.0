Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65779396D17
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFAGBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAGBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 02:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D5AFC61375;
        Tue,  1 Jun 2021 06:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622527204;
        bh=hRnoa3eOGnYroPPcNEfoQ0Ex7auD0Y2pFJGB/7zcF0Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QNlXjmriNm22woDVLpeh3zieKJE6Oqz/uASMREE/+b+WmBStPZrw+90o9+3PmrbTa
         dOQHuZ8+m/sudADVWOhYUGnVsh5xQajYyD0mgX1NuKRVtQKAG+Gts19+uPIK5QqgSE
         k7Fm4qhLY9tWGqAqJ28hNLjQpe6RbTE/mnp2HbuO0yI9zBZaIisyAv6e2Dr6OQL9dG
         ngsWFbhhXMBCNvCbWwwxIxtibtVh3b43/lXISK92AI2AhJOQqaFK/sHBF0H03QrHRo
         lkbhy5vLqX+WdO5+FIkRONAJSgmMbig1uMr6PymSELGsXNvo8xnCLdybOf2HtHW1Ll
         eTtm+ewvtHN1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4E6960ACA;
        Tue,  1 Jun 2021 06:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: hns3: add VLAN filter control support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252720480.8628.16568170830538460479.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 06:00:04 +0000
References: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 10:38:37 +0800 you wrote:
> This patchset add VLAN filter control support for HNS3 driver.
> 
> Jian Shen (8):
>   net: hns3: add 'QoS' support for port based VLAN configuration
>   net: hns3: refine for hclge_push_vf_port_base_vlan_info()
>   net: hns3: remove unnecessary updating port based VLAN
>   net: hns3: refine function hclge_set_vf_vlan_cfg()
>   net: hns3: add support for modify VLAN filter state
>   net: hns3: add query basic info support for VF
>   net: hns3: add support for VF modify VLAN filter state
>   net: hns3: add debugfs support for vlan configuration
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: hns3: add 'QoS' support for port based VLAN configuration
    https://git.kernel.org/netdev/net-next/c/b44eb28d44a6
  - [net-next,2/8] net: hns3: refine for hclge_push_vf_port_base_vlan_info()
    https://git.kernel.org/netdev/net-next/c/f2dbf0ed4e0c
  - [net-next,3/8] net: hns3: remove unnecessary updating port based VLAN
    https://git.kernel.org/netdev/net-next/c/132023de7149
  - [net-next,4/8] net: hns3: refine function hclge_set_vf_vlan_cfg()
    https://git.kernel.org/netdev/net-next/c/060e9accaa74
  - [net-next,5/8] net: hns3: add support for modify VLAN filter state
    https://git.kernel.org/netdev/net-next/c/2ba306627f59
  - [net-next,6/8] net: hns3: add query basic info support for VF
    https://git.kernel.org/netdev/net-next/c/32e6d104c6fe
  - [net-next,7/8] net: hns3: add support for VF modify VLAN filter state
    https://git.kernel.org/netdev/net-next/c/fa6a262a2550
  - [net-next,8/8] net: hns3: add debugfs support for vlan configuration
    https://git.kernel.org/netdev/net-next/c/0ca821da86a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


