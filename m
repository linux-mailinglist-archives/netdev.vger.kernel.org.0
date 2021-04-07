Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F2D357795
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhDGWUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhDGWUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D1EE613A3;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617834030;
        bh=jK3i9c+Ff9HVf/ub1VC4VBdkYAYXnOlUkzuIqvJE1R0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cetLeuRyp3FFm0mEd2AlB9ND0h2j5Oge0GCT8U3AyAjNawtEU+7PIM47EU7L2jdQm
         lKqkfyZ93RNWB7N0lIc55rQGGbHcHkIqsChEgpXcR7wressScCIC2SUw9qJASykbfj
         3FHO/lSnlOVS934zacS7clTHccvkV9dvSguLr3cYUg1hr+LCUZ/U17ddjeKKvDzk0O
         Nqzp/ig+ddhf5xLdcxjlBJLENN1zZDJRGCbIoeCkvcVIJOBmze7dbNasQiPXpidxXN
         3S+RUmg7X1kuwO0xHZ9TXXb/DE8vlM7cfJ5PRGdi2CSIy9GKRwesWOsbqK8ny/v4Et
         Hg1xKuF7c0Ryg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7619F609D8;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: atheros: atl2: use module_pci_driver to
 simplify the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783403047.11274.1611402729496536593.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:20:30 +0000
References: <20210407150711.367154-1-weiyongjun1@huawei.com>
In-Reply-To: <20210407150711.367154-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     chris.snook@gmail.com, kuba@kernel.org,
        christophe.jaillet@wanadoo.fr, tglx@linutronix.de,
        jesse.brandeburg@intel.com, zhengyongjun3@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 7 Apr 2021 15:07:11 +0000 you wrote:
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  .../atheros/atlx/atl2.c        | 24 +---------------------
>  1 file changed, 1 insertion(+), 23 deletions(-)

Here is the summary with links:
  - [net-next] net: atheros: atl2: use module_pci_driver to simplify the code
    https://git.kernel.org/netdev/net-next/c/6381c45b2838

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


