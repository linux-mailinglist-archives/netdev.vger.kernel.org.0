Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2086EACF1
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjDUOac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjDUOab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:30:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6984C4208;
        Fri, 21 Apr 2023 07:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB00865115;
        Fri, 21 Apr 2023 14:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E132C4339E;
        Fri, 21 Apr 2023 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682087420;
        bh=XkSRCl4pm8QYQSm1T8SDW1cOijVfZ0Oc2M42i7GWBqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t5+mg9REPnhTsXNHxfcogMlcc9a5OW7+SivUAVpyWGNsoUOdHPXHoBEFFi+E1YjtZ
         d7+Jpl0aOGAdyP2sCcQvLIe4/8h4bxY/BlWfKODM6L1GGFhP/Xoomb0SavIaf/Eq8A
         2xl3trdrkFAHuw6qtBx/0qWxmMqtdfB61XI83FCu1+e59KOYeyBkUWmU7jmE40BER5
         /i8tU10YV5mjKYze+Aux46nkDljrZbwY2dGYheRShwlGswA/MCNO5LW4VF+exYxDx6
         KYYD+FrV9RmguII3lJw9pJTWtopjvVBmAhNICi1ILKBz8Fqjk1Ur4W/J3Nwgmo8Hb6
         pkvuTqSSX1qNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 326D7C561EE;
        Fri, 21 Apr 2023 14:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix race between btf_put and btf_idr walk.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168208742020.30048.9386706017347251927.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 14:30:20 +0000
References: <20230421014901.70908-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230421014901.70908-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, fw@strlen.de, eddyz87@gmail.com,
        davemarchevsky@meta.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 20 Apr 2023 18:49:01 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Florian and Eduard reported hard dead lock:
> [   58.433327]  _raw_spin_lock_irqsave+0x40/0x50
> [   58.433334]  btf_put+0x43/0x90
> [   58.433338]  bpf_find_btf_id+0x157/0x240
> [   58.433353]  btf_parse_fields+0x921/0x11c0
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Fix race between btf_put and btf_idr walk.
    https://git.kernel.org/bpf/bpf-next/c/acf1c3d68e9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


