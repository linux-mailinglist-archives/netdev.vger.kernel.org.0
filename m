Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1BB3ED1FC
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbhHPKar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235747AbhHPKah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3445661BD3;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109806;
        bh=I1Z4HkqPElxo7ykLLZYLEAjg4SiMBmHybLgR0Vo3IQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6kE3udF+eRuikx0h154mJooTcjf4suZromW8VbhqN0zhKwHg/hhl/XfC5oZiD0XI
         Yyckq/I6uBR0nmS9GDAcqYx1g6KAMJfwC8WKNT83PAQn6Y3jkDCl1riMgRZ9vclYlw
         HVPOAD7/PBmZpTXRbKF+S87+r264I2sDThR81CkSQC7hHrCD4Bd9GIbuh20BkXP4wR
         Uaedk7DT8sSyfXM7sVH3qErtj4ierRXnh8dpjJegMEL5uTBYcibkgKtma20fm6HKjp
         LD2AMF1qp+EC96LMXcgxTQyAnMoqvmr3Ek+T2TU+72L21p/2PgHPHdWEEoq+7glHkZ
         FJfyqZB20v2xQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2ACA3609DA;
        Mon, 16 Aug 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] qed: Fix null-pointer dereference in qed_rdma_create_qp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980617.576.7149313268458422103.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:06 +0000
References: <20210815110639.20131-1-smalin@marvell.com>
In-Reply-To: <20210815110639.20131-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        islituo@gmail.com, aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Aug 2021 14:06:39 +0300 you wrote:
> Fix a possible null-pointer dereference in qed_rdma_create_qp().
> 
> Changes from V2:
> - Revert checkpatch fixes.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - [v2] qed: Fix null-pointer dereference in qed_rdma_create_qp()
    https://git.kernel.org/netdev/net/c/d33d19d313d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


