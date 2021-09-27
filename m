Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76F241939D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhI0Lvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234053AbhI0Lvq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:51:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 529B061002;
        Mon, 27 Sep 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632743408;
        bh=njs8XJ0U8BZYUkRH4x+0apm+KEiswMRRFICrWz4Pi2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=svW0o4YoBW//6GGcOTpAWJrynIJRcpQinAS5JnVPdHoag5Rjc8KI3WKIFUzqGNe0B
         OjD4tnAHbP8CGP9QdZcXweLqvO/Vhe85DqF0z9wPNR4YjPOSqTVFuLb8cRZOrkpZP6
         PMu0P0/2Ucv4X6UuE6LiHnE8sqGRk6eJWl9S/fRqaIEZ2pXinHsAhiE8Cq+VlEgbZw
         bE7irjQ//1qhL/FMnDXxqRRsKwMX/RzmVxoSUkBOhHSr10O55o9D4NNQfu8s/C4kWX
         eeklyXiOKibLe2gAQSgnvnwQhjV2jaFphE/uLt7OIc3s6w56wC7lSzYbh/seiwSQ6t
         c9XP5xoyBysDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4770D60A59;
        Mon, 27 Sep 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/ipv4/tcp_nv.c: remove superfluous header files from
 tcp_nv.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274340828.15641.16455712962364694367.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:50:08 +0000
References: <20210925142140.23166-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210925142140.23166-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 25 Sep 2021 22:21:40 +0800 you wrote:
> tcp_nv.c hasn't use any macro or function declared in mm.h. Thus, these files
> can be removed from tcp_nv.c safely without affecting the compilation
> of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next] net/ipv4/tcp_nv.c: remove superfluous header files from tcp_nv.c
    https://git.kernel.org/netdev/net-next/c/2b73e209ba75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


