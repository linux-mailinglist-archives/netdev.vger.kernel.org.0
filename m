Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70906567DEF
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiGFFkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiGFFkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744E3DE9D;
        Tue,  5 Jul 2022 22:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D3DFB81AEA;
        Wed,  6 Jul 2022 05:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB97DC341C0;
        Wed,  6 Jul 2022 05:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657086012;
        bh=KPf4J4TWTPb/x6HKgioSdacKs6eg9D3daAR+5mlOAqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CHHmIjYBaxq5alGMvrxaTGLXNJ2IJueabGCvfdUhRrLGpgvNCXOhBX40Th57BB5mn
         atJ9cg6o1GUrqe4UKTnz+fhXQbHUSTZLBu+9SEtQmyXOaH46wevApUUPFdEVB7SDut
         PGlga0qWJuWvhA3j3VkLRwQxWGw6huhhvoxbB4z/+Y42Q9/VtsT1sP8Gz/vdqqHzyL
         aPT8nMW22X5s3vtHXQ6mwAwXUFEupjTnYyegRiXttmzYaeV1W4M+rt5zX4ElLFpkAs
         CP7+vGR7zelTGOcVUA+R6ThYhWsj9MC3ogf659OPkDp1RTwWJKQ697wO45CjXoxYkz
         6SY2kCMPHMApQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A09D9E45BDD;
        Wed,  6 Jul 2022 05:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpftool: Remove zlib feature test from Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165708601265.4885.2077080305152101341.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 05:40:12 +0000
References: <20220705200456.285943-1-quentin@isovalent.com>
In-Reply-To: <20220705200456.285943-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Jul 2022 21:04:56 +0100 you wrote:
> The feature test to detect the availability of zlib in bpftool's
> Makefile does not bring much. The library is not optional: it may or may
> not be required along libbfd for disassembling instructions, but in any
> case it is necessary to build feature.o or even libbpf, on which bpftool
> depends.
> 
> If we remove the feature test, we lose the nicely formatted error
> message, but we get a compiler error about "zlib.h: No such file or
> directory", which is equally informative. Let's get rid of the test.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpftool: Remove zlib feature test from Makefile
    https://git.kernel.org/bpf/bpf-next/c/450a8dcb8c7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


