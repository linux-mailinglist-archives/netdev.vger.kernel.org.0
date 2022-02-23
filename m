Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231F04C1E22
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbiBWWAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiBWWAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:00:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59A250444;
        Wed, 23 Feb 2022 14:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F2E0B821CA;
        Wed, 23 Feb 2022 22:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECD4EC340EC;
        Wed, 23 Feb 2022 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645653610;
        bh=vWQBs3G3i9vK2r5DMeP37OjR4UCxSkBbDoRiY+cFFPw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qRJdOO30RvZcAaueebTcBqGHaXuhoFNV5krTJNoJ3ClxE8Si2gGXfkn9J0v0n5xeD
         Va24+5gXVg75cf28TN7XPcs2NJ1RB5lFPRzZjFE4stHkSjc10X68VyleCTKAyOOpEY
         J8dNHL13vG4jcKTLRuOyGHgogrBHAW+ixpuZCETrRiH4Iv3i4V3UVLf+OZRfI4Rl1Z
         UskRhhY8xRAS+IiiUlQF/lcIxvUkH+f8igrVvhKCVwgsY6xx5rtVR7/Y28TGGkecbH
         US/mUMa+hkVtttetl93ippVMnU5Nsq+Afp2YY3LZG2ScTtB3/IdcD3cmiNykOviTf3
         xO0AESBU3acYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7A3CEAC081;
        Wed, 23 Feb 2022 22:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpftool: Remove usage of reallocarray()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164565360987.26093.4940491187190066204.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 22:00:09 +0000
References: <20220221125617.39610-1-mauricio@kinvolk.io>
In-Reply-To: <20220221125617.39610-1-mauricio@kinvolk.io>
To:     =?utf-8?q?Mauricio_V=C3=A1squez_=3Cmauricio=40kinvolk=2Eio=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, quentin@isovalent.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 21 Feb 2022 07:56:17 -0500 you wrote:
> This commit fixes a compilation error on systems with glibc < 2.26 [0]:
> 
> ```
> In file included from main.h:14:0,
>                  from gen.c:24:
> linux/tools/include/tools/libc_compat.h:11:21: error: attempt to use poisoned "reallocarray"
>  static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
> ```
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpftool: Remove usage of reallocarray()
    https://git.kernel.org/bpf/bpf-next/c/a19df7139440

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


