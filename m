Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6520742EE44
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhJOKCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234903AbhJOKCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A1D0261216;
        Fri, 15 Oct 2021 10:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634292007;
        bh=uxTckg/PXhVC/sRLjqHJOSFxr7kH5uNpkLmHI6AChYA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ssyg9qTeRV56KNh6ytmaNFn1qwtUIH2dwiJqFPcio9G9/nq/jTNoTecrkKDY0Llpu
         6RcqfrVEqiMe9uI85PEgwzCq/gFlg0XvxSsAp/nGT4ZpvERhLn4t8pBjwvS6soPLZ9
         lsbUgDlh78j8ByM2oiQ4UQ/bgnPLe2TQSvrdO7USUntSVgG2IEATwIN/y1IrQdb9IW
         3Up7Knd+zMmefQDdIL1XNCJuudO8MvjVNrSYbuyX0WnOKJsoKEsMd3+0OJlFggpe4a
         PJuiZxljCCe+uqYpvjQCj3WWc0wAbR7O26AOAXBgBCXnAYpvKFPzmyf+HWwlelJZ6z
         te3gwzAmA8Xxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8EBA460A47;
        Fri, 15 Oct 2021 10:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for 32-bit
 arch with 64-bit DMA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429200757.18650.14587453476284432970.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:00:07 +0000
References: <20211013091920.1106-1-linyunsheng@huawei.com>
In-Reply-To: <20211013091920.1106-1-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        jhubbard@nvidia.com, yuzhao@google.com, mcroce@microsoft.com,
        fenghua.yu@intel.com, feng.tang@intel.com, jgg@ziepe.ca,
        aarcange@redhat.com, guro@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Oct 2021 17:19:20 +0800 you wrote:
> As the 32-bit arch with 64-bit DMA seems to rare those days,
> and page pool might carry a lot of code and complexity for
> systems that possibly.
> 
> So disable dma mapping support for such systems, if drivers
> really want to work on such systems, they have to implement
> their own DMA-mapping fallback tracking outside page_pool.
> 
> [...]

Here is the summary with links:
  - [net-next,v6] page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
    https://git.kernel.org/netdev/net-next/c/d00e60ee54b1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


