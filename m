Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53054865B4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbiAFOA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:00:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37694 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiAFOAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 992F1B8216A;
        Thu,  6 Jan 2022 14:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 478E6C36AED;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641477610;
        bh=0pNJeAvmNsNgjjksHRl8yQZ1+q7D4cj5sbmP7MPcmpE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fWrEjUXDtzG4VhZ2gGLTV/E52yqjoSf7kK8D+ZctNQ2RBICZYjJCi/6pnpPpqjeKz
         XHykzoFFOdAYhEyTq7uSvTuPVAyViQjgfrSGoxVQ7Uy4/ew96RrLK+ixd1nqLcC72W
         3bo+gc6DJ/THqjfgUNtG246FsAFnxLx2gQHqbE5u1VDf534T/Bz2mPW9av3Vu5euqo
         rtXVMgzGAVIkfF67/5VWWnFZdgzGEKAZs9X4OiCMqo+JSyESYhZ0q2R+0kchrjLcBJ
         UP2+5BUKg2/ka8sYRNtD5VPou9A+gNdUjczv+HFoTJ8IygBihCE5LDjTnany8FEo1R
         xzGiFTvqhNpUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CEAFF7940C;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fsl/fman: Check for null pointer after calling devm_ioremap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147761017.14327.16760607882787615531.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 14:00:10 +0000
References: <20220106100410.2761573-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220106100410.2761573-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 18:04:10 +0800 you wrote:
> As the possible failure of the allocation, the devm_ioremap() may return
> NULL pointer.
> Take tgec_initialization() as an example.
> If allocation fails, the params->base_addr will be NULL pointer and will
> be assigned to tgec->regs in tgec_config().
> Then it will cause the dereference of NULL pointer in set_mac_address(),
> which is called by tgec_init().
> Therefore, it should be better to add the sanity check after the calling
> of the devm_ioremap().
> 
> [...]

Here is the summary with links:
  - fsl/fman: Check for null pointer after calling devm_ioremap
    https://git.kernel.org/netdev/net/c/d5a73ec96cc5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


