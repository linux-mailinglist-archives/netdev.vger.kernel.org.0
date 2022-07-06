Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D75567D58
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 06:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiGFEaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 00:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGFEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 00:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6ED140E7;
        Tue,  5 Jul 2022 21:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2415B81A9A;
        Wed,  6 Jul 2022 04:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AD96C341C0;
        Wed,  6 Jul 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657081813;
        bh=FGEEZrb2xTh3uxTizyT6EEiCp07oJKdzwj03rMRpVNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jjn73Zir5hPmar3E7IktgS5mQM0/P1AWqyOV1kJHIKw1MLXe2nkzexpX9vNsAkBrq
         8pBmnpXYqEbhpMX57clytjSKk0ou9SB0V9nG22eC8uKXu4SFzqZ7sDzgaorBkMXahj
         fsGWmOhX0ZGWMN8Kc6rIMTH6cXjkbs9SCiSc5+JS3KjVb0Qz8sC/2cffYeGpdbT/J6
         N7Q2/T3BdgohTJnZGtEXD6W5yQrwxTfk24/uQEC8kjYRV/0z/dsVGULUmsPXKRkkKM
         qQWeVQEDPHqZgrx6azDrHYXbBU7e5YbmbjDIKydmDvLdooH6TFXJSklxil1yo6cxZZ
         Ce/spPSnbjG+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BEE6E45BD8;
        Wed,  6 Jul 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/3] cleanup the legacy probe_event on failed scenario
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165708181330.8854.12108796366589319716.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 04:30:13 +0000
References: <20220629151848.65587-1-nashuiliang@gmail.com>
In-Reply-To: <20220629151848.65587-1-nashuiliang@gmail.com>
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 29 Jun 2022 23:18:44 +0800 you wrote:
> A potential scenario, when an error is returned after
> add_uprobe_event_legacy() in perf_event_uprobe_open_legacy(), or
> bpf_program__attach_perf_event_opts() in
> bpf_program__attach_uprobe_opts() returns an error, the uprobe_event
> that was previously created is not cleaned.
> 
> At the same time, the legacy kprobe_event also have similar problems.
> 
> [...]

Here is the summary with links:
  - [v4,1/3] libbpf: cleanup the legacy kprobe_event on failed add/attach_event()
    https://git.kernel.org/bpf/bpf-next/c/8094029330a2
  - [v4,2/3] libbpf: fix wrong variable used in perf_event_uprobe_open_legacy()
    https://git.kernel.org/bpf/bpf-next/c/5666fc997ccb
  - [v4,3/3] libbpf: cleanup the legacy uprobe_event on failed add/attach_event()
    https://git.kernel.org/bpf/bpf-next/c/2655144fb49b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


