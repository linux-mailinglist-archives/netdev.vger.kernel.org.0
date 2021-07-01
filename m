Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84203B97E9
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 23:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhGAVCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 17:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhGAVCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 17:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE20261403;
        Thu,  1 Jul 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625173204;
        bh=iKq5IdwhMKKjN6gJhINz3/cJgtsPyf/BBzHrv1Zodes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dim1foDxR/XUDpX4ATttxj2C+kx7qWmO9/LVBqnhbv3P+rJDDkOxj9FsVlMTSj0dV
         kxsg7Qzn10I5MDRYgUK6AsHPHyZDLNICW6hEPiaLxyJ6wBw6a9t622q9Tddd7+C6Lk
         QTUxni0egXbg1WHhN6eB8qTuCcJUaYw7tJQhlbDy2368UI/Ukv6GXf1ZRe1Y/8zzEa
         wowX8LJ2IOUIXbX3YUahrqcKkgt6s3C5xy/RNQaKi6oEOsCkN1YAdhZFlyIyCRYATe
         rsYSBwUgEStoOnIJPJPDFjo4blTJUPNJBHFFPqVIqtkx4QMy8pqMOtGGGe8EVh/Tgz
         dXYe8bppXnyyQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FC9860A6C;
        Thu,  1 Jul 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: stmmac: Terminate FPE workqueue in suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517320464.16051.10769030925280050704.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 21:00:04 +0000
References: <20210630095935.29097-1-mohammad.athari.ismail@intel.com>
In-Reply-To: <20210630095935.29097-1-mohammad.athari.ismail@intel.com>
To:     Ismail@ci.codeaurora.org,
        Mohammad Athari <mohammad.athari.ismail@intel.com>
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org, peppe.cavallaro@st.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        tee.min.tan@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Jun 2021 17:59:35 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> Add stmmac_fpe_stop_wq() in stmmac_suspend() to terminate FPE workqueue
> during suspend. So, in suspend mode, there will be no FPE workqueue
> available. Without this fix, new additional FPE workqueue will be created
> in every suspend->resume cycle.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: stmmac: Terminate FPE workqueue in suspend
    https://git.kernel.org/netdev/net/c/6b28a86d6c0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


