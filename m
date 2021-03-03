Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774D932B431
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578251AbhCCEjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:39:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352805AbhCCEUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 23:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B124A64E87;
        Wed,  3 Mar 2021 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614745206;
        bh=90ddkU2nE+lTNfzsbBUJ6Xv95pzUpvN1bO6XO94LI2k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=joTkRD79wMum6J8LkWPOoDHdHm3vpYL1l81gIFV3wkLWv55M15BcQqAeJNKFpDCqJ
         eCGQSew2unV91hFB6lpbN0bE5QIEkWgWWcPHMGd8kI/3R+KBUUDETphoBYpKaM78da
         IkN/jLx91qOnrNEdXPrLRm7YyZqJ8GSzBS3J4P0U+xgbJrlmJPYSHMlWSmP1x9jBli
         M4ktXU9ZyMgBY8VF75fLr34mkaPD/C/a1ZlfLotbPzVeqRSN/6qtKZwSxhB7YtyEtp
         bx16EpFsjjPf2nAJLgdhBg71JoPgKfXL7r2lekJTc2awoQGkpy6wiibiTYsgjA/w+y
         JUv0Dvapi1Ptg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A1E04609E7;
        Wed,  3 Mar 2021 04:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] tools/runqslower: allow substituting custom
 vmlinux.h for the build
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161474520665.24993.1081140250035171172.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Mar 2021 04:20:06 +0000
References: <20210303004010.653954-1-andrii@kernel.org>
In-Reply-To: <20210303004010.653954-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 2 Mar 2021 16:40:10 -0800 you wrote:
> Just like was done for bpftool and selftests in ec23eb705620 ("tools/bpftool:
> Allow substituting custom vmlinux.h for the build") and ca4db6389d61
> ("selftests/bpf: Allow substituting custom vmlinux.h for selftests build"),
> allow to provide pre-generated vmlinux.h for runqslower build.
> 
> Cc: Martin Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf-next] tools/runqslower: allow substituting custom vmlinux.h for the build
    https://git.kernel.org/bpf/bpf-next/c/303dcc25b5c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


