Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907F94F0D67
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376846AbiDDBWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDBWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:22:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE9633A0E;
        Sun,  3 Apr 2022 18:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BCDF61001;
        Mon,  4 Apr 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6FA2C340F3;
        Mon,  4 Apr 2022 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649035212;
        bh=AeDKhnnOqwI+C0jBBOqenu2X+lrbbXvPdfTmvH/Vyfw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QBfO/nxaIjiYJcUcEIytR7PMVYWCtVMld6tpmOV+5R3JudkYa2ESylgW2ddg8rEgF
         P4agG9zDMC2ysvGbQhSLNx0mtITtCXtWdmafKk26ynQJYOqQpEZdWIwv2gwvQznd4E
         soX5qRoAp6GbIP0p97Hr3XiW0sbdvjiYFjxF2xdTQtUlWkWL1eIRVqp10U+DG6guO1
         EY80t7T36aOJOfFjffGtar6OuPGW+5ulfeTIwTbzR1/oz2eSGeGGGfzOPrxfIGLhsd
         mQ7MyGvDwVX0vh1kZwueYGMkKTGjZbXzfyBRUlyDQjwEJF3FnNu/Z5V4HQ8hDJ9xoZ
         6Qzc+98GwVQJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB555E85CC2;
        Mon,  4 Apr 2022 01:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 bpf-next 0/5] libbpf: name-based u[ret]probe attach
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164903521182.13106.12656654142629368774.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 01:20:11 +0000
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Wed, 30 Mar 2022 16:26:35 +0100 you wrote:
> This patch series focuses on supporting name-based attach - similar
> to that supported for kprobes - for uprobe BPF programs.
> 
> Currently attach for such probes is done by determining the offset
> manually, so the aim is to try and mimic the simplicity of kprobe
> attach, making use of uprobe opts to specify a name string.
> Patch 1 supports expansion of the binary_path argument used for
> bpf_program__attach_uprobe_opts(), allowing it to determine paths
> for programs and shared objects automatically, allowing for
> specification of "libc.so.6" rather than the full path
> "/usr/lib64/libc.so.6".
> 
> [...]

Here is the summary with links:
  - [v5,bpf-next,1/5] libbpf: bpf_program__attach_uprobe_opts() should determine paths for programs/libraries where possible
    https://git.kernel.org/bpf/bpf-next/c/1ce3a60e3c28
  - [v5,bpf-next,2/5] libbpf: support function name-based attach uprobes
    https://git.kernel.org/bpf/bpf-next/c/433966e3ae04
  - [v5,bpf-next,3/5] libbpf: add auto-attach for uprobes based on section name
    https://git.kernel.org/bpf/bpf-next/c/7825470420d1
  - [v5,bpf-next,4/5] selftests/bpf: add tests for u[ret]probe attach by name
    https://git.kernel.org/bpf/bpf-next/c/5bc2f0c51181
  - [v5,bpf-next,5/5] selftests/bpf: add tests for uprobe auto-attach via skeleton
    https://git.kernel.org/bpf/bpf-next/c/948ef31c4cd9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


