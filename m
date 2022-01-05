Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13A4484C7F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 03:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbiAECaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 21:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbiAECaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 21:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75315C061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 18:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C55B61637
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB3B4C36AF3;
        Wed,  5 Jan 2022 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641349809;
        bh=5r/f/P80oHf8tcjeTmEZODMFdrfqOlBhN7OUHxmy13c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XkQIPC48/k13bpPEYXKp1qWIFpburUG3IkB3vtCB89rBw6VX1lyfYpTGS9MPrTyU1
         dmHsifFrrZN2tJc9RbEO9NW1r5Sgop9nGE9pDJ/L1uRrXZi2F4lxW4PiSIaMxSIL9Z
         PDe0pH/2AmNls+6GjQB3cADcWuFrxcY6tSN8mkkaocxj0VTKs7ZznW1ocYgYQZQw0O
         ACpt92aZ2PmW3TtJclUZ0ACl/kVXTuXomt6hfO7EO2U8lUlJSZgCOsvKtBJVv34Uj8
         2NgzCNqKdGtCuUgr++6QoMIVfnWdvN/BGvay3MzHlE9QMVU+ZGg/By1uFJObbjM2i3
         zlFWxP2uZ1cwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A13BDF79408;
        Wed,  5 Jan 2022 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] sfc: The RX page_ring is optional
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164134980965.7326.1574281526826226311.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 02:30:09 +0000
References: <164111288276.5798.10330502993729113868.stgit@palantir17.mph.net>
In-Reply-To: <164111288276.5798.10330502993729113868.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, jiasheng@iscas.ac.cn, davem@davemloft.net,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 02 Jan 2022 08:41:22 +0000 you wrote:
> The RX page_ring is an optional feature that improves
> performance. When allocation fails the driver can still
> function, but possibly with a lower bandwidth.
> Guard against dereferencing a NULL page_ring.
> 
> Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> Reported-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] sfc: The RX page_ring is optional
    https://git.kernel.org/netdev/net/c/1d5a47424040

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


