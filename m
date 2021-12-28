Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204B1480958
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 14:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhL1NAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 08:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48074 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhL1NAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 08:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6CDB8118F;
        Tue, 28 Dec 2021 13:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EAF7C36AE7;
        Tue, 28 Dec 2021 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640696410;
        bh=RYGOKmOt23xtjk3+AODAGOSxKGx4+v1YRYDEa+44tqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uq2/RqyrWKahRt6zn/LKKNGb5cLP/Xc/+P5VRDhw0Y4ueEGCp0vqqI4yphMILD1aQ
         10hyZ/BVloyG+NIW+uOwiUT/Xi1aVDPoTJCbma0L88sfDt4fkpKcoXzHUBE+ZvKO9K
         tE+BRhOfl/Jc+qjViL5gUizknkNJQ2AsUqrCRc2CMT5/8vhyT9RxGyU1T0pHDYz9ud
         Gv8jaqCowO4mJjDB/a5bdDRsLoMFmTUvoor8ZgLmRL5c/m1pVNFuThFC0J2YWfSZAh
         yHrLiO+fPYm93YXu41Cj/yVNk2IQdP3EjturcMo6ILmp/672VsEIM27bPsLEqrq7Uw
         6rKF3tn7BMNcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39360C395E7;
        Tue, 28 Dec 2021 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: caif: remove redundant assignment to variable expectlen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164069641022.10997.2709686317721478445.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Dec 2021 13:00:10 +0000
References: <20211228004542.568277-1-colin.i.king@gmail.com>
In-Reply-To: <20211228004542.568277-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 00:45:42 +0000 you wrote:
> Variable expectlen is being assigned a value that is never read, the
> assignment occurs before a return statement. The assignment is
> redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/caif/cfserl.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: caif: remove redundant assignment to variable expectlen
    https://git.kernel.org/netdev/net-next/c/0f1eae8e565e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


