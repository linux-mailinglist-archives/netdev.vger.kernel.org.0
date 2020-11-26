Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E109B2C4C9F
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbgKZBaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730646AbgKZBaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 20:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606354205;
        bh=7QrLC9U31XgbmXbXg55nH3RGgIyYlBPrf7XWsoB+5y0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MR3T5vDYBcd4n4Sfzsw73yL7qfPEvlpZcjRP9aokHkcqZ+eDWXZM3WD3ZVOiLhJny
         i0rywagYMqWSAy/K1NIetq1DyOpwA8uzJMzaQ4Zby4nRKcHdof5UFY43BFtKdSr+Jd
         OikKOd9omDnTeZJ8zhNh8nEUiq4dwqwCAdEDly4o=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] ptp: clockmatrix: bug fix for idtcm_strverscmp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160635420492.14519.4600806690882509526.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Nov 2020 01:30:04 +0000
References: <1606273115-25792-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1606273115-25792-1-git-send-email-min.li.xe@renesas.com>
To:     <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 24 Nov 2020 21:58:35 -0500 you wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Feed kstrtou8 with NULL terminated string.
> 
> Changes since v1:
> -Use sscanf to get rid of adhoc string parse.
> Changes since v2:
> -Check if sscanf returns 3.
> 
> [...]

Here is the summary with links:
  - [v3,net] ptp: clockmatrix: bug fix for idtcm_strverscmp
    https://git.kernel.org/netdev/net/c/3cb2e6d92be6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


