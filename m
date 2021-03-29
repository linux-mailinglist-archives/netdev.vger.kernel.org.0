Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B299834DC58
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC2XUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhC2XUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2617661988;
        Mon, 29 Mar 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617060009;
        bh=OU8EWmaUuU5zgJFvFJ+LakPpa5rRIU5ZzWzu95Wh478=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cUucwolDlDna4CvDLM2FIcRYwN8oSAu5lI1bC0cJUdnBvvkKwMX9obkPMUDmk6fM4
         T6k/qCEdGW8usw3fdc3/TKX8oVI/RKEuXi0WwoLEUsFGoBaGP86w5XxNFYApLGh1Sn
         BwuQUg/KKwDJbcOT06i9ZnkpBoh6Tp5npZZ7LJBCTvDpvNCHQaoTZXzB2x3e+zUV/W
         3Qj51rawKJ8AipUXQqyT5E+PXlZIPABEx5gT5UXkpS3jJpRCPdpem6m1joCdXnsbsP
         49NQe+dTbIBXTzvhM1mlSNleUExX+39sJWBzr5/ALtjc+S6i3M7OjUGr+1bOi7TWNM
         LA96KjhOrC/Cw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1662D60A48;
        Mon, 29 Mar 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: avoid collecting SGE_QBASE regs during traffic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706000908.13591.7712831413298349429.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:20:09 +0000
References: <1616869148-6858-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1616869148-6858-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 27 Mar 2021 23:49:08 +0530 you wrote:
> Accessing SGE_QBASE_MAP[0-3] and SGE_QBASE_INDEX registers can lead
> to SGE missing doorbells under heavy traffic. So, only collect them
> when adapter is idle. Also update the regdump range to skip collecting
> these registers.
> 
> Fixes: 80a95a80d358 ("cxgb4: collect SGE PF/VF queue map")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: avoid collecting SGE_QBASE regs during traffic
    https://git.kernel.org/netdev/net/c/1bfb3dea965f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


