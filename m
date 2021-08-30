Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E383FB2B3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhH3IvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhH3IvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 04:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB1BF61008;
        Mon, 30 Aug 2021 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630313408;
        bh=DcbZHDnByRqTIoS8tib7jpimDjhbTVGqMhUBZNlyF/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cqwRdBQGWzMMMxDUEqzuURYWruNNBj/VPfDSk/ab5sjHwWE29+FTxQFUN06FPyp2Y
         xx58JtvPp6paW4M2gjo1JOKD6ZtueeISBKsZ6jLXYlEIxBn+C/nVSyL3e3Yog/HU4K
         wfpHlqrzMNeALf1PORrTbaVeEuoGDK/NgsvUCc0FkO5i4KptRUh/d64XJJJrvvxV1j
         s5PAz7kM0PkTQj2NKy7w0qag5eU+EZy8b+A/LeUpsziBFK8swegBPEvF5bJDcHJXov
         yXfJjUKMUWnx0rJpvCUnMwaFqwP59PZp7KPWpw6oXKPl7GM3D+UoA/FjsdSyulHFUE
         MqMrje8dlXL6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D023660A6C;
        Mon, 30 Aug 2021 08:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: hns3: add some cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163031340884.11172.2108264388873148600.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 08:50:08 +0000
References: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1630303602-44870-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 14:06:35 +0800 you wrote:
> This series includes some cleanups for the HNS3 ethernet driver.
> 
> 
> Guangbin Huang (2):
>   net: hns3: reconstruct function hclge_ets_validate()
>   net: hns3: refine function hclge_dbg_dump_tm_pri()
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: hns3: initialize each member of structure array on a separate line
    https://git.kernel.org/netdev/net-next/c/60fe9ff9b7cb
  - [net-next,2/7] net: hns3: reconstruct function hns3_self_test
    https://git.kernel.org/netdev/net-next/c/4c8dab1c709c
  - [net-next,3/7] net: hns3: reconstruct function hclge_ets_validate()
    https://git.kernel.org/netdev/net-next/c/161ad669e6c2
  - [net-next,4/7] net: hns3: refine function hclge_dbg_dump_tm_pri()
    https://git.kernel.org/netdev/net-next/c/04d96139ddb3
  - [net-next,5/7] net: hns3: modify a print format of hns3_dbg_queue_map()
    https://git.kernel.org/netdev/net-next/c/5aea2da59303
  - [net-next,6/7] net: hnss3: use max() to simplify code
    https://git.kernel.org/netdev/net-next/c/38b99e1ede32
  - [net-next,7/7] net: hns3: uniform parameter name of hclge_ptp_clean_tx_hwts()
    https://git.kernel.org/netdev/net-next/c/52d89333d219

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


