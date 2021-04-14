Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E635FC19
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353532AbhDNUAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245471AbhDNUAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE33C61154;
        Wed, 14 Apr 2021 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618430410;
        bh=EbCR73hTmasaxW7y6jUvE4FvFPo0Fm+mX5csPYP4qk8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EGr3JThFN6cNAfKMlY1ucQ2qNbZH4lF4AOoKsl7eUSIgcVjYByI4eY68Rgqs/VnUj
         fyPHbCc5pXdhokr/wyEwqT7DRjow8p96S3B2unqrFbspvTWXrFjyqPueTytU0GPPiX
         7diiCKrYX/zof0cczgFeqo1J5diVciMNsU6uC15SR1MXL9Ysd0FCjXR2F08jYd3jk+
         caOnxw6ob9ipxyZzbVOrYHX1dXWhtUSfuKz4MLIBWKGRRIsQi6Wzm1dDuZDHJtMAcO
         XIP27Xqe4G+aSSctj7iEH+7UyUR5JtbGBkGqcncB576D7XVe84KXmFI66FaqLeWpba
         wYuT34GFdBt+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF37B60CD1;
        Wed, 14 Apr 2021 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 1/1] net: stmmac: Add support for external trigger
 timestamping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843041077.5559.2620169684665757690.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:00:10 +0000
References: <20210414001617.3490-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210414001617.3490-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, richardcochran@gmail.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 08:16:17 +0800 you wrote:
> From: Tan Tee Min <tee.min.tan@intel.com>
> 
> The Synopsis MAC controller supports auxiliary snapshot feature that
> allows user to store a snapshot of the system time based on an external
> event.
> 
> This patch add supports to the above mentioned feature. Users will be
> able to triggered capturing the time snapshot from user-space using
> application such as testptp or any other applications that uses the
> PTP_EXTTS_REQUEST ioctl request.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/1] net: stmmac: Add support for external trigger timestamping
    https://git.kernel.org/netdev/net-next/c/f4da56529da6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


