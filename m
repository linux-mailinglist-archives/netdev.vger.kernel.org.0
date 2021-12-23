Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABCE47E776
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349691AbhLWSKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:10:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46866 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244679AbhLWSKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40CBA61F41;
        Thu, 23 Dec 2021 18:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83803C36AE9;
        Thu, 23 Dec 2021 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640283010;
        bh=oyh+QBfNI/GMX9Lq6AawFnQWCAFkjjqO6uAUCAtczVA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vL58s+QGCC49AR9aFgbj996Q8JloiwBecYYNRV+G3ws3FU7kOjPe4SVrVLAGLv0PW
         n2YjXmNCpdXwaEyWFzTcMhhpc/r4FWNAczmmkyLj1x1qOg5VEuHgoHFmP6ztXDn7aK
         nQuhCDfIFD8hgXQ8i9s25METHzsd8nEbwX2Mgh3dim9sMM+UU3ZqKATBnM2kxNYn+G
         cq0Gmh0JnqemQwP4q03xdaxXc1WYnDrXjszIKFbHmnorSzNpUywM/YCEHaGfpl3J9M
         RgkPSNpu820hUQXpHutCPw2Tf9BFfPnpOPzBRqd6SCcCQIgx9QGUA9XiV10mZdNAx1
         IB8GsmybKTqHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CF4CEAC06B;
        Thu, 23 Dec 2021 18:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: fix ioctl old_deviceless bridge argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028301044.27483.17708005720486132473.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:10:10 +0000
References: <20211222191320.17662-1-repk@triplefau.lt>
In-Reply-To: <20211222191320.17662-1-repk@triplefau.lt>
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        arnd@arndb.de, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Dec 2021 20:13:20 +0100 you wrote:
> Commit 561d8352818f ("bridge: use ndo_siocdevprivate") changed the
> source and destination arguments of copy_{to,from}_user in bridge's
> old_deviceless() from args[1] to uarg breaking SIOC{G,S}IFBR ioctls.
> 
> Commit cbd7ad29a507 ("net: bridge: fix ioctl old_deviceless bridge
> argument") fixed only BRCTL_{ADD,DEL}_BRIDGES commands leaving
> BRCTL_GET_BRIDGES one untouched.
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: fix ioctl old_deviceless bridge argument
    https://git.kernel.org/netdev/net/c/d95a56207c07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


