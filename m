Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD297471B78
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 17:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhLLQAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 11:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhLLQAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 11:00:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9D8C061714
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 08:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8975B80D23
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C380C341CA;
        Sun, 12 Dec 2021 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639324811;
        bh=97cThCaxpNwoAB2q2V9Hs8UMTYi0P3zOkKvjAh0/P6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wck28GcCxhtDfyE78ELxQ+y0239icxCEmotwOIe3EIEm/FOA3cSxxQCWpT+FihQBy
         KoUzzf6p4KfZOvThYR4nizVBSEQzxCgRErB/SU9+IpO5om1/Tbm9pkdcv0o0z9bbO6
         k/3Ush+hd4P/ta9QY+7eWbVoJvOWizwT6oU0VmU4+rsGyOqioVeFSgaMka4JFsq1YA
         VqGhNqTT9j0DCPdxDUoHdoKkTkckJ6nTyKmbZuVQME7NRBfkDnCuZME3OlYTyEgT3E
         RIOlBhAX4JyIbaqF+UjtBa+JUbXbmENcDpemJiYODYhPWvHh24yosrB4LEdn3kinqU
         ztf6H4O50m6xg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F9EE60C73;
        Sun, 12 Dec 2021 16:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on
 intermediate devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163932481112.23253.7619803131813967578.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 16:00:11 +0000
References: <20211209222424.124791-1-tobias@waldekranz.com>
In-Reply-To: <20211209222424.124791-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  9 Dec 2021 23:24:24 +0100 you wrote:
> In a typical mv88e6xxx switch tree like this:
> 
>   CPU
>    |    .----.
> .--0--. | .--0--.
> | sw0 | | | sw1 |
> '-1-2-' | '-1-2-'
>     '---'
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on intermediate devices
    https://git.kernel.org/netdev/net-next/c/e0068620e5e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


