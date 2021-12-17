Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3B479366
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhLQSAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhLQSAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6B5C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9428FB82A0B
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48576C36AE8;
        Fri, 17 Dec 2021 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639764011;
        bh=DpsBJk4IqYmoXhOxMWRqFQEfZo/q3wqpTdsBCqyNBPQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GNRLinZLwEG03eWdUvElYDIIvqLe/sjXeUN2fIMTWRTn8KzJWFupRJslIDsiBsdM2
         gYh+7l30V5iJS5wlAsZshpUbopM2AM2dspHbUu+jYRRIfgRLeiYnFAZZbmaMCyhauS
         H2FB381qqFjqeIxmH8l7Ktu6lKhadwYBg97mO/OOpxYkVJevCwvU+K9Re3m6ngRyi+
         UTG4JyrWPI7vbmwC2XXGX/kpT0IV78LgXjjN/YXBLuzrEZ+N75dAWr0ufOVpbnylxP
         Z5hvBZTMnxB9gZO+ThviVlIlKtgPizyrzBrw0PH+7xBGzgONvMAl0pdbYFu7oDTDq/
         pVOslJssq7BsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 269C560A39;
        Fri, 17 Dec 2021 18:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next 0/3] ethtool: Add ability to control transceiver
 modules' power mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163976401115.28132.9718450677553853168.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 18:00:11 +0000
References: <20211207093359.69974-1-idosch@idosch.org>
In-Reply-To: <20211207093359.69974-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, vadimp@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (next)
by Michal Kubecek <mkubecek@suse.cz>:

On Tue,  7 Dec 2021 11:33:56 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 updates the UAPI headers.
> 
> Patch #2 adds the actual implementation that allows user space to
> control transceiver modules' power mode. See the commit message for
> example output.
> 
> [...]

Here is the summary with links:
  - [ethtool-next,1/3] Update UAPI header copies
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=005908bc02e6
  - [ethtool-next,2/3] ethtool: Add ability to control transceiver modules' power mode
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=2d4c5b7bb38b
  - [ethtool-next,3/3] ethtool: Add transceiver module extended state
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=1f357867e4ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


