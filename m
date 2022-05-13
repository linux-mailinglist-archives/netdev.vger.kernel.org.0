Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826BB526D5A
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiEMXKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 19:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiEMXKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 19:10:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6239A2E5D26;
        Fri, 13 May 2022 16:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A31C9CE3364;
        Fri, 13 May 2022 23:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E611C34116;
        Fri, 13 May 2022 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652483412;
        bh=mf+G/+mHUinpjKFNwbx3hKA1taovae3nIXF3F2KgLBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FScNTB+PU5bjchLN6vLZOSZ5ywJT6fVgZBe/CcKzqObIsFj4ki3x0/FCKT7oekYW3
         umkfkJMcsS8P+N49ApVYkgIJaMN3M3kVeFZRiYFmKQAGVYF+/HsZhOFl2hzCqBEviE
         h4WATK6N8TsxA8wUWAzwKfKObB7JECUjpqfU0Sww5n5w3DOn7QTbGoxUUPMI/mDoZN
         MK3Z/0O7L4jIHc0cVkN5POmK1PZU2xtLU8qGUsk5uV2B6coYRAO05cZZD+bTXJqiit
         dGNHoM+SlgvpK1971LDWo3w1s4QLfLhUTCrSR4vtvCNdhFxnhh+7UHeY/pILYH6SsM
         bSMwgi6hMzA5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF9CDE8DBDA;
        Fri, 13 May 2022 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] bpftool: Use sysfs vmlinux when dumping BTF by ID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165248341190.20625.1772461557963999484.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 23:10:11 +0000
References: <20220513121743.12411-1-larysa.zaremba@intel.com>
In-Reply-To: <20220513121743.12411-1-larysa.zaremba@intel.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, maciej.fijalkowski@intel.com,
        alexandr.lobakin@intel.com
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

On Fri, 13 May 2022 14:17:43 +0200 you wrote:
> Currently, dumping almost all BTFs specified by id requires
> using the -B option to pass the base BTF. For kernel module
> BTFs the vmlinux BTF sysfs path should work.
> 
> This patch simplifies dumping by ID usage by loading
> vmlinux BTF from sysfs as base, if base BTF was not specified
> and the ID corresponds to a kernel module BTF.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] bpftool: Use sysfs vmlinux when dumping BTF by ID
    https://git.kernel.org/bpf/bpf-next/c/418fbe82578e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


