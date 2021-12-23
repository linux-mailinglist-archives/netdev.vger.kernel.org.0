Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B6F47E77D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349758AbhLWSKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349748AbhLWSKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC792C061401;
        Thu, 23 Dec 2021 10:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82F4E61F52;
        Thu, 23 Dec 2021 18:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E55B9C36AEA;
        Thu, 23 Dec 2021 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640283018;
        bh=l1VYt0dzWvTkqVXXbwnBc6loid1o5kfkD+eVvAXrUw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W/OqEC+mlluOuqvDpoti/9geShuuGN6RPAHoNe+2biuKDPcrgOiKPz3tV1x7ZC4N6
         9gfOZ8ON8+gTwc+X7CyC68zwVnYPzwJtavuToqlEwIuEo3Wj+QgjbIGjNqnJRFkwbX
         408SaCGL0WI6xgZUgheMNgxpZGnql8wxEFfJ2Tw2Q9Mw+xPrkKjFY+TCJhx5oi7GV7
         4ZNCTzfSWMMLOxB+Jrz0zC4TpnHg/Y9qD00v3m66htaHev8+sSpicoHv9AEvvoF+bW
         FJpclzbputHLfeM0M1e9ZwK3exG/T5wUxvbHAr+ah4wOCY/zMKpPI31HNoLyu1LSnU
         PrgU0b5zA5Kog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1DD8EAC065;
        Thu, 23 Dec 2021 18:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-12-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028301885.27483.18038691334165573863.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:10:18 +0000
References: <20211223141108.78808C36AE9@smtp.kernel.org>
In-Reply-To: <20211223141108.78808C36AE9@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 14:11:08 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-12-23
    https://git.kernel.org/netdev/net-next/c/f2b551fad8d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


