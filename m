Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2B341337
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhCSCuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhCSCuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4EC7C64F1F;
        Fri, 19 Mar 2021 02:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616122208;
        bh=+TGPK/VmCC+u9/ldAmSR5h5cZU6a1MdO3opaZL9LO9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cT3LGbUv0KPy87LgPS42JkkixQfccwaqwvHw/lL4tcOJxmT3Qkk8BSuxfFFOrfl0V
         U4FugkhzwZlc6kx0uqFPrWBAiOsRLY/TuBcQ24IdPTa08UTxbF4+7tPuoSzGO+qPq/
         k8FNBqotgFoNKi501wmUmJwS73CQWz6+IZi0/y94mBYZ7sNV0EYKT1WqmutF3cej0t
         Od+VbPH5j+/hQxiD0z3CLqiPaJYobqHjFSch04GedxelwUsR85IhBmY1ULs/halHRv
         71fc/AruKeEZ/sG8wYGf5sHmo1HxpOUi330K8h2g4MF5H6S8GqJfhhgKOuoYrU57KD
         uGyTG6ZvW9+Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3DB86600E8;
        Fri, 19 Mar 2021 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: cdc-phonet: fix data-interface release on probe
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612220824.2508.14534357548933207125.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:50:08 +0000
References: <20210318155749.22597-1-johan@kernel.org>
In-Reply-To: <20210318155749.22597-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Mar 2021 16:57:49 +0100 you wrote:
> Set the disconnected flag before releasing the data interface in case
> netdev registration fails to avoid having the disconnect callback try to
> deregister the never registered netdev (and trigger a WARN_ON()).
> 
> Fixes: 87cf65601e17 ("USB host CDC Phonet network interface driver")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: cdc-phonet: fix data-interface release on probe failure
    https://git.kernel.org/netdev/net/c/c79a707072fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


