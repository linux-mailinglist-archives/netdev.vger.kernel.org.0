Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1C95912F2
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239065AbiHLPaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbiHLPaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7EAF36
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408A061495
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 15:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1446C433D7;
        Fri, 12 Aug 2022 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660318214;
        bh=1jF7DOrEf8N/nffotspTvNCJCNAWNb8Rnq2cvB8CbgI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lg3xJdEhlEyXGJRtk5fej4mkJ76/LZXoN56knGn0fiUCdUvjz63WBMG9wDJMHHrK6
         TDX7Xeul7m8z0q7LJio9ki54Vuhw+b2CsB4ZZI1ZXpa/947oQxOjrI/UYCyn4AZ365
         Zg2MeoVHI0VboJ00E/6TqH+jEQkh1/L/Xhp6J2PQKYtRn97Uw8gchCnS9wk65H3LRg
         ChzTepztLkhcRcUyrzBbdtqKk+Em79JMPNIvGKEUQuBikND5WmfBuOfIH/JzDvIwjT
         a/vVYrnNuWPENn5xz14hPm1QrRFKlRiyhEUZRLTGxcKTYbBqrsEWK4aUj0NSwh1Pmy
         SMZJN/xaI9asA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8572AC43143;
        Fri, 12 Aug 2022 15:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] configure: Define _GNU_SOURCE when checking for setns
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166031821454.23179.10404340093924251734.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 15:30:14 +0000
References: <20220811053440.778649-1-raj.khem@gmail.com>
In-Reply-To: <20220811053440.778649-1-raj.khem@gmail.com>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 10 Aug 2022 22:34:40 -0700 you wrote:
> glibc defines this function only as gnu extention
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  configure | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - configure: Define _GNU_SOURCE when checking for setns
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d5fe96ab7092

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


