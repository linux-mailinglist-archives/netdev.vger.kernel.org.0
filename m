Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E273E2BB9B5
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgKTXKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgKTXKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605913805;
        bh=dufixlyJBj0eSptPMFnuG9nA7355vaonyoI8Q3U4z9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iPL+yoFw48GtDwltRQ5aPXJMcb5BSzT1SdQKAKFGGO/Se6GJ6JDHvTf4+xOyCxmq3
         DOaCRMoZwwBctzlPkxKYKgPbCQmRINSPRaQyjYntWBLRhWtdHegmUJ7zxfMLNo+6wf
         GXh4QesCvRmt0Jc+ZH5n06U7JLKhVsFwHsP+xZ4s=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: avoid potential use-after-free error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160591380496.14060.1060350832010889995.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 23:10:04 +0000
References: <20201119110906.25558-1-ceggers@arri.de>
In-Reply-To: <20201119110906.25558-1-ceggers@arri.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Nov 2020 12:09:06 +0100 you wrote:
> If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
> immediately. Shouldn't store a pointer to freed memory.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes: 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")
> ---
> Changes since v1:
> - Fixed "Fixes:" tag (and configured my GIT)
> - Adjusted commit description
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: avoid potential use-after-free error
    https://git.kernel.org/netdev/net-next/c/30abc9cd9c6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


