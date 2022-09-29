Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD65EEC15
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiI2Cuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiI2Cu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:50:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662152A244;
        Wed, 28 Sep 2022 19:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2F27B82332;
        Thu, 29 Sep 2022 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4148C43146;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419825;
        bh=YevnDEubvU0sdtOj8UG48Md22wqIsWLNl+59L4zSjS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JIbbBpCxqY++r5h2p4IVjampQ6C/tw3yUAxGp3Ug+SQRshCuK6eTPt0x7MpALmpZ9
         5Z6u6KkL1BfuKYT6jPPhYwi4sNJcVYHM2UYVfL1Pv7z2Lnvgx3kd+KagUtsVnoUtuq
         zcKJKtT0hVwTwy/qb3VXE9YGFs5zzexGgebjECa7BhXBoCynLAB17kXtK3ZnysYdzw
         jzK3NpyN3pIlFoi5XLvTQIL60uKAJxX5X5crBQSSbiksGBHXbZS+UMwJ2x4fj479Pp
         t3xre+qHVWPx1Ttn6vWSuiR/9h3k3Sn+1/r+vyQqlsrJkzNk8vnSmOD7m0Us5TWKLc
         yZVn7toF5MAiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98A40E21EC6;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sunhme: Fix undersized zeroing of
 quattro->happy_meals
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441982561.2371.14031176040255723237.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:50:25 +0000
References: <20220928004157.279731-1-seanga2@gmail.com>
In-Reply-To: <20220928004157.279731-1-seanga2@gmail.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, eike-kernel@sf-tec.de,
        zheyuma97@gmail.com, nbowler@draconx.ca, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 20:41:57 -0400 you wrote:
> Just use kzalloc instead.
> 
> Fixes: d6f1e89bdbb8 ("sunhme: Return an ERR_PTR from quattro_pci_find")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net-next] net: sunhme: Fix undersized zeroing of quattro->happy_meals
    https://git.kernel.org/netdev/net-next/c/d4ddeefa64ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


