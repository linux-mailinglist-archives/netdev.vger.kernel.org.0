Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3890B2AA814
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 22:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgKGVUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 16:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGVUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 16:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604784005;
        bh=IgSVB0w1/8v+I94nl0O0vAtkNO4qKU91R415g6JaWrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rigYtlwWVpW33zt9ujFE6eCHR9xkE1Jtj2AO+UN2ebeM1JEODYaUdr/iLssURVfFZ
         k8fE4ORq5u38AOlQDT3IKIL/KCz/MrnAYVGLsUGIEMZXEPTvIKaSDygxcrF+rJ68Pn
         IFhNQUxlxdx91i4JD+A0a8Q5YnaAH6SUJ2nOmqZY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 1/3] ptp: idt82p33: add adjphase support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160478400523.31399.554998376784709803.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 21:20:05 +0000
References: <1604634729-24960-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1604634729-24960-1-git-send-email-min.li.xe@renesas.com>
To:     <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 5 Nov 2020 22:52:07 -0500 you wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjphase() to support PHC write phase mode.
> 
> Changes since v1:
> -Fix broken build
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/3] ptp: idt82p33: add adjphase support
    https://git.kernel.org/netdev/net-next/c/e014ae39493f
  - [v4,net-next,2/3] ptp: idt82p33: use i2c_master_send for bus write
    https://git.kernel.org/netdev/net-next/c/e4c6eb68343f
  - [v4,net-next,3/3] ptp: idt82p33: optimize _idt82p33_adjfine
    https://git.kernel.org/netdev/net-next/c/6c196f36f524

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


