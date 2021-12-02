Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B607466BE6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377156AbhLBWDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349141AbhLBWDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:03:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BE1C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 14:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 014E3B823D0
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 22:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9CB5C53FCC;
        Thu,  2 Dec 2021 22:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638482424;
        bh=7UtNq4nvFr23QRWFtHouRTv0HBR+mtHpmrhM6dZHSl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=duJMwQeXkWBCuS11UNGyF2HtNJYNZ8yz9e2vGOI4gLAN8OVSDEtKQo08gJunuJurT
         zNSK8QzhRkPG9SIGtyZF1TT4KD+oRPEsg6MXprGiLjpD2Mwyk4AKMij0yn7/qW8c2s
         AgkSIEcYRQLgN1HSLLZwtSDeyt6+fXOh6KmCvG4T5rTkUVnBhqeB7LACKRXLZeCZqJ
         PvrlBZ9JOMv4L1LzXNCZLgZnMH9M9WRahDGkwo48YCOR69oJWfJKdBbqs79KnjoY0d
         uKNsAT9HPluc1eSnoeEGnvwUyZD0XT5ObcsfOP7Kbdd+ReNdQC4ymkEPltotG1AXUT
         WWoBWR7n7Ta4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A124F60A7E;
        Thu,  2 Dec 2021 22:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next 0/8] ethtool: Add support for CMIS diagnostic
 information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163848242465.30140.3786203565321571970.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 22:00:24 +0000
References: <20211123174102.3242294-1-idosch@idosch.org>
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
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

On Tue, 23 Nov 2021 19:40:54 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset extends ethtool(8) to retrieve, parse and print CMIS
> diagnostic information. This information includes module-level monitors
> (e.g., temperature, voltage), channel-level monitors (e.g., Tx optical
> power) and related thresholds and flags.
> 
> [...]

Here is the summary with links:
  - [ethtool-next,1/8] sff-8636: Use an SFF-8636 specific define for maximum number of channels
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=73091cd94023
  - [ethtool-next,2/8] sff-common: Move OFFSET_TO_U16_PTR() to common header file
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=837c1662ebd6
  - [ethtool-next,3/8] cmis: Initialize Page 02h in memory map
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=8658852e0ef7
  - [ethtool-next,4/8] cmis: Initialize Banked Page 11h in memory map
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=27b42a92286b
  - [ethtool-next,5/8] cmis: Parse and print diagnostic information
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=340d88ee1289
  - [ethtool-next,6/8] cmis: Print Module State and Fault Cause
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=eae6a99f3d13
  - [ethtool-next,7/8] cmis: Print Module-Level Controls
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=82012f2dbfeb
  - [ethtool-next,8/8] sff-8636: Print Power set and Power override bits
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=d7b100713f73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


