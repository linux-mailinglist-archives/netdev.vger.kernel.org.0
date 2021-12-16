Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BFA477DCB
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbhLPUpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:45:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55380 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLPUpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:45:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E152361DD8;
        Thu, 16 Dec 2021 20:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33A27C36AE8;
        Thu, 16 Dec 2021 20:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687500;
        bh=JiZV7XNM6GJmdECwQ8AFaThB+fjwBm3vrsXlZdkm80o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fes0LtcchN3hW/4BJpCg674akbRYp2vuTcxdgZmiX3GIzpl0Cd3jTdYC7tBWkNrIn
         2ro0hVd28Z5Q8hjIK7XlcfjT7OV4DrNB94c0lOer0DMFasgkKo+RxbIDvoaNB3L3rn
         PfzqbqxGQI3wIzC43Ty73aKop9D8MA2UVBhyZq77sniQrgYGAX6xdITwslTKiOCgaJ
         PvnG9SmdUZLp9JMNrjYbJsQpxokKrfzRJDhQRS+q7w+WdIGt+5mf3u8wgHwv2M//AL
         JEcmp5+b+uQp0Ca8vKV5rSHGm84fj+3jDMGngsQs7N0f2w4LUsPme+S3wlZPYoCqjj
         eR9x6n+naITug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A7D260A0C;
        Thu, 16 Dec 2021 20:45:00 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: prestera: flower template support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968750010.12846.7921765909532663218.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:45:00 +0000
References: <1639562850-24140-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1639562850-24140-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        vmytnyk@marvell.com, tchornyi@marvell.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Dec 2021 12:07:30 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Add user template explicit support. At this moment, max
> TCAM rule size is utilized for all rules, doesn't matter
> which and how much flower matches are provided by user. It
> means that some of TCAM space is wasted, which impacts
> the number of filters that can be offloaded.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: prestera: flower template support
    https://git.kernel.org/netdev/net-next/c/604ba230902d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


