Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0A939C2ED
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhFDVvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFDVvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B806C61412;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622843404;
        bh=bL7CDhJkd0VyD1InB/Wz/J0nUIfcG7oc1U3oTZQE9/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ny0PY9O8gUwRK7e2zm/5Vuv059KAT2tE49yzBFzN/AaYcsMgW6vW5kmgWg7WyQUNF
         +G0wienuhlTjqTlxu6HUGjeLQDo4Y/TB1RoNgmCTDJ6SHMw9T4kvNvZDYRC1otDD+z
         1XHN4EjxFqEMtchqVo8d9odaT44RnCah+B2y41eaDxRh1C/QghJAABUiuxzLhXXrRv
         e9oLnus4Orpx5Qu0q94so0CoryPwTswZt0mH6nFsPRt0uDxvgxvy3gt7trtFU+OIUl
         jafZzs+IZBX6a0/tVGqPnY5/XNvsDE+n2VWriZ2o7TKrd029S3QJE4/3GAfM2Moizu
         6EOiRkqPnJ8Qg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AFC1B60A13;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:cxgb3: fix incorrect work cancellation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284340471.5449.5473583103045750445.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:50:04 +0000
References: <20210604113633.21183-1-ihuguet@redhat.com>
In-Reply-To: <20210604113633.21183-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdanton@sina.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Jun 2021 13:36:33 +0200 you wrote:
> In my last changes in commit 5e0b8928927f I introduced a copy-paste bug,
> leading to cancel twice qresume_task work for OFLD queue, and never the
> one for CTRL queue. This patch cancels correctly both works.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/sge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net:cxgb3: fix incorrect work cancellation
    https://git.kernel.org/netdev/net-next/c/d5a73dcf0901

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


