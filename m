Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF817319859
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBLCas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhBLCar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 242F664E6B;
        Fri, 12 Feb 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613097007;
        bh=kz3JKWjA3DLs7nlXGGGZ/4PRr/vkjd54caJ0F04SEs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CuwKrK3h3syteo6Cs98oGnJd9SUaMqWujJt6fQlg7DhFVaIG/tMujqm+HWt8JOC0x
         nbZ691yiTDFVZJ6f8moOk1YffnVFALo8jMUPj/hZxFXCZRoP+UsLpAjU+u/uOVzgxJ
         hCrfHdjocqtwuHnuvmQeCaqlIG/7UOJSPytOWxoDOy+CzP6j0IwsYIKLGLxs82DIRB
         PSQGkQb9j3tne4QYwigl7T8jZX+d1pnvJLQI8gzSnTohRVZR1OOboWDSMgmAy1WJSh
         o+x7ksE2VCPM/K3xNTtbfQztserMNMIBgs8QQlV2KyVKHA94sO8jQYeyV97rayyBJm
         E/77K2uWxLq/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D31360951;
        Fri, 12 Feb 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-eth: fix memory leak in XDP_REDIRECT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309700705.16682.17871405610768591928.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:30:07 +0000
References: <20210211195122.213065-1-ciorneiioana@gmail.com>
In-Reply-To: <20210211195122.213065-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 21:51:22 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> If xdp_do_redirect() fails, the calling driver should handle recycling
> or freeing of the page associated with the frame. The dpaa2-eth driver
> didn't do either of them and just incremented a counter.
> Fix this by trying to DMA map back the page and recycle it or, if the
> mapping fails, just free it.
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-eth: fix memory leak in XDP_REDIRECT
    https://git.kernel.org/netdev/net/c/e12be9139cca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


