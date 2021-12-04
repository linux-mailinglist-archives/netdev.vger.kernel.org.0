Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E304681FB
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 03:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbhLDCdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 21:33:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35946 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbhLDCdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 21:33:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704FE62D9D
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0BF3C341C1;
        Sat,  4 Dec 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638585009;
        bh=idlWxmk8sO++cJF6wr7rgpBhPSMX7y72bSA8nm27X4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i2MbljaPJalBYiV0/EDOhXd024KPiw16WnkmgpO/i9n8ERIraUbUmh4Yl5uaWcRby
         EVqlL6fYsZoSvz256ygkcLHOPfARqxIdZbdDj7CZbuBnHsRXIf3PldnOqlMXvlVguT
         99kbqWJ8d62Nmulwe6ajg5SBydDvdc7Zs28Vpx8ps/B8ekccjmhJGg4E7YUHQmkvZZ
         U5upDQEoKVox/nsNyvhC2AYYXVD2vwkWSzzm8/zM1Qf5hPsLbeKnefOVlA9GfCT2e8
         tVC7GzLuMVa1X4Yf7SJPS9pFaTMWS9BQCgKhXkhuxLpzdpH6FfCRVGHimVJU20PuYy
         c+QUN0ickRqTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B380F60A88;
        Sat,  4 Dec 2021 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] qed*: enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163858500973.7831.11790019419849892928.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Dec 2021 02:30:09 +0000
References: <20211202210157.25530-1-manishc@marvell.com>
In-Reply-To: <20211202210157.25530-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        palok@marvell.com, pkushwaha@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Dec 2021 13:01:55 -0800 you wrote:
> Hello Jakub,
> 
> This series adds below enhancements for qed/qede drivers
> 
> patch 1: Improves tx timeout debug data logs.
> patch 2: Add ESL(Enhanced system lockdown) priv flag cap/status support.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] qed*: enhance tx timeout debug info
    https://git.kernel.org/netdev/net-next/c/0cc3a8017900
  - [v2,net-next,2/2] qed*: esl priv flag support through ethtool
    https://git.kernel.org/netdev/net-next/c/823163ba6e52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


