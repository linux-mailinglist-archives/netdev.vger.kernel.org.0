Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1548811A
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiAHDaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiAHDaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:30:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3CEC061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECCC7B827CA
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B159BC36AEB;
        Sat,  8 Jan 2022 03:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641612611;
        bh=MS3oVpDryaYIzaUobooZaEnJnjOMSQIxzu7QDWk+xxc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QhPLGgRjC+llMD7dKxGbTeDYFpcOI6qd1AbYlibPcZxXG4xLKhQS5C1T+F6VFDRTF
         wvPZZ+6mu/b+BSFchzK2OLOtsanCdQ9lf1SUJSbvQm92MwoITk9DqeE9X9+MU2p8mt
         2/EuDhvs/3iY8W45Jr9quK4fupxNLCdJNc18bROp0t0/L0r8dFqYxLGynSef1P7KqV
         lFdoyKYsizekC7rzmMmvdPwbPhL/kCcXioHlPeZCKTHFane05Ua3FNRGMKlhJ6+jAc
         PTvmM0zTjX/AQnKGl2SJaDE31xOwnq0Sn1zqGxZ0xRh/SMAIQia+pSOLxEuLPB3YtK
         NFbXKkYXXqTUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94660F7940D;
        Sat,  8 Jan 2022 03:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] af_packet: fix tracking issues in packet_do_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161261160.5484.4583784154058425036.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:30:11 +0000
References: <20220107183953.3886647-1-eric.dumazet@gmail.com>
In-Reply-To: <20220107183953.3886647-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Jan 2022 10:39:53 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It appears that my changes in packet_do_bind() were
> slightly wrong.
> 
> syzbot found that calling bind() twice would trigger
> a false positive.
> 
> [...]

Here is the summary with links:
  - [net-next] af_packet: fix tracking issues in packet_do_bind()
    https://git.kernel.org/netdev/net-next/c/bf44077c1b3a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


