Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE69414ACE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhIVNlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232760AbhIVNlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4DCC6120E;
        Wed, 22 Sep 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632318007;
        bh=IlrBihCEbHcD0oKpG1Kq3cOeBZ3kR1NGR5qjp5maloU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kQDKcOEgBiiIpdIEYekyt+JzjdH40PI10+869i+XQAjBvMPAik92mrrKbYbMoKL2P
         h5aWpHYZON+Z/tjunRyuScq3cv2gIh+9kd/HL8l8Gw1bY+nY1dtJF2r6SU4z3g2hGZ
         IVPmqlJSjCoHFNx+Jraf4/TYETwFjg4j1doVwCwSC3X5xfG4SVA3FsKD03MyfxxzHi
         edDNiaaKfZHjkIj1pPg5jmcaiaZ11rfNVw0MK5ESNyA2Z4waBXcRo43KLqIV8hKNWf
         0481r+ch8tMP/Oe2bhPd6Z3JuwLtdsCKUm3Wx2hvVesR3IUr5i2mAH4YEr7Dwwrn01
         AvqzhiIB6Bpzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C965560A9D;
        Wed, 22 Sep 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: fw flashing and cd improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163231800782.24457.13618473237641577779.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 13:40:07 +0000
References: <20210921164736.5047-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210921164736.5047-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 21 Sep 2021 22:17:36 +0530 you wrote:
> 1> Function comments moved to .c file.
> 2> Use literals in return to improve readability.
> 3> Do error handling check instead of success check.
> 4> Redundant ret assignment removed.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: iosm: fw flashing and cd improvements
    https://git.kernel.org/netdev/net-next/c/8bea96efa7c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


