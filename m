Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294292CCC65
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387842AbgLCCUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387467AbgLCCUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606962006;
        bh=WfvFgY7WyJmcEeGRAFv4PiV/E7Zm4V2tDWt6oRCbSVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NzRFNNaQXgVMRBSuw16C6t+1+Ix6D0oPkWhWqx7lZgW/GIN26iYJxhgycXqvC1rye
         hpQBCa8vlhdoSDW4icx4lzqwHWIFFowYRCKheQWVSDN6emCfPvhseMSTvMQriXiSTs
         UxgHkP2eoX0++j2ZEjxw+FCAbmEx7/bOhxHDkk+lAVn+zdBFCib78dW3MjBlfk4CE6
         6Lbh6yrZ3t/AZ+QYD9msWkkp0a40VuSumqczT9UL26pu4+Jqq+rJ24n3EfUl0fLqnR
         hb++jSucwAUIRlyceIORP09W5RWUTDj7D5laSeHvYZ4svKP5xOoylh3JjwNa1Nd4iw
         eHb5d23g9Pv4g==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb3: fix error return code in t3_sge_alloc_qset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160696200679.5625.4336218337723477968.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 02:20:06 +0000
References: <1606902965-1646-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1606902965-1646-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        divy@chelsio.com, jgarzik@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 2 Dec 2020 17:56:05 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: b1fb1f280d09 ("cxgb3 - Fix dma mapping error path")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb3: fix error return code in t3_sge_alloc_qset()
    https://git.kernel.org/netdev/net/c/ff9924897f8b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


