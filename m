Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB6426F00
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhJHQcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhJHQcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 12:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D4B161100;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633710609;
        bh=a2RWUglBnePDjwXad+5X/rY7xPq8qmbFo2Nu3/OS+OQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O3n4sfQ8xlavh/Ib1/6cNjIIAATvMG7ns7isvR/EJzfqBiAqw60nZMUBEzfAoqjlc
         uzdjpbbbOpu/cADuKGkZho4J6+WtDUqlRpTH5JWvjP/+RzpzXU8a6OnMB5voiWtx9f
         2mEoH7b+A7mh+8HGuyHgZB4rJXQgPGABe0n+UUh4z+LcrGjiec8+hNHVNOzdK5v4bi
         7WdKhjJqQTDhToqGzzJRP6hVRt6NCDpuAQbLj/sb5uOKlNQkclnUxVjRZGIsaNIIVz
         i4qRyp6afGJp8DltGCnxFT44rIFWQaP7G0XnWe7u11PU+S8RHNmMVxozkRlCHeWRL/
         0mZwabPSg+O3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40C7E60A44;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][v2] qed: Fix compilation for CONFIG_QED_SRIOV undefined
 scenario
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163371060925.30754.4325766747283798114.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 16:30:09 +0000
References: <20211007155238.4487-1-pkushwaha@marvell.com>
In-Reply-To: <20211007155238.4487-1-pkushwaha@marvell.com>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, aelior@marvell.com, smalin@marvell.com,
        jhasan@marvell.com, mrangankar@marvell.com,
        prabhakar.pkin@gmail.com, malin1024@gmail.com,
        naresh.kamboju@linaro.org, okulkarni@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 7 Oct 2021 18:52:38 +0300 you wrote:
> This patch fixes below compliation error in case CONFIG_QED_SRIOV not
> defined.
> drivers/net/ethernet/qlogic/qed/qed_dev.c: In function
> ‘qed_fw_err_handler’:
> drivers/net/ethernet/qlogic/qed/qed_dev.c:2390:3: error: implicit
> declaration of function ‘qed_sriov_vfpf_malicious’; did you mean
> ‘qed_iov_vf_task’? [-Werror=implicit-function-declaration]
>    qed_sriov_vfpf_malicious(p_hwfn, &data->err_data);
>    ^~~~~~~~~~~~~~~~~~~~~~~~
>    qed_iov_vf_task
> drivers/net/ethernet/qlogic/qed/qed_dev.c: In function
> ‘qed_common_eqe_event’:
> drivers/net/ethernet/qlogic/qed/qed_dev.c:2410:10: error: implicit
> declaration of function ‘qed_sriov_eqe_event’; did you mean
> ‘qed_common_eqe_event’? [-Werror=implicit-function-declaration]
>    return qed_sriov_eqe_event(p_hwfn, opcode, echo, data,
>           ^~~~~~~~~~~~~~~~~~~
>           qed_common_eqe_event
> 
> [...]

Here is the summary with links:
  - [v2] qed: Fix compilation for CONFIG_QED_SRIOV undefined scenario
    https://git.kernel.org/netdev/net-next/c/e761523d0b40

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


