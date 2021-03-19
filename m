Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006F93424EC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhCSSka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhCSSkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 14:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8212E61979;
        Fri, 19 Mar 2021 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616179208;
        bh=FCFtKzSy4WE9/oWM8OkfleHF3CgzyU1+lpU3EnodHh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tm/UbnWztSg2PsQoAVrc/mvhHYaniLop6QqyGhocmqZW5mC1bOyVJwWHs9hJPrbSN
         WUdWKFcpCvhbLtGXRJoAlo3EPOKtBDH0QzMnF48Xs+LAbTa4TzCya5cO0VvISnKxNS
         C3DGUK/gPxSgB/Yo0ydPgIiZALtYG/cqNIQcOH8sqTp00qcPc/MuPu7Tkci4RzvJsZ
         I2FX50tsNno+bRUEqBc6QSDYDUYRq3AX4Wjxw69SwhZr/DEMvC4eEPjRqORrbyP9xM
         uiPabgThsCgkiDuZ10lo4mETs30KYyi5EVwPjuuEJOCTdxFOdWfo8ex3MBRQWbDAFS
         t2o3xk4dNLhSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 707B4626EC;
        Fri, 19 Mar 2021 18:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sctp: move sk_route_caps check and set into
 sctp_outq_flush_transports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161617920845.19713.2031294670026043152.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 18:40:08 +0000
References: <9db6df3e544dd6ec6e4ec5091b0a750ac08d6e1b.1616125961.git.lucien.xin@gmail.com>
In-Reply-To: <9db6df3e544dd6ec6e4ec5091b0a750ac08d6e1b.1616125961.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Mar 2021 11:52:41 +0800 you wrote:
> The sk's sk_route_caps is set in sctp_packet_config, and later it
> only needs to change when traversing the transport_list in a loop,
> as the dst might be changed in the tx path.
> 
> So move sk_route_caps check and set into sctp_outq_flush_transports
> from sctp_packet_transmit. This also fixes a dst leak reported by
> Chen Yi:
> 
> [...]

Here is the summary with links:
  - sctp: move sk_route_caps check and set into sctp_outq_flush_transports
    https://git.kernel.org/netdev/net/c/8ff0b1f08ea7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


