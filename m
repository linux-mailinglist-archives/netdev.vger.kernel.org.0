Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A8869C922
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjBTLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBTLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEA113D72;
        Mon, 20 Feb 2023 03:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E2E7B80C76;
        Mon, 20 Feb 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29445C4339B;
        Mon, 20 Feb 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890818;
        bh=6TW+McY7VMoUN94Mg1geIgau5xCAwidscN07xlXPpws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gS69Mx4bMgZwvM5nHx5X6fK/dsc7sqg1/hSZyRjpSIZY6gLTNB8UyFEMkLm0Rqah4
         iOEjQswcPh4rDHWYF0JtpUW2cW9VfK+EXD714asw57lI+a3VfoVdyR0O8hemWNU9vt
         F4SLr0PCBOoeP2S7BSCfNmIzn+k0qgQVwQWCT+/A9RrKmbQAMfo4wLibtYimWhY5xP
         1tzzzsJzBrh5+Lk/m6hfmfJY7TrGfmLyK9QYF47ksBTn2ToBbP3LIZZYxEerbT1mrk
         sFQMTQJm4ENRvBMqo9k+Fp0T3ohX/ozj+Oi4NSgAMcFkDX8enDs0zx5FrgF6Hj2Xm6
         BV5sqrFB0oUVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 071F6C59A4C;
        Mon, 20 Feb 2023 11:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: microchip: sparx5: reduce stack usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689081802.18600.13942568365570336925.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 11:00:18 +0000
References: <20230217095815.2407377-1-arnd@kernel.org>
In-Reply-To: <20230217095815.2407377-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arnd@arndb.de, horatiu.vultur@microchip.com,
        yangyingliang@huawei.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 10:58:06 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The vcap_admin structures in vcap_api_next_lookup_advanced_test()
> take several hundred bytes of stack frame, but when CONFIG_KASAN_STACK
> is enabled, each one of them also has extra padding before and after
> it, which ends up blowing the warning limit:
> 
> [...]

Here is the summary with links:
  - net: microchip: sparx5: reduce stack usage
    https://git.kernel.org/netdev/net-next/c/129ff4de58ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


