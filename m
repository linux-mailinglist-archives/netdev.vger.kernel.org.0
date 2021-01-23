Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9698830122E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbhAWCLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbhAWCKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C498923B55;
        Sat, 23 Jan 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611367809;
        bh=2aD470TM83c9yY/LfplFDBIrMPUD4sqOscIr5Y62LOg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FQEGCkwWlqlg7zT+1Nq0dU3hB+kysqgCeNJ8JnfMYMvSv3zlTroesvOP0MD0F18ND
         pTVeSsHrA/qpDyOehli6nHVk69EAmt/RvpYOk2yQxyJHADdLefUiVNR1b++NC8/JLC
         fXRgpYvrXrEVPnk9qxcexp6qcvdRz/dEoeBKAb/OcC2+qh2xIVTtVZ9Z3CkfY8psCR
         BNbH19tyYi7REwPbMAog8am1VTO/jv3XFy1ue4N6zUeT1BnVr5VlQplVxrXph2bB6O
         /42jhNVdb0w+Cw0WJG8VZBj/vCpHBDQAzXooOrtxIDNuwQScKx08zWjVuUNOqHvvFD
         AbS4jecruxVFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8C02652DC;
        Sat, 23 Jan 2021 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161136780975.1188.11104581924603440019.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 02:10:09 +0000
References: <20210121070906.25380-1-haokexin@gmail.com>
In-Reply-To: <20210121070906.25380-1-haokexin@gmail.com>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sbhatta@marvell.com, sgoutham@marvell.com, gakula@marvell.com,
        hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 15:09:06 +0800 you wrote:
> The octeontx2 hardware needs the buffer to be 128 byte aligned.
> But in the current implementation of napi_alloc_frag(), it can't
> guarantee the return address is 128 byte aligned even the request size
> is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
> 
> Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers")
> Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: octeontx2: Make sure the buffer is 128 byte aligned
    https://git.kernel.org/netdev/net/c/db2805150a0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


