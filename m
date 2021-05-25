Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679CD390C8F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhEYXBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhEYXBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 52A1361429;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983611;
        bh=kwozPCqzNLh4amjjPHLoWKhqyASyp3HbDg6AukElS+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/Q196QLjSALg+3uxvK5yV/VIc/whq22mVBh8M1XHGd6/e4LiS/Zj7SKqhadpSCmb
         cD9J7rd8fNV+SUUZ6I2W4jog9vuvnCKmExdI125SfgTMgDTViPKPYAw9LMpFQ/Vd12
         PN440I22OY+sp1+CASu+DuPpoxRYMyo/FGlGn02ugNEnpfhTrjDoUPEcZpDvWmtIVO
         /WnVYeWJg26WFXE0EjVQSHz0wSB3GNKeX37Hxi3gHFcN2JFcJc6we+We/dxF7VMsQa
         xWEKcMTtqzV6F8gRFs13dj4T+fOogJ3gToJai4OvnQ0z5SH34+Cp1rNn2U+rfMO3Si
         VCd/HDakTpxNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 485E060A39;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: update maintainer and mailing list addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198361129.32227.17732659342695986274.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 23:00:11 +0000
References: <20210525154704.2363-1-simon.horman@corigine.com>
In-Reply-To: <20210525154704.2363-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 25 May 2021 17:47:04 +0200 you wrote:
> Some of Netronome's activities and people have moved over to Corigine,
> including NFP driver maintenance and myself.
> 
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] nfp: update maintainer and mailing list addresses
    https://git.kernel.org/netdev/net/c/bab09fe2f652

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


