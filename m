Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E7410B48
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhISLbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhISLbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:31:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98D7F611F0;
        Sun, 19 Sep 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632051006;
        bh=MlXpQUWLkNfs41pyUoRnk+tFkqoxCIDDWLqIFCksVOI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L5YAlNchkYqzijioYxXrlMGAqW3jET+M6korpU4gw6kUXYg2nXriP2L97aysWYNl8
         9w80RtugCyCNQ1mRIzh3rC0hCNN9Ul6Fy4B4u0/OLp4b12E99k1PiTxCLvRs46XIXV
         CdfiMhygNY+yh5kOkP/mPqk5TCv78Fq8cmaMbWOT6ioC7dHBWebqAUgrbFB7wCfZ7Y
         lNoNbR2Q5DhuLEZR3jH8jRucjYny3IXK4ESJ6DUA2hCnKCyJ1ESugR/UdwEmbpvzRA
         gsGsLxXYWHwRSz+xBSWs8Kv00M195BK5uaCDxHGjWwEhn1nh/RMTT1iG14G5/TNN+J
         8+K6/dtj25ixw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C21D60A37;
        Sun, 19 Sep 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] igc: fix build errors for PTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205100656.18169.172670291108556041.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:30:06 +0000
References: <20210917210547.12578-1-rdunlap@infradead.org>
In-Reply-To: <20210917210547.12578-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, ederson.desouza@intel.com,
        anthony.l.nguyen@intel.com, vinicius.gomes@intel.com,
        jeffrey.t.kirsher@intel.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 14:05:47 -0700 you wrote:
> When IGC=y and PTP_1588_CLOCK=m, the ptp_*() interface family is
> not available to the igc driver. Make this driver depend on
> PTP_1588_CLOCK_OPTIONAL so that it will build without errors.
> 
> Various igc commits have used ptp_*() functions without checking
> that PTP_1588_CLOCK is enabled. Fix all of these here.
> 
> [...]

Here is the summary with links:
  - [-net] igc: fix build errors for PTP
    https://git.kernel.org/netdev/net/c/87758511075e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


