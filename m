Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A09848AB3F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 11:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiAKKUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 05:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiAKKUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 05:20:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D96DC06173F;
        Tue, 11 Jan 2022 02:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 271736156D;
        Tue, 11 Jan 2022 10:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EC8CC36AEF;
        Tue, 11 Jan 2022 10:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641896409;
        bh=ttET7FQ/V0zsUisydBM7LitOS1aOOXZYsT15k2wFPqk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mkVfFVLLYmpq3GLa+t2/aoD/dJrMb+omiDR5IdiiHTsbkXEf55/YDGjZF/Zi8vON8
         oWnvD2Q1hlp1Iac2IQZrKox00VtATI4DfmVOyBeubA05YmKwAyVt96phUJCQTQc062
         hoA62dInwA7hG9TWuD5kIf63UNeLVs22u1xYuJcNxp+paQGbmj9QsLUjNJfG25XWfY
         3o5dk42NmSphlyeH9tIXSP1k2dvU+LFjmOp+BtTtcd3cjwI2P4X+NEY/AJsaVip96H
         wnp4f4B8UcjmJ0GY7BLWNmxg58WULHirMdyTkhy2cwo2JJlrCYDoXmWPYhM+lphnZq
         R0VlSTjwd4P3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73BB9F6078C;
        Tue, 11 Jan 2022 10:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bpf: fix mount source show for bpffs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164189640946.3896.14596442788026744490.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Jan 2022 10:20:09 +0000
References: <20220108134623.32467-1-laoar.shao@gmail.com>
In-Reply-To: <20220108134623.32467-1-laoar.shao@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, dhowells@redhat.com,
        viro@zeniv.linux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sat,  8 Jan 2022 13:46:23 +0000 you wrote:
> We noticed our tc ebpf tools can't start after we upgrade our in-house
> kernel version from 4.19 to 5.10. That is because of the behaviour change
> in bpffs caused by commit
> d2935de7e4fd ("vfs: Convert bpf to use the new mount API").
> 
> In our tc ebpf tools, we do strict environment check. If the enrioment is
> not match, we won't allow to start the ebpf progs. One of the check is
> whether bpffs is properly mounted. The mount information of bpffs in
> kernel-4.19 and kernel-5.10 are as follows,
> 
> [...]

Here is the summary with links:
  - [v2] bpf: fix mount source show for bpffs
    https://git.kernel.org/bpf/bpf/c/1e9d74660d4d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


