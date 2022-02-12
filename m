Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08DC4B363A
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 17:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbiBLQKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 11:10:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiBLQKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 11:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06745B9;
        Sat, 12 Feb 2022 08:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92FE360FB8;
        Sat, 12 Feb 2022 16:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBA40C340EE;
        Sat, 12 Feb 2022 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644682209;
        bh=xgXe8qTCczn3VGYBy5Q25EbQlPSwyzfKjkpPvCN4rHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GlKcE1fLsk9Vk7tEiuCjgNlfLA/7R+FvVIDR3aBR72/RHoWVgcru7O9v1K7d9Eiwn
         cLpZ+Cv6sxlVbxp1ysQGI74tphXACGRNroiy8RqTW6IhdPCnOmQwYP/Ea+58cZh2s4
         ZKW3yD2xSdE2uPZqmFVMW614uO+ViNgdvHhBq8lawWArPy3S5clHKFrq2JTb05twus
         cVpIFrQ1wGLFZFzGi3p+4G9RW45+vf7cWFvskaUtJLfvXNA219R8CHv9H/HJyH+7Ae
         dwH8D0cBaYbxPArdLt3YCv5IUae7Vmwb+Ruaqj1Q45Juoz14DH4LUxX0xa1ssCYEuA
         Eh7rimLuhClrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D60CAE5D07D;
        Sat, 12 Feb 2022 16:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] libbpf: Use dynamically allocated buffer when
 receiving netlink messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164468220887.25180.6029344474834771929.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Feb 2022 16:10:08 +0000
References: <20220211234819.612288-1-toke@redhat.com>
In-Reply-To: <20220211234819.612288-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, memxor@gmail.com,
        zhguan@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Sat, 12 Feb 2022 00:48:19 +0100 you wrote:
> When receiving netlink messages, libbpf was using a statically allocated
> stack buffer of 4k bytes. This happened to work fine on systems with a 4k
> page size, but on systems with larger page sizes it can lead to truncated
> messages. The user-visible impact of this was that libbpf would insist no
> XDP program was attached to some interfaces because that bit of the netlink
> message got chopped off.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] libbpf: Use dynamically allocated buffer when receiving netlink messages
    https://git.kernel.org/bpf/bpf-next/c/9c3de619e13e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


