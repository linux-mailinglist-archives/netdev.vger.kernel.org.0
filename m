Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8B046596A
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353658AbhLAWne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:43:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50098 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343789AbhLAWne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 17:43:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46A77CE2124;
        Wed,  1 Dec 2021 22:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B0D7C53FCD;
        Wed,  1 Dec 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638398409;
        bh=iyRImMWZKjUPoVSXAV6vr3E3Dmt7P+9dd3G2itpMK1c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nOLrfWXT75rfBo/3YqE6EQOgRsODZ0llueA7sg7Fx6q6NjSBZ54wjmUsmfMopr/GU
         qW/V1zL36XhUxOkFwrqQB6x78N/cCpCHGfDaWdLricOt8A6eVOcnBeMtfgE78mv6uA
         q2e2FVVzvECzk7AAvkbMaCLMBNOq4zd09EGof8aG1WM5lvW6QJo2b0385YmCNap4sD
         amm6czZYh+QgsGThuMqTl/E+fF802sS4OIyMPnDA6Znm8W5GPEr7hEAQlGeMU1ABCt
         SBJmogXq3eLFu5yWM10iRpE6WdBykBMIbMFE97ho7Gr/rLtmWsdSvxC1vuSFujD7J9
         zDEDQ+G9snxvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17B0960A4D;
        Wed,  1 Dec 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples: bpf: fix conflicting types in fds_example
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163839840909.19475.13073469862545446268.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 22:40:09 +0000
References: <20211201164931.47357-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211201164931.47357-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        michal.swiatkowski@linux.intel.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed,  1 Dec 2021 17:49:31 +0100 you wrote:
> Fix the following samples/bpf build error appeared after the
> introduction of bpf_map_create() in libbpf:
> 
>   CC  samples/bpf/fds_example.o
> samples/bpf/fds_example.c:49:12: error: static declaration of 'bpf_map_create' follows non-static declaration
> static int bpf_map_create(void)
>            ^
> samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: previous declaration is here
> LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>                ^
> samples/bpf/fds_example.c:82:23: error: too few arguments to function call, expected 6, have 0
>                 fd = bpf_map_create();
>                      ~~~~~~~~~~~~~~ ^
> samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: 'bpf_map_create' declared here
> LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>                ^
> 2 errors generated.
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples: bpf: fix conflicting types in fds_example
    https://git.kernel.org/bpf/bpf-next/c/64b5b97b8cff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


