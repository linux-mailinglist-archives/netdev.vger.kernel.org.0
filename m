Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4673C1AA4
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 22:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhGHUmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 16:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhGHUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 16:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 40DD86190A;
        Thu,  8 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625776804;
        bh=HxXM0BT8B6n5Hg+8DWnwAPmAzW1TaFIxFUzbeyloznk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eaYUhbOFfMioEmaf6uYdxTueSOlcpxYgVZ5caNAsTmdSAMoK8HhtgCJ04f230MKvc
         qq8/ZucgAM6XsLFt5uJDncPqLWXfROMTTb6fhLa1RNQzga0rgGW8xEm58+1XHoW8db
         qAhiXA3n6cwHGIKztywDiMWZ5gjhUnH8SEPv+qI4JTmGo4sLKRFnvwKXSjeJUQAkrE
         /JH0GbwKEoHGEDPk7iVacQ7bCYajPavIwmNrro99GVqPDTvGreFDssIhPkemYceX9m
         1ZsdC8VOgMzjxS7uFiaBGQdyKiyeFS6Dt2/1OdPRoc05Jooe5hPs9kB/kcikZ8lsuf
         Mkxr4l0KmXxsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A4DA60A4D;
        Thu,  8 Jul 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] atl1c: fix Mikrotik 10/25G NIC detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577680416.12322.10574184464851941517.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 20:40:04 +0000
References: <20210708094904.3613365-1-gatis@mikrotik.com>
In-Reply-To: <20210708094904.3613365-1-gatis@mikrotik.com>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Jul 2021 12:49:04 +0300 you wrote:
> Since Mikrotik 10/25G NIC MDIO op emulation is not 100% reliable,
> on rare occasions it can happen that some physical functions of
> the NIC do not get initialized due to timeouted early MDIO op.
> 
> This changes the atl1c probe on Mikrotik 10/25G NIC not to
> depend on MDIO op emulation.
> 
> [...]

Here is the summary with links:
  - [net] atl1c: fix Mikrotik 10/25G NIC detection
    https://git.kernel.org/netdev/net/c/b9d233ea21f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


