Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2F14111BB
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhITJOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236859AbhITJLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A5B96117A;
        Mon, 20 Sep 2021 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632129011;
        bh=1JSW2s29l6X75dtKF+WwVkVPlY7FiFaQq+sEwm2lX0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iDUzHsXZYOJ7Pm5WHFmtIUMxd/C5xjcbJFNJmS/yWy+DYK+DkyCeUMjAOHx38kmAi
         47MGhpJY5fCpo0ODtXIy5CHU45x4L2nZdhlyNRd2o4dwzMkRqAtVZIKc3EdCYZ2JYE
         KCuDp0FLSacuWGGe7pkJrmORNuZok/8tbX27T+s7sesJSU+TjNTXBZLIzM1g3mV384
         H7SAlRmySRM7ODUR2+xDYikFDixfd6ZsfQOCj14Wpp97sH5znjLamt4HQL/m/nHith
         N8Y6uls2IlzeOkl9/D7OOnjZSoKOp/UzU9+dwpRqcEpsjFL0Dvu+5zdUHNEnfObuS2
         sxiGab99pepYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 825F560A2A;
        Mon, 20 Sep 2021 09:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: lantiq: add support for jumbo frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163212901152.27858.11382739032716027414.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 09:10:11 +0000
References: <20210919182428.1075113-1-olek2@wp.pl>
In-Reply-To: <20210919182428.1075113-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 19 Sep 2021 20:24:28 +0200 you wrote:
> Add support for jumbo frames. Full support for jumbo frames requires
> changes in the DSA switch driver (lantiq_gswip.c).
> 
> Tested on BT Hone Hub 5A.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net-next] net: lantiq: add support for jumbo frames
    https://git.kernel.org/netdev/net-next/c/998ac358019e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


