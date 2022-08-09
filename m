Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C088E58E117
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241870AbiHIUaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiHIUaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AA71117
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 13:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C33B81890
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 197DEC433D7;
        Tue,  9 Aug 2022 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660077014;
        bh=znv6+dfbKqUORUrYaK8UAoo/cD+oT+/6xIy2MNhVNy0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kRUe2AMR9CDIuvYCRBFqxYQ2iekj9/Y0zmb4PQiW1OrIKeH9lGhTpD7JHY6E1hn8g
         1/Pl7QB5L85YnVASogQosuXtrkeSNg0Sfm5p4Zl4fRfM49MBXZKET+E0l6zFSGiVmY
         AnYzaJxZHXA8XROBS0brkN95dX5NJfOUu+r1pTKaASeLgyPWUIm6gl8HNmGQzvd3Bb
         U2XMDHQYd57XWCYS+9aqB8ewXZZymbkBtwW+XZNjkA7f3l/CCa1n7KobFQlZGOPzUN
         Gx0XJlRz7esGAizYj6MOWa/TE/qmxuCwsClGhm1CHmq4yv0iVLQVKL/MKkh8lTSgne
         oxTcazoO14mEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00839C43143;
        Tue,  9 Aug 2022 20:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ipstats: Add param.h for musl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166007701399.29749.2611474742171367362.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 20:30:13 +0000
References: <20220809040105.8199-1-changhyeok.bae@gmail.com>
In-Reply-To: <20220809040105.8199-1-changhyeok.bae@gmail.com>
To:     Changhyeok Bae <changhyeok.bae@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru
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

On Tue,  9 Aug 2022 04:01:05 +0000 you wrote:
> Fix build error for musl
> | /usr/src/debug/iproute2/5.19.0-r0/iproute2-5.19.0/ip/ipstats.c:231: undefined reference to `MIN'
> 
> Signed-off-by: Changhyeok Bae <changhyeok.bae@gmail.com>
> ---
>  ip/ipstats.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [iproute2] ipstats: Add param.h for musl
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=cf6b60c504d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


