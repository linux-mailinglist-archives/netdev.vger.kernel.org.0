Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF83B7825
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhF2TCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhF2TCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 15:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F25461DE5;
        Tue, 29 Jun 2021 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624993204;
        bh=kHIQ9n74ASJOye2s0tXY0e89z9X+QDhc+t9+xuDVMYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PYqxjTRmpub1yOWt3YEJgwUwufKmChO83fzQ+JfnD/Paj4CVlo+nfeJtx73X2/cbg
         uNQcCzfrTeO8arOie3qvUFlzeFbpsM/6IC56YC5Dr1Qj/E0W/UrP6ktHnUlg4zHJEH
         a2fZ5WohCRt9OYdq7vpdJ3mEA0QliDvaiyHeHDWS4RpklRSnfWfY0wGLPKpB2PAoY2
         B0Hc+c6Y3aQrnnaK5N/Qwh4XaEGZWPpRxkwmLwXQ6cDUBPBIQU7p/+WtyJkV84BROD
         flHiCAhov0CvGlrhzq87Et3Lepk+e9dOhWihUPdhAeTs3GvFNWV6939iLE96jF+DCQ
         TIahV+krbfvQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 22AB260BCF;
        Tue, 29 Jun 2021 19:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: DQO: Fix off by one in gve_rx_dqo()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499320413.1879.5822204313483043178.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 19:00:04 +0000
References: <YNrY6WwCYGoWMZZe@mwanda>
In-Reply-To: <YNrY6WwCYGoWMZZe@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     csully@google.com, bcf@google.com, sagis@google.com,
        jonolson@google.com, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 29 Jun 2021 11:25:13 +0300 you wrote:
> The rx->dqo.buf_states[] array is allocated in gve_rx_alloc_ring_dqo()
> and it has rx->dqo.num_buf_states so this > needs to >= to prevent an
> out of bounds access.
> 
> Fixes: 9b8dd5e5ea48 ("gve: DQO: Add RX path")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next] gve: DQO: Fix off by one in gve_rx_dqo()
    https://git.kernel.org/netdev/net-next/c/ecd89c02da85

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


