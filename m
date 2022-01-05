Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC0485981
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbiAETvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:51:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60332 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243742AbiAETuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13BE1B81D82;
        Wed,  5 Jan 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3945C36AE0;
        Wed,  5 Jan 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641412209;
        bh=bAxPBa049uOz/Ur5g0BCKPwJ/GwHldu6X84fAeTxzvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R2aYC4cU31jUQl2b+lAiQUmSNu9QVdNU/fkDnAhn5oG7VQ94Nj7W2Vo7kkm/RGbfE
         fw1PPgh1H0dT6sjNuFtcfaA7+/Chewbz+iCW0jLdz+zOWVhSFj+N8Y20xx6VKRS0+1
         Wb0WXgNfSWlD0sbiBwPPoiGHRJ3Tm4eMbQEyEBkb41X7D1gUNlx3BPY9APgdZaerdY
         DGCou3+BXXjR/AXyteSTwHsHSmgi6LVYrOYxTBOpfHMBaLPoLyo+ItgPyWVrUrRIRK
         cY+PZWD6aSRhgaN11sYNgjaUxef0F7ROJtrrR8BPu/JnumIivbqPgdnC5PVBH3UQsk
         g5Upp//ItA9LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9078F7940B;
        Wed,  5 Jan 2022 19:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 sockmap: fix double bpf_prog_put on error case in map_link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164141220975.28548.12480548960134714730.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 19:50:09 +0000
References: <20220104214645.290900-1-john.fastabend@gmail.com>
In-Reply-To: <20220104214645.290900-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, joamaki@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  4 Jan 2022 13:46:45 -0800 you wrote:
> sock_map_link() is called to update a sockmap entry with a sk. But, if the
> sock_map_init_proto() call fails then we return an error to the map_update
> op against the sockmap. In the error path though we need to cleanup psock
> and dec the refcnt on any programs associated with the map, because we
> refcnt them early in the update process to ensure they are pinned for the
> psock. (This avoids a race where user deletes programs while also updating
> the map with new socks.)
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf, sockmap: fix double bpf_prog_put on error case in map_link
    https://git.kernel.org/bpf/bpf-next/c/218d747a4142

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


