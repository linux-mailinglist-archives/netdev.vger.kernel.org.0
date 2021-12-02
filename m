Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D909465C9B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355147AbhLBDXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347449AbhLBDXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:23:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1314DC061574;
        Wed,  1 Dec 2021 19:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2569B8220F;
        Thu,  2 Dec 2021 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B02BC00446;
        Thu,  2 Dec 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415209;
        bh=Lr5HbwEB2ORxHcaqqHIxXuMb91dKwPojMtAQyjvq+Zs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rqqf43enevrG6I6tvwqtya4XmWG74JAJEVw+KwmbnOQpsoq9+qBQdiZV8tu3Rhpou
         Fgrdvdt07qe1JvIDP/tyGb5bDwf0eUwvMQ+PETqeNW6Gbem277kTmeEbIpk6HqRx5h
         5Rdjg6+yrP3jwEYV+gYgLBnSXejM5u3Vgo2abVMaM9JyqG6YK5Dqd/G7FatHh/GnyF
         3q9HUhdcgw2ijRLkrd2AxK9AAlv1+xAnzxuTFDL5Wk36tO9eSUDQCHxl37ohoPONVw
         aDEDYERhez2CBCqGj/AHVtQPbfCow0VtPgWqcaB5AE1xPaOkEvXH72aPa3JnKdKEl4
         4UAEY1gDycWVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4049260A59;
        Thu,  2 Dec 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Fix a memleak bug in rvu_mbox_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841520925.978.14308206257765575112.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:20:09 +0000
References: <20211130165039.192426-1-zhou1615@umn.edu>
In-Reply-To: <20211130165039.192426-1-zhou1615@umn.edu>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Dec 2021 00:50:39 +0800 you wrote:
> In rvu_mbox_init(), mbox_regions is not freed or passed out
> under the switch-default region, which could lead to a memory leak.
> 
> Fix this bug by changing 'return err' to 'goto free_regions'.
> 
> This bug was found by a static analyzer. The analysis employs
> differential checking to identify inconsistent security operations
> (e.g., checks or kfrees) between two code paths and confirms that the
> inconsistent operations are not recovered in the current function or
> the callers, so they constitute bugs.
> 
> [...]

Here is the summary with links:
  - octeontx2-af: Fix a memleak bug in rvu_mbox_init()
    https://git.kernel.org/netdev/net/c/e07a097b4986

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


