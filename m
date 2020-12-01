Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B16A2CB0C9
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 00:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgLAXat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 18:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgLAXas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 18:30:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/7] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160686540803.30098.7846327880207474986.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Dec 2020 23:30:08 +0000
References: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 28 Nov 2020 11:51:43 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> #1~#6: add some updates related to the checksum offload.
> #7: add support for multiple TCs' MAC pauce mode.
> 
> change log:
> V2: fixes some sparse errors in #1 & #5.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/7] net: hns3: add support for RX completion checksum
    https://git.kernel.org/netdev/net-next/c/4b2fe769aad9
  - [V2,net-next,2/7] net: hns3: add support for TX hardware checksum offload
    https://git.kernel.org/netdev/net-next/c/66d52f3bf385
  - [V2,net-next,3/7] net: hns3: remove unsupported NETIF_F_GSO_UDP_TUNNEL_CSUM
    https://git.kernel.org/netdev/net-next/c/57e72c121c7f
  - [V2,net-next,4/7] net: hns3: add udp tunnel checksum segmentation support
    https://git.kernel.org/netdev/net-next/c/3e2816219d7c
  - [V2,net-next,5/7] net: hns3: add more info to hns3_dbg_bd_info()
    https://git.kernel.org/netdev/net-next/c/b1533ada7480
  - [V2,net-next,6/7] net: hns3: add a check for devcie's verion in hns3_tunnel_csum_bug()
    https://git.kernel.org/netdev/net-next/c/ade36ccef1d7
  - [V2,net-next,7/7] net: hns3: keep MAC pause mode when multiple TCs are enabled
    https://git.kernel.org/netdev/net-next/c/d78e5b6a6764

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


