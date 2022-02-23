Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418184C1F8A
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244758AbiBWXUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiBWXUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:20:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012E658E49;
        Wed, 23 Feb 2022 15:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94459B82257;
        Wed, 23 Feb 2022 23:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26AC6C340F0;
        Wed, 23 Feb 2022 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645658410;
        bh=xc6wLZfo8m4QTzQ1PiZ9jo7DXq6dVwZ5z54Of9ZzEa8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FBxKOgS5v3hm2FShxDqSWovaapxZ+32q3IZTjH8xKDGgnSyzdwp8qAYzejThwdxf7
         /5qQ1f/FAJUYZIXc1J1RqT0T4bKHA1+CKwGgIoGPkL83AJkJCU1XMOscGrFcRjA3cv
         IOHCTtGAS/wFj+t4bMBm3hgNkaPy4/nWPWSjn1qDKD+QyHtOGDUm74EdYgAfEDsBek
         U5JvXxu4jTT7lEPWCYFEkOfd8nNqX74v3RduKCkMHIPNgNB0Gux8ZwNJk3YkLcaRpG
         B9xSojlT9R+rGGzFxYfQ6W51RwjXZ5szWA5V+QYLvlKkA7gsWRHXjKvT5QaxM/L3iO
         xXthv+tZHAi9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0954AE5D09D;
        Wed, 23 Feb 2022 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: cleanup comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164565841003.1025.17613333501406510.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 23:20:10 +0000
References: <20220220184055.3608317-1-trix@redhat.com>
In-Reply-To: <20220220184055.3608317-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sun, 20 Feb 2022 10:40:55 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Add leading space to spdx tag
> Use // for spdx c file comment
> 
> Replacements
> resereved to reserved
> inbetween to in between
> everytime to every time
> intutivie to intuitive
> currenct to current
> encontered to encountered
> referenceing to referencing
> upto to up to
> exectuted to executed
> 
> [...]

Here is the summary with links:
  - bpf: cleanup comments
    https://git.kernel.org/bpf/bpf-next/c/c561d1106300

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


