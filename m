Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8A47B9CA
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhLUGAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhLUGAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 01:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63410C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 22:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD024B811B1
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 06:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A54DC36AEA;
        Tue, 21 Dec 2021 06:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640066410;
        bh=UZppnjYX4fgm2YTp+uyGNm+6disGPF6dFnvdgTGniTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H1CuB5XMF0N4fTbBhWN3VC9C+sJOU3tHs+nBUy2mHB8+7TxGcyuFUZhqA5YlL72Jc
         BDayqhiH3xEWOlyxBsYoQ+v2bi9T/EpDqI/Ly7LsRHBLCG0n5VEjBTuLt1jAqzqhcb
         MrQwV9ZBu5vby1DcrdZk+wiUxaOSfTv/E6Xy7bktb+TdYkMmSrEyZJvGUTzwlJ27QX
         jz/92gmEMExqzEK9gGIqozOf6OUVCJ3rvtoyS6Fdw1Vx4cJk2WwGAuEUZ5JOuI4+E1
         ZxyV31QtSNxD/6OcTSaGDt4aPTpEROftqozV52u9mDNX4f3kNlcWvddyMJ8UU5V1zS
         wV2qN+OGrlrLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F522609CC;
        Tue, 21 Dec 2021 06:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: amd-xgbe: Add support for Yellow Carp
 Ethernet device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164006641032.29004.13923329128249593164.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 06:00:10 +0000
References: <20211220135428.1123575-1-rrangoju@amd.com>
In-Reply-To: <20211220135428.1123575-1-rrangoju@amd.com>
To:     Raju Rangoju <rrangoju@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com, Raju.Rangoju@amd.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 19:24:25 +0530 you wrote:
> From: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> Add support for newer version of Hardware, the Yellow Carp Ethernet device
> 
> Changelog:
> v1->v2:
>  - Rework xgbe_pci_probe logic to set pdata->xpcs_window.. registers for
>    all the platforms
>  - Add a blank line before the comment
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: amd-xgbe: Add Support for Yellow Carp Ethernet device
    https://git.kernel.org/netdev/net-next/c/dbb6c58b5a61
  - [net-next,v2,2/3] net: amd-xgbe: Alter the port speed bit range
    https://git.kernel.org/netdev/net-next/c/2d4a0b79dc61
  - [net-next,v2,3/3] net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices
    https://git.kernel.org/netdev/net-next/c/6f60ecf233f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


