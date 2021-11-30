Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967EF463448
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbhK3Mds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbhK3Mdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:33:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0DC061748
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 04:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3BFDCE19D5
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24F94C56749;
        Tue, 30 Nov 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638275412;
        bh=wjJyEMGlTChRmi3auz8EnQyepsaYWm8kn6t5vF+41zw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iQb99hYkWs4QBBAxAXqNlN82ZWVVhfNDN8MB+L3mG927j8oQxkFInqyPmmKKwByF8
         jZeRAnQrfh2+NEx2XdkYOqG4bP3ACcBQTbxyS32+g2QsjBGNhQgP/wUTLEHPA0KRDm
         a2HM33FMRAxt6aDncvJdHhBmw+iPVhxzLDdad6B+NIZkyssq4xOF87JEtBKyl6/9Sb
         gObBGqvmbh9H1ktZbfDlv8zbPzSLrVkAOjK/vvFJFPkuUBw0O8nLrZ6ni3ft2WVIVu
         uOZD7Tvwc72B/Jo9ddNGRc36ylfqTwC28FeEo2EDnoqSbzvS0JQDfbsRJEWhTAEHrV
         jVA57f7exL6eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E78B60A50;
        Tue, 30 Nov 2021 12:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to
 active device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827541205.1181.8406705731008715479.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:30:12 +0000
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
In-Reply-To: <20211130070932.1634476-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, mlichvar@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 15:09:32 +0800 you wrote:
> We have VLAN PTP support(via get_ts_info) on kernel, and bond support(by
> getting active interface via netlink message) on userspace tool linuxptp.
> But there are always some users who want to use PTP with VLAN over bond,
> which is not able to do with the current implementation.
> 
> This patch passed get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
> with bond mode active-backup/tlb/alb. With this users could get kernel native
> bond or VLAN over bond PTP support.
> 
> [...]

Here is the summary with links:
  - [net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
    https://git.kernel.org/netdev/net-next/c/94dd016ae538

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


