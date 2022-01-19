Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DACE4933DC
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 05:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351449AbiASEAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 23:00:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34652 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344750AbiASEAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 23:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 237A861583;
        Wed, 19 Jan 2022 04:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 820DDC340E6;
        Wed, 19 Jan 2022 04:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642564810;
        bh=bsRL8UPBABskV1NUeV3b9gvLs8XSeLPjs+M2ng1wojM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=THr95Miuj6V5GTX8H5gK9hWK+kg2f80tRnLGyofB1BcNEE5RMqdj33UV3yVn/cLlY
         Acd58iDEzh+B3dmMtALDeirdzrE96YGV/87kbhe1/P5jXhcjvDr+g389D1luJTL4ZY
         NNCZodsALHcP8Ykhvy3SCDlIYwGRwu8na1Seza4EFMy/wiEjzh9ih8EE6pk+tD93f5
         XLp4vNIwe8q9r+IUZ0EV5KNoEp5SYjMFfmtRpArJWDHZCjNH9jQj3h6/MO8DPEf56b
         rr/8SOiyclaNYsiCtb3seTtxtb++mV0pgW8evGk10Dlgb9xOkt7LgS5WpxSylnBoMr
         74m66jvee9MLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6AF05F6079B;
        Wed, 19 Jan 2022 04:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] libbpf: define BTF_KIND_* constants in btf.h to avoid
 compilation errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164256481043.833.159060725359078687.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Jan 2022 04:00:10 +0000
References: <20220118141327.34231-1-toke@redhat.com>
In-Reply-To: <20220118141327.34231-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 18 Jan 2022 15:13:27 +0100 you wrote:
> The btf.h header included with libbpf contains inline helper functions to
> check for various BTF kinds. These helpers directly reference the
> BTF_KIND_* constants defined in the kernel header, and because the header
> file is included in user applications, this happens in the user application
> compile units.
> 
> This presents a problem if a user application is compiled on a system with
> older kernel headers because the constants are not available. To avoid
> this, add #defines of the constants directly in btf.h before using them.
> 
> [...]

Here is the summary with links:
  - [bpf] libbpf: define BTF_KIND_* constants in btf.h to avoid compilation errors
    https://git.kernel.org/bpf/bpf-next/c/eaa266d83a37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


