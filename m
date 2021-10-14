Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3CC42DB8F
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhJNOcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhJNOcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 491566109E;
        Thu, 14 Oct 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634221807;
        bh=CuDXvMeGbueKlKElsUWPNb/lh/8SNMe1pT6kc2khxm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QFMgOeQxA6GqyIhCTcCCQDoazre7XwfmH6vDhrBXtvydnZukOAfyOF3XCQoOCltI5
         QWUgkYVQPhb6EM2TnbECyCbu2i9+lX1WySPVUZkS6qjgBq4xcBv8QgS0+M/bArP6YN
         SfeH/zzisvhIsd418MMQijBCj7NUG1fql2oMKshfSdAZ55A2DkGXj4MMFVKe+5DOus
         qostJzT5dc4VXZwOeo9NxHEpu34wqsT6fhmztXZTMv/KCmLYVP18DvZAaG+x2x4AB5
         Mpn7LANASN8yD5iGwDM6B+r1vqeRb2aBX09FGoXVLEiFoCNc50O2zGtXghOLKLZJv7
         ADA/fpT0zwI9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3891260A44;
        Thu, 14 Oct 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: account stream padding length for reconf chunk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163422180722.1532.7555776041152823149.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 14:30:07 +0000
References: <b97c1f8b0c7ff79ac4ed206fc2c49d3612e0850c.1634156849.git.mleitner@redhat.com>
In-Reply-To: <b97c1f8b0c7ff79ac4ed206fc2c49d3612e0850c.1634156849.git.mleitner@redhat.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com,
        eiichi.tsukata@nutanix.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        lucien.xin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 17:27:29 -0300 you wrote:
> From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> 
> sctp_make_strreset_req() makes repeated calls to sctp_addto_chunk()
> which will automatically account for padding on each call. inreq and
> outreq are already 4 bytes aligned, but the payload is not and doing
> SCTP_PAD4(a + b) (which _sctp_make_chunk() did implicitly here) is
> different from SCTP_PAD4(a) + SCTP_PAD4(b) and not enough. It led to
> possible attempt to use more buffer than it was allocated and triggered
> a BUG_ON.
> 
> [...]

Here is the summary with links:
  - [net] sctp: account stream padding length for reconf chunk
    https://git.kernel.org/netdev/net/c/a2d859e3fc97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


