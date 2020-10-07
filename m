Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1F2856FE
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 05:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJGDUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 23:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgJGDUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 23:20:03 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602040803;
        bh=TT5caF9gGI6wlMJur5sjzmW/xz0aSwdngqyuB+7s92A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DaBOOpu3HVKe4QF7mSoGAM820SRA5Pt6kbtAWO5nKbUISr1Zsiofb7gTsbsuWMuob
         7hzEl0RHVu5YETXwhFjddyUgHpu/+Hsi4h6QHTycxqq/ZyyefNXsxVh2EN6ZgSnX2D
         VZWrZB+FIcwGSsJq3ghSjwm3Pi0bblXOc0c2nUsg=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] selftests/bpf: Fix test_verifier after introducing
 resolve_pseudo_ldimm64
From:   patchwork-bot+bpf@kernel.org
Message-Id: <160204080334.2587.12222243524671170166.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Oct 2020 03:20:03 +0000
References: <20201007022857.2791884-1-haoluo@google.com>
In-Reply-To: <20201007022857.2791884-1-haoluo@google.com>
To:     Hao Luo <haoluo@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  6 Oct 2020 19:28:57 -0700 you wrote:
> Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
> the order of check_subprogs() and resolve_pseudo_ldimm() in
> the verifier. Now an empty prog expects to see the error "last
> insn is not an the prog of a single invalid ldimm exit or jmp"
> instead, because the check for subprogs comes first. It's now
> pointless to validate that half of ldimm64 won't be the last
> instruction.
> 
> [...]

Here is the summary with links:
  - [v3] selftests/bpf: Fix test_verifier after introducing resolve_pseudo_ldimm64
    https://git.kernel.org/bpf/bpf-next/c/bf88a80a0407

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


