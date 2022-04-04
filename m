Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382524F0D6E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376868AbiDDBcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDBcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849742CE1E;
        Sun,  3 Apr 2022 18:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E152CB801B8;
        Mon,  4 Apr 2022 01:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9183DC340F0;
        Mon,  4 Apr 2022 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649035811;
        bh=cchmOcpQSMM6YXLo3nclOq49DjPa7jtMaWZG7HiWitM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hXsndN2961BIOEZY4UroZBn14ghnjjrusT6FahLft5i+DumTIGSdnM0I8723qkWLC
         ir+54vHN/iTpIFG2lo6gqBBOqxteefa1Axuos3pYh+q9aZaFJ31CCCDyMRZ8yC2BaG
         yvRCrbacD7XlrHaWOQwET0gNOWBKEYwVuQvsENl7jonN9BFuxvf85pEtpFOXhiWiiA
         dQntl1gIKR08XpYipg6j9Amg+RtPzW+MJkAmnfBh4Jat/eqrg5nH6jtUzLQziRR+z6
         QOkVHgDX2BPSW8duJRG7GB7ILpfMcaW/m1HxASvE5z7JwhHLQY8AY3TsvCjCUbIQky
         /ELdWe6sTlOFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75CF0E4A6CB;
        Mon,  4 Apr 2022 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] libbpf: Don't return -EINVAL if hdr_len <
 offsetofend(core_relo_len)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164903581147.16822.5070536140817711487.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 01:30:11 +0000
References: <20220404005320.1723055-1-ytcoode@gmail.com>
In-Reply-To: <20220404005320.1723055-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     andrii.nakryiko@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, toke@redhat.com, yhs@fb.com
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
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  4 Apr 2022 08:53:20 +0800 you wrote:
> Since core relos is an optional part of the .BTF.ext ELF section, we should
> skip parsing it instead of returning -EINVAL if header size is less than
> offsetofend(struct btf_ext_header, core_relo_len).
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
> v1 -> v2: skip core relos if hdr_len < offsetofend(core_relo_len)
> v2 -> v3: fix comment style
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] libbpf: Don't return -EINVAL if hdr_len < offsetofend(core_relo_len)
    https://git.kernel.org/bpf/bpf-next/c/a6a86da847eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


