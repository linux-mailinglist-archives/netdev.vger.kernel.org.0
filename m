Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A286C9254
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 06:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbjCZEMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 00:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjCZEMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 00:12:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BCB9774;
        Sat, 25 Mar 2023 21:12:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6EA3B80BAB;
        Sun, 26 Mar 2023 04:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C7AFC433D2;
        Sun, 26 Mar 2023 04:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679803920;
        bh=PncSrmbcmz49hHMa5NRYH4QsbQdvTiliipMo2fffMMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R2CcU1XgBQOEFxqqV+AZXHPZd4CLDu/22uevHBg5jbnNZzf9UtSosDS0JOPF2lTWx
         NAkrEG3glF0TQ6QfrkxwqTUZuoh9dhYxDU9EI75e2Vo/g19spF5tsm73BXf4r1HFO1
         EUNkyZdWW9S4lj6PkbUahqlUB7NRubQVtKKZiWlyI04dfhcZG0PrztzHIRtalvbDia
         G7QERC3t60KX6pSakP5Q/imAzQlLXoQXGkaShljmGbj3ojPPo6xXgLKIr7GbVsxTGH
         MjUcM+4EtDvUPJMDh8szUMGNtSqiWtxnQaZmYKng9/EpQFFxxj71+9IOJU5JB6dfKT
         olhBukhu+caZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E819DE43EFD;
        Sun, 26 Mar 2023 04:11:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V4] xsk: allow remap of fill and/or completion rings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167980391993.14901.17617558767037665298.git-patchwork-notify@kernel.org>
Date:   Sun, 26 Mar 2023 04:11:59 +0000
References: <20230324100222.13434-1-nunog@fr24.com>
In-Reply-To: <20230324100222.13434-1-nunog@fr24.com>
To:     =?utf-8?q?Nuno_Gon=C3=A7alves_=3Cnunog=40fr24=2Ecom=3E?=@ci.codeaurora.org
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, brauner@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 24 Mar 2023 10:02:22 +0000 you wrote:
> The remap of fill and completion rings was frowned upon as they
> control the usage of UMEM which does not support concurrent use.
> At the same time this would disallow the remap of these rings
> into another process.
> 
> A possible use case is that the user wants to transfer the socket/
> UMEM ownership to another process (via SYS_pidfd_getfd) and so
> would need to also remap these rings.
> 
> [...]

Here is the summary with links:
  - [bpf-next,V4] xsk: allow remap of fill and/or completion rings
    https://git.kernel.org/bpf/bpf-next/c/5f5a7d8d8bd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


