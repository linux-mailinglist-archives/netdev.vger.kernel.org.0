Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC36333CA2A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 00:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhCOXvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 19:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhCOXuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 19:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BBD3164F5C;
        Mon, 15 Mar 2021 23:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615852231;
        bh=vp7XiEDqDEXUDW1xX9IJVyBJfyJVYig8KBsoeXbuTdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Edm9u0OhJyl95MluC48LAh64V3HqBDQFRdO6/K6xTKi6sV6w7XQLNoKJSsrh5oTvP
         uT2O0/BKS0+e+oth0lxj1ahgmQPqkcMPwYYS3dbzsRmH+TcwEzN22tmi7206QSx9hi
         wc5XFBd+THmtWMlYqVGMx6xIOvFh96kZEJLs/063i3YQjAjO7z76WgCYHgONRyYsXy
         sUtpett9OePVlugCjCKy62fZ+NFAaaJDtmVwrzmgzfDxRGWDXak5jIfRyhyLL4ue2v
         FPSEmbxO0xxoXyWCUbDEbzsnJdQFKEIUv6oMJ8m4+uUnJ6xm+BUCMlbAOUO2NlNB3U
         1Fi87am5EKzmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B079260A1A;
        Mon, 15 Mar 2021 23:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: fix ADD_ADDR HMAC in case port is specified
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161585223171.25411.8764813652066279395.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 23:50:31 +0000
References: <5e8d22caae531185d0ec7407508250d9351f029a.1615798075.git.dcaratti@redhat.com>
In-Reply-To: <5e8d22caae531185d0ec7407508250d9351f029a.1615798075.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 15 Mar 2021 11:41:16 +0100 you wrote:
> Currently, Linux computes the HMAC contained in ADD_ADDR sub-option using
> the Address Id and the IP Address, and hardcodes a destination port equal
> to zero. This is not ok for ADD_ADDR with port: ensure to account for the
> endpoint port when computing the HMAC, in compliance with RFC8684 §3.4.1.
> 
> Fixes: 22fb85ffaefb ("mptcp: add port support for ADD_ADDR suboption writing")
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Acked-by: Geliang Tang <geliangtang@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] mptcp: fix ADD_ADDR HMAC in case port is specified
    https://git.kernel.org/netdev/net/c/13832ae27553

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


