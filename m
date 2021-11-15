Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6426450CDD
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhKORok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238535AbhKORlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 38D94632F6;
        Mon, 15 Nov 2021 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636997233;
        bh=DTMdIMHyWh2Eh+YLVzW/EpbqPbssKK+n7c5025oioHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LZaB9NmICvcPW9vprQOetM70QfLXQvoEnlpgYA6HQk6tIMi80H+san2G3YVC30meq
         W2QE6cJlKANpZZCSIMb3h6L70WhFJ8SP9oG8nAqNl3omagbxSn3SS4jxAcq6yQdywv
         JxLk+u5rRYi19Jv01tTPSFsACa8O2QzOS9hhsJj5P2cBlWbQc+pjuZjHf6KVH9WgVB
         Jy2LeBipMDcBE26Hj2Pb06bHyfUbxtIyf9i2BPQ3pJzbTpYc3yagSWQKx+STD8QMar
         25ddbJd+fG1gWwvf+46cj71YK3I/5wTdJLdvQesg0zE65fruzoiA0jAT5DZI6t+xYI
         7b9Pxw34gqGpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2FB8C60A49;
        Mon, 15 Nov 2021 17:27:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2021-11-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163699723319.3295.15019546591268634921.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 17:27:13 +0000
References: <20211115162008.25916-1-daniel@iogearbox.net>
In-Reply-To: <20211115162008.25916-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, quentin@isovalent.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 17:20:08 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> There are two merge conflicts in tools/bpf/bpftool/Makefile due to commit
> e41ac2020bca ("bpftool: Install libbpf headers for the bootstrap version, too")
> from bpf tree and commit 6501182c08f7 ("bpftool: Normalize compile rules to
> specify output file last") from bpf-next tree. Resolve as follows:
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2021-11-15
    https://git.kernel.org/netdev/net-next/c/a5bdc36354cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


