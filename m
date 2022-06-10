Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8A545B65
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbiFJFAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiFJFAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB63420BE10
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 22:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66395B82EF0
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 05:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2294AC3411C;
        Fri, 10 Jun 2022 05:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654837213;
        bh=dkeWPlyyyp1DfX91mxaqGlPjB/ghVtwpI8kAwMVh3UA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bN2s47JHSr9F5ZxHim2pKwn7gd7xUG3YHTUdQEUSOyUsceccgLZhKLZnfdwo7yS01
         UhIxjhGAwMnUn1Lf5uEkQI2am1GJCwmuynz3kcCBac2LV0u6xBXYmpJVmvwlPAjHsA
         J7pM6IxhLW9P6ujzhmkGNsmFv4CkVxP0i/+OWb8ps+zB9jKgF4onZyW+jB/8kbtFF7
         vMjP7Iift7s2rMiaLVnyxN+xQY/9/GwNABGMxzjKLenXj4Q2OmLuPDKRxxYO/lGzGx
         BB83GvLkPJ6FrTWOovlONsCMct3nl3JASLUYZCEzBpvX5XTWdDNn4vmK34ib845c9B
         GUgHaGORI3pug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08FCAE737F6;
        Fri, 10 Jun 2022 05:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] tls: Rename TLS_INFO_ZC_SENDFILE to TLS_INFO_ZC_TX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483721303.27235.2158003345591843875.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:00:13 +0000
References: <20220608153425.3151146-1-maximmi@nvidia.com>
In-Reply-To: <20220608153425.3151146-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        pabeni@redhat.com, borisp@nvidia.com, tariqt@nvidia.com,
        saeedm@nvidia.com, gal@nvidia.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Jun 2022 18:34:25 +0300 you wrote:
> To embrace possible future optimizations of TLS, rename zerocopy
> sendfile definitions to more generic ones:
> 
> * setsockopt: TLS_TX_ZEROCOPY_SENDFILE- > TLS_TX_ZEROCOPY_RO
> * sock_diag: TLS_INFO_ZC_SENDFILE -> TLS_INFO_ZC_RO_TX
> 
> RO stands for readonly and emphasizes that the application shouldn't
> modify the data being transmitted with zerocopy to avoid potential
> disconnection.
> 
> [...]

Here is the summary with links:
  - [net,v2] tls: Rename TLS_INFO_ZC_SENDFILE to TLS_INFO_ZC_TX
    https://git.kernel.org/netdev/net/c/b489a6e58716

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


