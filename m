Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17D643D70
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiLFHKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLFHKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40627E00F;
        Mon,  5 Dec 2022 23:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB1E614A8;
        Tue,  6 Dec 2022 07:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10BBBC433C1;
        Tue,  6 Dec 2022 07:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670310617;
        bh=hsEA/fB6VIyC3Wm5z/cc41AOVcPc9FbmrqahCWlyALw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jlzcs1ZHHeBGU4D/KJxDCP/8gyer4A74U+/9MQcpqTlWjbLJTnRLIUDBOI2ynfTg5
         qpw61plYLgUXIqF2D+T5R8CGvtxdHoQk5Hqn1crp45FWuuKf4f5aFo5PQfZUof+Nzg
         AOHt51Xi4dZpnHFcuGoeuPKoM1lel5J5n2qh9WvfZnAN2d4qDj9Lo4Zx8Aqko7EpxE
         gywULrq33fo9A1aQnwuheuCDkZ3Xrz6/aiGOdJtcMKnPS/iL9I/m2rf2tB6AaLERe6
         ihn0wh3w4I1woipL9Rc0NSPy2evuhtzHz6BNSvL4O29djkHJtQ3gXIgdAjs0uqdQnB
         MqAf/HkTKbXWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC6C9E21EFD;
        Tue,  6 Dec 2022 07:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next,v6 0/4] xfrm: interface: Add unstable helpers for
 XFRM metadata
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167031061689.3006.16415663365727591503.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 07:10:16 +0000
References: <20221203084659.1837829-1-eyal.birger@gmail.com>
In-Reply-To: <20221203084659.1837829-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com, jtoppins@redhat.com,
        kuniyu@amazon.co.jp, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Sat,  3 Dec 2022 10:46:55 +0200 you wrote:
> This patch series adds xfrm metadata helpers using the unstable kfunc
> call interface for the TC-BPF hooks.
> 
> This allows steering traffic towards different IPsec connections based
> on logic implemented in bpf programs.
> 
> The helpers are integrated into the xfrm_interface module. For this
> purpose the main functionality of this module is moved to
> xfrm_interface_core.c.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v6,1/4] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
    https://git.kernel.org/bpf/bpf-next/c/ee9a113ab634
  - [bpf-next,v6,2/4] xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
    https://git.kernel.org/bpf/bpf-next/c/94151f5aa966
  - [bpf-next,v6,3/4] tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
    https://git.kernel.org/bpf/bpf-next/c/4f4ac4d9106e
  - [bpf-next,v6,4/4] selftests/bpf: add xfrm_info tests
    https://git.kernel.org/bpf/bpf-next/c/90a3a05eb33f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


