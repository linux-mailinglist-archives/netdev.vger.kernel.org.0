Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAAB58DC71
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245008AbiHIQuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243173AbiHIQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328422605;
        Tue,  9 Aug 2022 09:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C175C60BC5;
        Tue,  9 Aug 2022 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22FCEC433B5;
        Tue,  9 Aug 2022 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660063814;
        bh=BPQSBqEaQVzFpZHDlwohZzsm0tw/oJ4LWmWRpVos5IM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IAOoCZs07cjAlr8jyRSeGEVSmew3TyUJytSv4FfbPWVc44dCy8W8JsPmMfk1P+q6Q
         61u2/pdgyc6vg3MeNY0pEfttufH3+IZ3Cctc2eO+LXavqNAro5v2kBfAsmlr8Fc+Vx
         WkCeS8OiOGBBAKR8/wiBXwlvZPEcmiwNPPPdYEmuazZgDHD1QuphTwv1ZhoIOGD0aP
         +60kWA1niedGEpXaT75yAeEkAjAeTXhPwpIRsTfGJ3DSrrAU1QvDWVm0j8FEvEOPnp
         dRtBh1S1dV7iBwIm5sOpekx+VLNYScLimDmvj2PKk/kYlJK1EiMDK/iSHhZhooBJCl
         6rFwoMTHmGV8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A214C43142;
        Tue,  9 Aug 2022 16:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] net: netfilter: Remove ifdefs for code shared by BPF
 and ctnetlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166006381403.15335.8424596913469962895.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 16:50:14 +0000
References: <20220725085130.11553-1-memxor@gmail.com>
In-Reply-To: <20220725085130.11553-1-memxor@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, pablo@netfilter.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 25 Jul 2022 10:51:30 +0200 you wrote:
> The current ifdefry for code shared by the BPF and ctnetlink side looks
> ugly. As per Pablo's request, simplify this by unconditionally compiling
> in the code. This can be revisited when the shared code between the two
> grows further.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] net: netfilter: Remove ifdefs for code shared by BPF and ctnetlink
    https://git.kernel.org/bpf/bpf-next/c/6e116280b41b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


