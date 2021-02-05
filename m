Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F173102B5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 03:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBECUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 21:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229767AbhBECUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 21:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DA2DA64FB6;
        Fri,  5 Feb 2021 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612491606;
        bh=H+H/AegaPNy8zT1eA1zc6VeS9D+KFhBtz5zcPl0ASW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UGYOy6cyhpVhge4guA4V3aredNc2uV+bL/SxX8UsTxKd3t41rEeblpogLvYalOpP0
         F1mNNtRQOQIfdnASAvsUD76uwPln0RFGwNRR3T18DGmKriFooP1Cmjs3/MbNnazv8r
         byRTpLcfgg/TD4YrepGNQ7BCp19rOFtE9rnUEuGlBGbR6JEnkDPd3Rg1QQ6u0vfwoy
         KfyMzHMDJCx3fgqtycTH9dBhTaSH2xPBTGutFpPDuCyruyBkr455vtpd2LaLMDMarh
         79nlzmMzgXrr65OP9uAsOFOPoz5NLGzQLU2YePjNjACOBG/VRvfRK8f4S8DdYf7rW+
         tiUfzr5rbDOkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAC1A609F4;
        Fri,  5 Feb 2021 02:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: Add new T6 PCI device id 0x6092
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249160682.1910.11603408249834733728.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 02:20:06 +0000
References: <20210202182511.8109-1-rajur@chelsio.com>
In-Reply-To: <20210202182511.8109-1-rajur@chelsio.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rahul.lakkireddy@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Feb 2021 23:55:11 +0530 you wrote:
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next] cxgb4: Add new T6 PCI device id 0x6092
    https://git.kernel.org/netdev/net/c/3401e4aa43a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


