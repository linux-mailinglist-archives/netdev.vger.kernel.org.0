Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3733D458700
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhKUXXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 18:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhKUXXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 18:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DC58160E0C;
        Sun, 21 Nov 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637536810;
        bh=HvlED21rF/94X92yB3x2JdGNOlJEMeJet6brMLXhxFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HI7kK5LDEo//IBM9ogVJgat1DpU8MpQBRA9UJwqCfVbLKrRCzPkBdVxEHsJ0VGdyB
         +gnmsd2r8IDf7Ej+hjjB6Sao267hoXrtwkW9RW6h4OJsppWLW/OOgjaNuZYQ20fsZM
         LHKU9KP+YRVJ3Vby1C9BS1L7/KXrFI9QY+7hO09KrGW0B6egZi+GgKoDovxUYVGEqd
         HMgBPkgAv2deJHZM60LLXrGhrQ/Ds+h9nGBwaRCgyv1YNv1KLn2Elwr12gzITvlXZ3
         sFpBwOgad5c3kW4TJ76RXSNHEGSA8v/ngr0NXRH21EEosNhZird16fPx9iEXhSCgse
         ZCW/DwMNXulVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0F9760A9C;
        Sun, 21 Nov 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [ethtool PATCH] ethtool: Set mask correctly for dumping advertised
 FEC modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163753681085.19466.6471229058651090397.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Nov 2021 23:20:10 +0000
References: <163701677432.25599.14085739652121434612.stgit@localhost.localdomain>
In-Reply-To: <163701677432.25599.14085739652121434612.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon, 15 Nov 2021 14:52:54 -0800 you wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Set the "mask" value to false when dumping the advertised FEC modes.
> The advertised values are stored in the value field, while the supported
> values are what is stored in the mask.
> 
> Without this change the supported value is displayed for both the supported
> and advertised modes resulting in the advertised value being ignored.
> 
> [...]

Here is the summary with links:
  - [ethtool] ethtool: Set mask correctly for dumping advertised FEC modes
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=50fdaec68feb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


