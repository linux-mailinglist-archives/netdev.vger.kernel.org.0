Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606CA2C3550
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKYAUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgKYAUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:20:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606263606;
        bh=OI/xZKY14I5vrcyoDaohCh5oELwYlWdyUoby/I5nvzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+m3S1b7QcO7262Y7zkAUCMVsz+b6vbQFOAgQ7EwjoQxS08s3z/hd3kDsV2SVF+5a
         kS9mVXTPC5c8pCMikpJLrY0Z5p9ElCov750nzgB2/lMAWzybda8jrZZ16TfsvPUwnv
         X91TejYjT7RgXyAczxIr7fyTWPxxD3fDufN3+W1g=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net 0/3] Fixes for ENA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160626360618.17224.5751692742055805114.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Nov 2020 00:20:06 +0000
References: <20201123190859.21298-1-shayagr@amazon.com>
In-Reply-To: <20201123190859.21298-1-shayagr@amazon.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, sameehj@amazon.com,
        ndagan@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Nov 2020 21:08:56 +0200 you wrote:
> Hi all,
> This series fixes some issues in the ENA driver:
> 
> - fix wrong data offset on machines that support rx offset
> - work-around Intel iommu issue
> - fix out of bound access when request id is wrong
> 
> [...]

Here is the summary with links:
  - [V3,net,1/3] net: ena: handle bad request id in ena_netdev
    https://git.kernel.org/netdev/net/c/5b7022cf1dc0
  - [V3,net,2/3] net: ena: set initial DMA width to avoid intel iommu issue
    https://git.kernel.org/netdev/net/c/09323b3bca95
  - [V3,net,3/3] net: ena: fix packet's addresses for rx_offset feature
    https://git.kernel.org/netdev/net/c/1396d3148bd2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


