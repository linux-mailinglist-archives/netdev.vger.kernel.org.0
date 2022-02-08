Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767614ACF0A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbiBHCkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346020AbiBHCkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:40:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444FFC061A73;
        Mon,  7 Feb 2022 18:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE7361467;
        Tue,  8 Feb 2022 02:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 347A3C340ED;
        Tue,  8 Feb 2022 02:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644288009;
        bh=HPhn2NkAb2CG1r2WDNSZ88ot6nNlDKxaq3OQtzYG+Mw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sEkp73zSHcQGhoqECzB9Ixytm4dZKbStIxLS9+TmUlHQd3JcsXh7bS9v+fhbekGz/
         dAeuK0QStf2BzREF98uhX1R2lEsRVh14X5YzyL2ckavt3ccalbTK7bMOzUDy5v5Sgr
         DH6tIYzKpztdGOtKhftPZ5C54uJ/x+6teTzAQgwIIKKAjjHGRBbdjo4LodrJkEtEni
         EEWROJHBckIkNl9pvpbKsNIntfGmuPWpqbwVNdz8Hoi+LDGCJoy8w2Eltki6tDe9EO
         H7bpwmX1R6GuuCTV5DQg/lK/7yBJS3hlkG7TyXf85ByVOwWFPKwN0WHpZPhpI12ktd
         L+VvhGLqH7/7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DF8FE6BB76;
        Tue,  8 Feb 2022 02:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 1/2] bpf: test_run: fix overflow in xdp frags parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164428800911.23844.1146882378173833308.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 02:40:09 +0000
References: <20220204235849.14658-1-sdf@google.com>
In-Reply-To: <20220204235849.14658-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, lorenzo@kernel.org,
        syzkaller@googlegroups.com
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
by Alexei Starovoitov <ast@kernel.org>:

On Fri,  4 Feb 2022 15:58:48 -0800 you wrote:
> When kattr->test.data_size_in > INT_MAX, signed min_t will assign
> negative value to data_len. This negative value then gets passed
> over to copy_from_user where it is converted to (big) unsigned.
> 
> Use unsigned min_t to avoid this overflow.
> 
> usercopy: Kernel memory overwrite attempt detected to wrapped address
> (offset 0, size 18446612140539162846)!
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: test_run: fix overflow in xdp frags parsing
    https://git.kernel.org/bpf/bpf-next/c/9d63b59d1e9d
  - [bpf-next,2/2] bpf: test_run: fix overflow in bpf_test_finish frags parsing
    https://git.kernel.org/bpf/bpf-next/c/5d1e9f437df5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


