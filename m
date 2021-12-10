Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E5D4709E4
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbhLJTNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:13:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58300 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbhLJTNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:13:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12C64CE2D10;
        Fri, 10 Dec 2021 19:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F1F1C341C7;
        Fri, 10 Dec 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163409;
        bh=onkZt4WSnmivAmB5shwxiD1wBJliWxV3mAJnF9YpnIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ptGQiYwLMs4ZFccaCXxpK46msXPCmcvx/eESqL5lUX/pU19SNzhPfnC/3bDYA+Zf8
         VszEL1MBGI+VU6If9Nz6Ds0pI5Xb2Y5IAGcqaotlfRYvSYuzgteGQiEehlDy1RMAhL
         3I6bn+oKTKfa9amI2ai14oHFpO7qg8k9IqJZG+1J1o9m0LSuJStLFcMhSUrmSOe7gQ
         tt4m0L6sUkNee1GV/zRsubN4DAHpzCicR0bWTX3YswZi6AdGKst1SZajwEke0tpCbz
         nIR3A0LnyMGqXvHZEgL66Fsu32eqWErDS9gQcziOQGD8PNRau/YEmP3eZwyVHhLR5j
         ENmBsifNNl22g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 204B9609EB;
        Fri, 10 Dec 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: mptcp: remove duplicate include in mptcp_inq.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163916340912.5890.11767270768201667330.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 19:10:09 +0000
References: <20211210071424.425773-1-ye.guojin@zte.com.cn>
In-Reply-To: <20211210071424.425773-1-ye.guojin@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye.guojin@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Dec 2021 07:14:24 +0000 you wrote:
> From: Ye Guojin <ye.guojin@zte.com.cn>
> 
> 'sys/ioctl.h' included in 'mptcp_inq.c' is duplicated.
> 
> Reported-by: ZealRobot <zealci@zte.com.cn>
> Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - selftests: mptcp: remove duplicate include in mptcp_inq.c
    https://git.kernel.org/netdev/net-next/c/db1041544815

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


