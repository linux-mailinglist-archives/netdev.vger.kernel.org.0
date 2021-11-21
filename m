Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECEC458701
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhKUXXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 18:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231705AbhKUXXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 18:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D537260E54;
        Sun, 21 Nov 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637536810;
        bh=K6Yln8tBKF9GMwSpw4cRwOyx00X+nAj3Z91xtgC4t1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RmbyJqEkA31+2m+1RYKVILOYa+PSL+H6N/OhO4H+i2jqc2syW9HnA4bbQyxbxTgBY
         XxhmtXNXSzXQ2Ds6sAXp9W9iqtByMJv0DYOkQycm8ZU8rOdpT+iGFH1Ev4+i0Mil7c
         BqEoh0Br28wVdmtmEYx1r9goa5+BkKWtzXNLf2Lzk/vixgYod7yypxayHsr7V98BSY
         zsfx5EVnEgfyTd6rTLPPTqIu4kEnY5Socd4ANmrVipzC5OISdabkobha22V76Kl75d
         MB4nsUV6zOc2hJRCfyP1v9b5AXPBOsP3hIQLkog3sYAlIjzHs809M2iF3J8bQjj2k7
         1xsj/8x2JMk/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6124609B4;
        Sun, 21 Nov 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next 00/14] ethtool: Use memory maps for EEPROM
 parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163753681080.19466.18338430641421599798.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Nov 2021 23:20:10 +0000
References: <20211012132525.457323-1-idosch@idosch.org>
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, popadrian1996@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, moshe@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Tue, 12 Oct 2021 16:25:11 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset prepares ethtool(8) for retrieval and parsing of optional
> and banked module EEPROM pages, such as the ones present in CMIS. This
> is done by better integration of the recent 'MODULE_EEPROM_GET' netlink
> interface into ethtool(8).
> 
> [...]

Here is the summary with links:
  - [ethtool-next,01/14] cmis: Rename CMIS parsing functions
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=795f42092f20
  - [ethtool-next,02/14] cmis: Initialize CMIS memory map
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=369b43a1a066
  - [ethtool-next,03/14] cmis: Use memory map during parsing
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=da1628840bd6
  - [ethtool-next,04/14] cmis: Consolidate code between IOCTL and netlink paths
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=6acaeb94402a
  - [ethtool-next,05/14] sff-8636: Rename SFF-8636 parsing functions
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=d7d15f737ab7
  - [ethtool-next,06/14] sff-8636: Initialize SFF-8636 memory map
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=4230597fe952
  - [ethtool-next,07/14] sff-8636: Use memory map during parsing
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=b74c040256de
  - [ethtool-next,08/14] sff-8636: Consolidate code between IOCTL and netlink paths
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=799572f86647
  - [ethtool-next,09/14] sff-8079: Split SFF-8079 parsing function
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=9fdf45ca1726
  - [ethtool-next,10/14] netlink: eeprom: Export a function to request an EEPROM page
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=2ccda2570d65
  - [ethtool-next,11/14] cmis: Request specific pages for parsing in netlink path
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=86792dbbebf3
  - [ethtool-next,12/14] sff-8636: Request specific pages for parsing in netlink path
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=6e2b32a0d0ea
  - [ethtool-next,13/14] sff-8079: Request specific pages for parsing in netlink path
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=c2170d40b6a1
  - [ethtool-next,14/14] netlink: eeprom: Defer page requests to individual parsers
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=9538f384b535

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


