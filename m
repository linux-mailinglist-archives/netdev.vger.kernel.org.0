Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F48149D87A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiA0CuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiA0CuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CC1C06161C;
        Wed, 26 Jan 2022 18:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10099B82103;
        Thu, 27 Jan 2022 02:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4E35C340EE;
        Thu, 27 Jan 2022 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643251810;
        bh=Y3MYvAiBCC1wc1DbKUkBuH4UzeOVTQqcSkKJeZC7tmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yg4oe3SgOjTSkxtLTVCSa0DRIqjBvigFmzv3CVwIYOylhbaikTLyH1131MVFYiaB0
         /S9dl0SsMgbWrW7B5Qpc/N2Ntyp/klceNgkAcw8HUQm6EsmVtrvLkADh57U3jXjRL+
         N/lrFtxjjxX2mj0nzq5z3vLFQysxN/GxtPVkmeApASj/7YLh2ZzoaCkGb5bU/oFQDm
         psUwAwgOcQi/tVvTyLl0IBik7BThryNCAp6IZVYLmCECPL615pz90GtQhE4zyrJpxM
         8DQADDoGdYE6IqvOPEEOBH4Ljhihg4xTF6HjffIkZbUmmEh3pRAIRHDRKo48lksS9E
         vv/ysEP3nMHgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A30B9E5D084;
        Thu, 27 Jan 2022 02:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: cortina: permit to set mac address in DT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164325181066.16805.3054747911337839049.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 02:50:10 +0000
References: <20220125210811.54350-1-clabbe@baylibre.com>
In-Reply-To: <20220125210811.54350-1-clabbe@baylibre.com>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        ulli.kroll@googlemail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Jan 2022 21:08:11 +0000 you wrote:
> Add ability of setting mac address in DT for cortina ethernet driver.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Changes since v1:
> - fixed reverse christmas tree of the mac variable
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: cortina: permit to set mac address in DT
    https://git.kernel.org/netdev/net-next/c/15f75fd31932

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


