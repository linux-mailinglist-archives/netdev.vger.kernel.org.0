Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DFC364E74
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhDSXK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhDSXKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5ED84613B4;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618873815;
        bh=nCK+UhygxjpLsSYXPEoCl4p6juLzLrDH8oRB245hLTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y+uwcRGv3K4QgEoVcQNe1dp4cwp3O+t/KyPR4IEhFrqarBxhCIHwpO2Zfs0D29u7V
         BsTN+dJRsrIAluZ6V/gv0xJKRHFOGWFICA0xboOOVI0ldkKciayUespvd+zBurim9T
         b7AmGfB/iNiwIquisqjyZGeifqJMH0lNFy9pkxyii+SNvjP90SkzJIO0iZME/ZXY4L
         gB84eO9h/UhGoEirMSzcPxQM9OytrDRN3bGz7yoPeZWcqkiyqakTYpGuSutBsuCuMU
         pAFcQ3vRlkEzSrLDikJAFd6m1mgHKtduPUPMR6Io0IVFwwiPyEA+Ly3r8VEBGmAD3g
         O3Lhzx7Yfma+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 575EC60A2A;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: simplify nl_set_extack_cookie_u64(),
 nl_set_extack_cookie_u32()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887381535.661.5896247027226486725.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:10:15 +0000
References: <YHrInysXIB+SQC5C@localhost.localdomain>
In-Reply-To: <YHrInysXIB+SQC5C@localhost.localdomain>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        johannes.berg@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Apr 2021 14:38:07 +0300 you wrote:
> Taking address of a function argument directly works just fine.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  include/linux/netlink.h |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next] netlink: simplify nl_set_extack_cookie_u64(), nl_set_extack_cookie_u32()
    https://git.kernel.org/netdev/net-next/c/c6400e3fc3fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


