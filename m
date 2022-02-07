Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F834ACA54
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 21:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbiBGUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 15:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiBGUUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 15:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9350FC0401E1;
        Mon,  7 Feb 2022 12:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 221CD61528;
        Mon,  7 Feb 2022 20:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F8A2C340EE;
        Mon,  7 Feb 2022 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644265209;
        bh=BBEBnletFD20aH/opeooHKsu6fGgsTHw4+9SGllHqJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VSF2r9Bm/3pAZO3U27j9udAsiE/tfnCT2UQOb0zU0pujeIH5oaS4hw3CnXGcyzCtM
         zjYaKGQA4B7EnXqz7iKwbrWQ++g3A+IIeLGWI30r2PGPvxLrE2pBWFTgq0TsW7+HLM
         9FDkcw0wDEgT1/wiC8FbOh8ruerjvog5x8sSEMbrAj/Y1QB1kC5aTJ7l0g5rPWrAZF
         fyqmVuJrm4lScSL6j8O3ZcS35A/Zn2rQuz0ltKfifoAKs5D9B6vy2Ycuw3ZSHNYKhs
         2/LYZJGVDXrj1d2m3STWPGjOKyAiOVUzCXjrCzAOhLxV4KrsiHfsdCnkeqzNq0SqXk
         OsZiMB7WSvrcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63151E6BB3D;
        Mon,  7 Feb 2022 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/3] bpf: Fix strict mode calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164426520940.21464.8742032555307635242.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 20:20:09 +0000
References: <20220207145052.124421-1-mauricio@kinvolk.io>
In-Reply-To: <20220207145052.124421-1-mauricio@kinvolk.io>
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

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  7 Feb 2022 09:50:49 -0500 you wrote:
> This series fixes a bad calculation of strict mode in two places. It
> also updates libbpf to make it easier for the users to disable a
> specific LIBBPF_STRICT_* flag.
> 
> v1 -> v2:
> - remove check in libbpf_set_strict_mode()
> - split in different commits
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/3] libbpf: Remove mode check in libbpf_set_strict_mode()
    https://git.kernel.org/bpf/bpf-next/c/e4e835c87bb5
  - [bpf-next,v2,2/3] bpftool: Fix strict mode calculation
    https://git.kernel.org/bpf/bpf-next/c/da7af0aa20f8
  - [bpf-next,v2,3/3] selftests/bpf: Fix strict mode calculation
    https://git.kernel.org/bpf/bpf-next/c/2b9e2eadc9c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


