Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D03519319
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbiEDBEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244835AbiEDBEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:04:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961452A729;
        Tue,  3 May 2022 18:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ECA22CE23B3;
        Wed,  4 May 2022 01:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 345F6C385A9;
        Wed,  4 May 2022 01:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651626034;
        bh=1F5MyON8V5sOtYsccoIdZukn9xGNXN4TnoqxzB1NfHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DX9zKfFnqAFxI8siOoT9vzKPZtk4vtaaBpsgELs1kmyHuMDbYK6F47M6Lq8s5IOPw
         uYjgTf664a9XoKJQYtCdMj8NEQ+xBfHGXdyYa/T68ZEXAQvI5e507aC+7OS5vsizJg
         Y641CC/S5wUu/jD1p1ogZV1SXWqEws44OUm9zw0wln/91P1ZwNtXumsc5S59y8EJWi
         wAYuXibLjxQelIAORXAFFY7E+2fsPGcdHmWLW5sOKiCxfLk3G3zuEqYpfqW7zn+6He
         2A0mXD4Z3p6LZZtdexwaxWEfbYnawSz4aQfckyVxLQOgWnOsnQn+DzH8DVKDXILgLL
         TsLbxwWW79v+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1811AF03870;
        Wed,  4 May 2022 01:00:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-05-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165162603409.2155.8662474734148013126.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 01:00:34 +0000
References: <20220503153622.C1671C385A4@smtp.kernel.org>
In-Reply-To: <20220503153622.C1671C385A4@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 May 2022 15:36:22 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-05-03
    https://git.kernel.org/netdev/net-next/c/f43f0cd2d9b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


