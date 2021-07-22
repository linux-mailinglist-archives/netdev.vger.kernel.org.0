Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8670D3D2403
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhGVMTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhGVMT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 08:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D3A006135F;
        Thu, 22 Jul 2021 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626958804;
        bh=4VtBnqKRdYNbo2MnjHR6DBranXmNCDqvGSDM8rMSQJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bX3qeUjnm8gQMeJrHhUyEo2eWc/1EMXEncVurWfh3Ph/qnq6c+pZCD7VT9xMPgeCm
         uMqnF/B7oGv/Y1+tl/7ORcOuHFklSerAWQTGobyZTJj6yH97uVk+Ui6WxLaFzD4YMg
         gcrcIf1m1K7KmO7rVFIQxetpZKL7KqcHx/D+0jwtsQlHwmR2PBQE+JFRZZPhnv9qrW
         1InGlu9UUHVjipWViLL7o44s4IQ8wTGzV/b4YHRWo0e2Xs2OehQbYo73ecp20ACWuN
         Nh/vxDk2XSRhYFa1LdrXmAIGQdKn7YNNOMzUaMiLPYSRgYLOAMfUvsaArBtAwtVtlv
         /cuAYfDwvs1Eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB72060C29;
        Thu, 22 Jul 2021 13:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-switch: seed the buffer pool after allocating the
 swp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162695880476.18345.12662568662389824316.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 13:00:04 +0000
References: <20210722121551.668034-1-ciorneiioana@gmail.com>
In-Reply-To: <20210722121551.668034-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 15:15:51 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Any interraction with the buffer pool (seeding a buffer, acquire one) is
> made through a software portal (SWP, a DPIO object).
> There are circumstances where the dpaa2-switch driver probes on a DPSW
> before any DPIO devices have been probed. In this case, seeding of the
> buffer pool will lead to a panic since no SWPs are initialized.
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-switch: seed the buffer pool after allocating the swp
    https://git.kernel.org/netdev/net/c/7aaa0f311e2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


