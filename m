Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F363AA4F8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhFPUMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232484AbhFPUMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CCFF613C7;
        Wed, 16 Jun 2021 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623874203;
        bh=RUAftpE1yfV3/vOjbCN0Vb+WN2jMJap5J6BQ+NAaWno=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uY+JmW7/cAxHMJ/Etr3VxpM8EiI3fjvSRvVg8H7zPYjLFmUfWPHCn7lG0WmWSOWZ6
         orwJ/qBVhVbIPdHbkK+5JkJZ9Ngt4NyzHAH/ONUn81aBbXwcxYxaDEELwo/DBVGZZZ
         tB/ucqcsyqasDeRYtkpFg6ZHs/4cL5AGWYFvZVdPr4lngUEjyQXyc5YjSdMnOGRVqn
         gA7Bg/htFRMDTDLpDbZhTaIWhr6GLPkpAB92rNWm0jsVJFF4hAbzPMgLmQ+eMcWAol
         xLAW4V6Dk0cItxQVg0bDrYfenmXCDTLlvKLSC9T0zClbjY0wXjYlDjpeJy2YH22oHw
         xU/7Ae7xnfPwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7BA7A60C29;
        Wed, 16 Jun 2021 20:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387420350.22643.17300640381882901139.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 20:10:03 +0000
References: <20210616195333.1231715-1-keescook@chromium.org>
In-Reply-To: <20210616195333.1231715-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, sergei.shtylyov@gmail.com,
        davem@davemloft.net, kuba@kernel.org, s.shtylyov@omprussia.ru,
        andrew@lunn.ch, wsa+renesas@sang-engineering.com,
        geert+renesas@glider.be, jesse.brandeburg@intel.com,
        michael@walle.cc, yangyingliang@huawei.com,
        rikard.falkeborn@gmail.com, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 12:53:33 -0700 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.
> 
> The memcpy() is copying the entire structure, not just the first array.
> Adjust the source argument so the compiler can do appropriate bounds
> checking.
> 
> [...]

Here is the summary with links:
  - sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
    https://git.kernel.org/netdev/net/c/224004fbb033

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


