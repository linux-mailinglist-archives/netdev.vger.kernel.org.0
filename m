Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19F62DC9F5
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgLQAar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgLQAar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608165006;
        bh=OFq05Y1pIErhuOZjJ9T4xiN+x204r6m039UaIcOXtgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YAZm29FOeWe5eDfUhEmKs+WlZ1G3ghbHqd25NAyX0b135rRTqvcLvHTVkDsXBkQhD
         IcswmOFQUcyVoKhfjJREsKWnyXOlWY1OUi9icHaR8UvUqEi3quL02WtsPST0LDOCgT
         Qe1QDKFGUn1Rn4kWdWxhCQx+AJ/Sy3ejgTw6hxUMBlEr6cWMWSgLFwuR0ePEYlkyWH
         ZbqPWKzn/R+X/LK9dqcSfWUJYRz7taEtuVefL6WSWaoPbTWHkUqMxwBUD24qnwH+WB
         z9ELnPsO8ntKtIotEBFOIg2PJaf8ofEBUScJMK2ww1AiGxKs714BNLZreiuME7xNJx
         FIGwX3awv5csQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: use _BITUL() macro instead of BIT() in the
 UAPI header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160816500674.31112.14101216512071221707.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Dec 2020 00:30:06 +0000
References: <20201215102531.16958-1-tklauser@distanz.ch>
In-Reply-To: <20201215102531.16958-1-tklauser@distanz.ch>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     jiri@nvidia.com, moshe@mellanox.com, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Dec 2020 11:25:31 +0100 you wrote:
> The BIT() macro is not available for the UAPI headers. Moreover, it can
> be defined differently in user space headers. Thus, replace its usage
> with the _BITUL() macro which is already used in other macro definitions
> in <linux/devlink.h>.
> 
> Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: use _BITUL() macro instead of BIT() in the UAPI header
    https://git.kernel.org/netdev/net/c/75f4d4544db9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


