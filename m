Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36FF471198
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhLKFDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLKFDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:03:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C93EC061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 21:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC97EB823FB
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 05:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6846BC341C3;
        Sat, 11 Dec 2021 05:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639198809;
        bh=/cWgFkIoK3ArG5MMDHmnoPW+jANfJoPAosyJLtCHcog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HhAoAdq2fcU2syc+DkfQ9FFpUlRIxRAuiBRNFPN/xMMYDrOmPozh2JUKVluoViqhU
         kztObv0kg07ItaLGREBVRhUDqosh8r981mdKs4U1PUy0rqkPWwTNd89kGBnJNQ7KAr
         wJt8h8OmNfGeL9I34b+/cSwrfOd5Ha9CdJVgl624yvi8c7OVBEXEtRkGQjHT5CV6tZ
         6xpN8yuK+ZP8UOzX5nEAR6eju6fkayCj+J8JWyZPhv3HXCXwlnDDs58EQp/mXBbKh+
         pmzs8R9UTMnSb05dP0AyLXcQaQhFX9Og3jdXTQipUfJnDRFXl5tWcCs4zIfdnfQ5gb
         92JVTWC0oXq3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3FEA660A4F;
        Sat, 11 Dec 2021 05:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: wwan: iosm: improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163919880924.32697.3467081072465205577.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 05:00:09 +0000
References: <20211209143230.3054755-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211209143230.3054755-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 20:02:26 +0530 you wrote:
> This patch series brings in IOSM driver improvments. Patch details are
> explained below.
> 
> PATCH1:
>  * Set tx queue len.
> PATCH2:
>  * Release data channel if there is no active IP session.
> PATCH3:
>  * Removes dead code.
> PATCH4:
>  * Correct open parenthesis alignment.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: wwan: iosm: set tx queue len
    https://git.kernel.org/netdev/net-next/c/5d710dc3318c
  - [net-next,2/4] net: wwan: iosm: release data channel in case no active IP session
    https://git.kernel.org/netdev/net-next/c/da633aa3163f
  - [net-next,3/4] net: wwan: iosm: removed unused function decl
    https://git.kernel.org/netdev/net-next/c/8a7ed600505a
  - [net-next,4/4] net: wwan: iosm: correct open parenthesis alignment
    https://git.kernel.org/netdev/net-next/c/dd464f145c8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


