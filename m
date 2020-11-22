Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079D02BC2D2
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 01:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgKVAKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 19:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgKVAKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 19:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606003805;
        bh=BqriVPf7ZGrQcmkNlNIYizs65iGUGQZPPbawxUj2GZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iC6JKmBjDVewTzkqOhz5W8LBA0V3LGuQSbSkT+b4SnctyZZpixr7ze4CH/TQbeyzy
         vGKqOJw3HJ1adsQf7y4PP7BVo+adFSkLIdn40s1j+r2tMEx6nqrcEvo76GGHK5sTne
         IpLTJgFBJ7/D4qh6CTsum7KULWhARRlpwtEPdl3U=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Add support for RSS hashing based on Transport
 protocol field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160600380500.25306.17368295839417219301.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Nov 2020 00:10:05 +0000
References: <20201120093906.2873616-1-george.cherian@marvell.com>
In-Reply-To: <20201120093906.2873616-1-george.cherian@marvell.com>
To:     George Cherian <george.cherian@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Nov 2020 15:09:06 +0530 you wrote:
> Add support to choose RSS flow key algorithm with IPv4 transport protocol
> field included in hashing input data. This will be enabled by default.
> There-by enabling 3/5 tuple hash
> 
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: George Cherian <george.cherian@marvell.com>
> 
> [...]

Here is the summary with links:
  - octeontx2-af: Add support for RSS hashing based on Transport protocol field
    https://git.kernel.org/netdev/net-next/c/f9e425e99b07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


