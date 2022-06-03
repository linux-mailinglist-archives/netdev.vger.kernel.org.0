Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8868D53D19F
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345331AbiFCSgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244688AbiFCSg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F66313F30;
        Fri,  3 Jun 2022 11:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B6A46193C;
        Fri,  3 Jun 2022 18:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EE13C3411E;
        Fri,  3 Jun 2022 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654281013;
        bh=2WWPirMtJEQad0WrllwBwe0e+esqegyEkmVUAEx8SkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FAQk13VM/spdQMtvQ9gh4NJDXLHc7R6+9QysSWxYJkIbDaNExQQXZqDIg9us9U8i0
         ZELe06fy0pnftEmWhlVzbevdEj0JKHIDi51CguJPRAmbZ7M5jutp7pCngWKllD5hz9
         1FCFwc7jRaBHae7n3XSRhZ82EO2kw4gUEVEDG7hGDoLiKRqYQZBBUE6HVv4H5wvseq
         MiD+oEwkMfhcLktTvyfpKn9ZZ97xTNV9fZFMRv5+1a6jTv8F0qt5In6BikJIAa3uFE
         yzrKP0Uac09DOWUPOG6nOZz02PfcZVYavrUo1fLK7GWWzWHmldIVuoeUNiqKQ6Qvm0
         F7Mw94P5OBB+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53246F03953;
        Fri,  3 Jun 2022 18:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165428101333.23591.13242354654538988127.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Jun 2022 18:30:13 +0000
References: <20220603055156.2830463-1-irogers@google.com>
In-Reply-To: <20220603055156.2830463-1-irogers@google.com>
To:     Ian Rogers <irogers@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, chiyuze@google.com
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu,  2 Jun 2022 22:51:56 -0700 you wrote:
> From: Yuze Chi <chiyuze@google.com>
> 
> Move the correct definition from linker.c into libbpf_internal.h.
> 
> Reported-by: Yuze Chi <chiyuze@google.com>
> Signed-off-by: Yuze Chi <chiyuze@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> 
> [...]

Here is the summary with links:
  - [v2] libbpf: Fix is_pow_of_2
    https://git.kernel.org/bpf/bpf-next/c/f913ad6559e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


