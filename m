Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024D441FC17
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhJBNLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233200AbhJBNLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1594A61B08;
        Sat,  2 Oct 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180209;
        bh=pxEdquuJtMBE/8AUwa7ZWnRSQPpuxTDUGkFKv/jhNTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s5Lup3Nlo5EO2uYZA8/FPPexQwDALINHQ2ZwSli+DgRtYioCmwATBxyIO83gSZPOP
         FBR08txYvHh84w9YEiRhdNkvoStdbMv2PAUj/Wd72sZk5Pp0APj0v+o91fcpqA/Ppg
         mZ490G/tpl5QLwmV/F3u2Arqd7qaAYRtDH/g6XKleeg2NzdPzU/3dAEJcr5lcRfH9k
         uO5E4n5NaUo7Aj8Ho4UVWRqAulcX8fO9/2m9du8GE70wGsPlrLwob/eYP2g8HL2ZGL
         RiprWdU6MEnJ1CI6lS66L3aAAnN0Y0PwgbgcvsMLfMb8HmZYzWoSEC0E1qiOssdl7l
         BoD39uNYLJx/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F1E660BE1;
        Sat,  2 Oct 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/7] ionic: housekeeping updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318020905.24030.3787281867816723192.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:10:09 +0000
References: <20211001180557.23464-1-snelson@pensando.io>
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jtoppins@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 11:05:50 -0700 you wrote:
> These are a few changes for code clean up and a couple
> more lock management tweaks.
> 
> v2: rebased
> 
> Shannon Nelson (7):
>   ionic: remove debug stats
>   ionic: check for binary values in FW ver string
>   ionic: move lif mutex setup and delete
>   ionic: widen queue_lock use around lif init and deinit
>   ionic: add polling to adminq wait
>   ionic: have ionic_qcq_disable decide on sending to hardware
>   ionic: add lif param to ionic_qcq_disable
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/7] ionic: remove debug stats
    https://git.kernel.org/netdev/net-next/c/ebc792e26cb0
  - [v2,net-next,2/7] ionic: check for binary values in FW ver string
    https://git.kernel.org/netdev/net-next/c/36b20b7fb1c3
  - [v2,net-next,3/7] ionic: move lif mutex setup and delete
    https://git.kernel.org/netdev/net-next/c/26671ff92c63
  - [v2,net-next,4/7] ionic: widen queue_lock use around lif init and deinit
    https://git.kernel.org/netdev/net-next/c/2624d95972db
  - [v2,net-next,5/7] ionic: add polling to adminq wait
    https://git.kernel.org/netdev/net-next/c/a095e4775b7c
  - [v2,net-next,6/7] ionic: have ionic_qcq_disable decide on sending to hardware
    https://git.kernel.org/netdev/net-next/c/3a5e0fafefe0
  - [v2,net-next,7/7] ionic: add lif param to ionic_qcq_disable
    https://git.kernel.org/netdev/net-next/c/7dd22a864e0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


