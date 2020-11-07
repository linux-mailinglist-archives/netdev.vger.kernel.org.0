Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BF62AA20C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgKGBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgKGBkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 20:40:04 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604713204;
        bh=p/Ly8ykcdpwFjkgtFxIWKavOGzJ4smgguMtzXX9FEwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VPwAsrf4cmdEEBM4P70dgJW8Xi485XJ7KCOew5OZUBbSljYawQwUxuCoJA8Ciq5Eu
         tpb+KIKH4tp8BC2f8uL+TaSUgvyxqdaIzMX+pRHy6cNR47zoRf/vvgEn27LA5XHu6Y
         OyjbJrxecJnKlTXriztWmnTgQV9kvbs972Q8Zfw4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert ibmvnic merge do_change_param_reset into
 do_reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160471320435.9446.8395334114876368944.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 01:40:04 +0000
References: <20201106191745.1679846-1-drt@linux.ibm.com>
In-Reply-To: <20201106191745.1679846-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Nov 2020 14:17:45 -0500 you wrote:
> This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
> where it restructures do_reset. There are patches being tested that
> would require major rework if this is committed first.
> 
> We will resend this after the other patches have been applied.
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net-next] Revert ibmvnic merge do_change_param_reset into do_reset
    https://git.kernel.org/netdev/net-next/c/9f32c27eb4fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


