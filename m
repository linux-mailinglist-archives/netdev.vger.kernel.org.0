Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209EF3412BD
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhCSCUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhCSCUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41D4264F1B;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=ZqSvhPp1B2l9AziKMr7pvU3nP1NT+v/dJD6fK5r/WTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t7CHjk5tftMUP3MM6BFiBuBlDfFKvc12ChUGFSsE8SS4haCtnyeAy75S2dXdmsvvc
         Vn28tOOp3e4UPXs3J/9wJzghMyzEC+GL8VzfX7rxcDtIL68YALGd+NERatYBpOOuTu
         z7wKIgXvXbyHOM1uyM9+WvHuYGPfCmZlC5Q1iPFYc14vfjko7A36x68M4hFwaqM8f4
         LuxATvPvaqLmh44kpD112wehFNt0OCRB5uXwfc87EpHJvHRtcvyB826sI0SW2lBRxB
         ilr5Aw6F26ZQ1ayFF0cUtwroL0Z+yKZmna+lT3NqEE4QQjeZt9THKU4NkJ9cjF7Adu
         5eBe+P+Y7rDqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30B2C60997;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lapbether: Close the LAPB device before its
 underlying Ethernet device closes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041219.22955.6908099617636460546.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318190747.25705-1-xie.he.0141@gmail.com>
In-Reply-To: <20210318190747.25705-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 12:07:47 -0700 you wrote:
> When a virtual LAPB device's underlying Ethernet device closes, the LAPB
> device is also closed.
> 
> However, currently the LAPB device is closed after the Ethernet device
> closes. It would be better to close it before the Ethernet device closes.
> This would allow the LAPB device to transmit a last frame to notify the
> other side that it is disconnecting.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lapbether: Close the LAPB device before its underlying Ethernet device closes
    https://git.kernel.org/netdev/net-next/c/536e1004d273

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


