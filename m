Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481765293D6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349808AbiEPWuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349785AbiEPWuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF544132B;
        Mon, 16 May 2022 15:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C56060BD6;
        Mon, 16 May 2022 22:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F4D9C385B8;
        Mon, 16 May 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652741411;
        bh=H8Ig8EXbJar8cXW0tz5Hm1+0yJvrhqrl2ipJ1AljeLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JQ7vmmsWgg1kOotEKFznylZK02CymTRhZ+LDKg7Zv2rmpDw/ppZVPa3PWEkb968On
         K/pAuJ4nFYV8M/RAqPp/TwkU5+fSLNRgYmmfTioNixlUfAJBFdeR/ilUNE/Wt+XDW8
         Bl0TwP54vKXRP/lPO82Sfz35IADmwzXxEbgW/WY43TQhXynx7w6peVNeJatDAMsBxc
         hFEQSt/YZuedFyIETtqbcetVYuha3GQWYg6d/TQKxvjbtJocrnNi0eC/c9XuXiCMCN
         dYc2W/d76Rbsd7Y4v0jDE+ZfIc4h2TS6pN4+APhxpTTJRhIsBEid87gr+6Y81nOE6o
         bv62fPoiZ7xUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D092E8DBDA;
        Mon, 16 May 2022 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix building bpf selftests
 statically
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165274141144.14439.10661198051508391335.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 22:50:11 +0000
References: <20220514002115.1376033-1-yosryahmed@google.com>
In-Reply-To: <20220514002115.1376033-1-yosryahmed@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 14 May 2022 00:21:15 +0000 you wrote:
> bpf selftests can no longer be built with CFLAGS=-static with
> liburandom_read.so and its dependent target.
> 
> Filter out -static for liburandom_read.so and its dependent target.
> 
> When building statically, this leaves urandom_read relying on
> system-wide shared libraries.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: fix building bpf selftests statically
    https://git.kernel.org/bpf/bpf-next/c/68084a136420

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


