Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5442230546C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhA0HW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317409AbhA0Al6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:41:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B443664D89;
        Tue, 26 Jan 2021 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611703811;
        bh=cnR6Y+utMlgP0eto9rdhz+OyrDyT6Lfb7LNe6Sgl4Dw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DxF38pv+LfWiUFYPFqNea+f375V0Oi865MigGUo0y71t0KX0pAwXGhJ2NSwozGSjo
         ZJw9NXLSpcxqPvw+KYSiLh9DSx5dCWfTjfY7b3SYVccg98fROyqcJ7rFXk2MqXbdmA
         2OrYYjZZj5WQ0voBSy+xeHus7WQ380ukPRNQY5cI/JdTAnTU5XtqnqjmGDqgM4dY2J
         Q/Fc1bcdOoCo0OyjHnsHRJZTwBlbMcPy8jfIcl931n46AF7YrIWRrIHFZot0hhin2H
         txGYSHFzeparVCChQ9XITmUeCXMXmItac0sPivxKBQvjYLJL8C+a03/GzQQxwc21z2
         U7HKeqbOo5yKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABA8E61E3F;
        Tue, 26 Jan 2021 23:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-01-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161170381169.29376.17249048477482452205.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 23:30:11 +0000
References: <20210126130529.75225-1-johannes@sipsolutions.net>
In-Reply-To: <20210126130529.75225-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 14:05:28 +0100 you wrote:
> Hi Jakub,
> 
> We have a few fixes - note one is for a staging driver, but acked by
> Greg and fixing the driver for a change that came through my tree.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-01-26
    https://git.kernel.org/netdev/net/c/c5e9e8d48acd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


