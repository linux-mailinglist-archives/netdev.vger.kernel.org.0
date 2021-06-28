Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368703B6B38
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhF1XNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236609AbhF1XMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B3EF61D0A;
        Mon, 28 Jun 2021 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624921812;
        bh=poRunMaz3+Z+JHnsFL8CMdDExbfL/7oL0U/GCaW0rJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DBUK+tOGWfYtTtWci+Cz5oWrNbFQLjY3Pe7C+QnN4IHB8kLYUOEyCeEXlE1yaNVba
         JpEDShrebzufTHj3nv0qPcYZj+B4S5wi/nFe8vlT1tqoqG/JNmk3OC+LTciCPAXKmt
         qe8MhRvIuePhltV5AXZjsOZpSFNraqqyl0/Tnz/XUhS5F0b6lywUWFzH9jj3nDeM8S
         oM3z/xGetnV7o4O14Z2Uugd9eOL2BKG0tIBarG3+RX+ueO1vWU6QV9QzEwA8E7li3h
         6eWAgGR1m0UPhiqURnaRptuFOyCBpJecNWnebxBNBDPdPZe38ytN2Z+qskouIK+OGE
         hCdMx56aH2nvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16A4F60ACA;
        Mon, 28 Jun 2021 23:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: fix dynamic access to L2 Address
 Lookup table for SJA1110
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492181208.29625.7868510927377371958.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 23:10:12 +0000
References: <20210627142708.1277273-1-olteanv@gmail.com>
In-Reply-To: <20210627142708.1277273-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 27 Jun 2021 17:27:08 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1105P/Q/R/S and SJA1110 may have the same layout for the command
> to read/write/search for L2 Address Lookup entries, but as explained in
> the comments at the beginning of the sja1105_dynamic_config.c file, the
> command portion of the buffer is at the end, and we need to obtain a
> pointer to it by adding the length of the entry to the buffer.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: fix dynamic access to L2 Address Lookup table for SJA1110
    https://git.kernel.org/netdev/net-next/c/74e7feff0e22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


