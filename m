Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EC54553D1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbhKREdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242970AbhKREdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:33:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B37961B39;
        Thu, 18 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637209809;
        bh=Q6aruKsAvqketa/YdneOPnOfNWgT2SjfECTiqEW6Cko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MQs1+VOXkO/6hu7fwF8kXY2C1Xesey1CSJEUFkKP34YsDXhQmgnp7cSAKMYXcooYs
         akDxc4Gn8Tcjx9U2WKH0jXohW91ALWwaDJbLbIaPIA16CElyK1Lf+40jQGhAqcMorZ
         SgRgUKTaggXMQ7Ma5thwVuF7nxp/peni0fzqYCp9YRq6XofdeIzABHkN9wO8LDmA4R
         xFHWVjTCY9VeHEmTcORyY0r1pzPik3spJY2TSTuLx2nVBi7TWgqeXoKv0AUA46QEqO
         sbf+GniAnZuYMvABp5MI1J9+koazKhLJOvqw1egcO+DnRBK5Yw1/1xKLYoMeXOcIgr
         2P4zCNsNcaWOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A47260BE3;
        Thu, 18 Nov 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: debugfs: don't corrupt user memory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163720980903.29413.8714907245021841032.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 04:30:09 +0000
References: <20211117073454.GD5237@kili>
In-Reply-To: <20211117073454.GD5237@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sgoutham@marvell.com, hkalra@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, davem@davemloft.net, kuba@kernel.org,
        bbudiredla@marvell.com, rsaladi2@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Nov 2021 10:34:54 +0300 you wrote:
> The user supplies the "count" value to say how big its read buffer is.
> The rvu_dbg_lmtst_map_table_display() function does not take the "count"
> into account but instead just copies the whole table, potentially
> corrupting the user's data.
> 
> Introduce the "ret" variable to store how many bytes we can copy.  Also
> I changed the type of "off" to size_t to make using min() simpler.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: debugfs: don't corrupt user memory
    https://git.kernel.org/netdev/net/c/a280ef90af01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


