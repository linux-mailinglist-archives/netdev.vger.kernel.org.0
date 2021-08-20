Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267B23F2D69
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbhHTNuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhHTNun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA1AC610CC;
        Fri, 20 Aug 2021 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629467405;
        bh=VXIlAOLUdDwIKvLlDCKAKZ+eNokx5cWoRnjeefOU1GI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M/aEImMzLvQ3Eeq4XvApubmrofXtmGhyM+Thiv1fSMKviv0fnpYQHw6wfrzlPF6+8
         r0tsJzqtd07znDnS8qFsYKX6e2NhERA4ZFIy1qaHBzlVSQr1qPg8YgG7C3OqmJyEi5
         TSEqU12DDsilqFsAMt0Gp87kEil8924Kt5f6O0aIDAx9HKqOryaYAXVT6bG1Q+7x9F
         K1RhJb5Rs4ghmNfLpoh1blCxHCaqUP5/FvaWyRXzg+8HigsKeWQGOKlhj65gQzEacJ
         F2GLlhSvf7xyGaSIJRMXQNerICbY3EmFhM6xm3OxTQEKruSmweL0lfUnl6KiAXECFI
         4KzjPaMuQrdQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CED960A6B;
        Fri, 20 Aug 2021 13:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946740563.29437.12714663640342835592.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 13:50:05 +0000
References: <20210819195034.632132-1-butterflyhuangxx@gmail.com>
In-Reply-To: <20210819195034.632132-1-butterflyhuangxx@gmail.com>
To:     butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 20 Aug 2021 03:50:34 +0800 you wrote:
> This check was incomplete, did not consider size is 0:
> 
> 	if (len != ALIGN(size, 4) + hdrlen)
>                     goto err;
> 
> if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
> will be 0, In case of len == hdrlen and size == 0
> in header this check won't fail and
> 
> [...]

Here is the summary with links:
  - [RESEND] net: qrtr: fix another OOB Read in qrtr_endpoint_post
    https://git.kernel.org/netdev/net/c/7e78c597c3eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


