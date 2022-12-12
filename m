Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08F264A537
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiLLQnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiLLQnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:43:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB54215710
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 08:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B94661160
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80CDDC433F0;
        Mon, 12 Dec 2022 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670863215;
        bh=plqEjMZSq2gAb48ExsQlWH4NtZFwgnq4fO+8aY6JpFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c6hvblBjpAxxoomNtdXJNPWwZEPQq17g0j6xqYgXv2XmT1yuX/45Hxml+vKWbGlsx
         L13jHh1jeKaSkm4IyCC+zoTW5zhYP+F1nsGsKR2FX1dsXo6IE4oYAnh/vkYyZOulyH
         1xLpzDutZ+mR/3PeizcCuR1NDeRXr5hRj2slZpbknQrKwhkwfikJF11ZBeKu2t6BE9
         CXuErpEGI28TLPE5xaXwh0SdnkKEOUsNmhKOEbWX2Oj+qUCns40daBJqobbRBgGZTT
         iYcP33yh2LZmxy9AQKmVqDZJS5Vi70cz5yi9KL3QGLc5vnColjqHFz043R8NPnabim
         GAWhwEi40IxCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63B21C00445;
        Mon, 12 Dec 2022 16:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tc: print errors on stderr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167086321539.24969.14338758312470156638.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 16:40:15 +0000
References: <20221210034736.90666-1-stephen@networkplumber.org>
In-Reply-To: <20221210034736.90666-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri,  9 Dec 2022 19:47:36 -0800 you wrote:
> Don't mix output and errors.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  tc/tc_class.c   | 2 +-
>  tc/tc_monitor.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - tc: print errors on stderr
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=523692fa17e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


