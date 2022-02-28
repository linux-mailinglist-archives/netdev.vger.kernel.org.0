Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB9A4C7E83
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 00:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiB1Xkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 18:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiB1Xkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 18:40:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8912EB53;
        Mon, 28 Feb 2022 15:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DD70CE18F6;
        Mon, 28 Feb 2022 23:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6C7FC340F1;
        Mon, 28 Feb 2022 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646091609;
        bh=KYjxY1UtUlxytahQl/GTKs0PeixkvM2dMA2VBn6Njs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CJaMj+8yhGv/MiJCpbsIA0PEPU143DuKLYBiOBvBw6W7ygfiIOGcg3zUXdwM9HZkp
         jpvhWXtIq8zEVOopE+XV99fdy97RA8/UAtBFEFnIgbKT7tVYkM10MxehrzKZPFQgX4
         7dlzMOTzrIn/KETe2dO/BNBx1vedSFT+AR1AYT3ci3WHplqtwgHtm9Srm6IsjTWDVt
         ZqvfdjM4AlQ+R7aYZdtrDCfvqgtgOIPFvtA7SS4ouChaGYS7cfu/8xpTBSHHJcRq8e
         S4QmxIuk7hqZyvDcKd+GkPsq3YtFC3BEIETOM/va5L0z8OHsc5GxF/xPZMfVWo1d9I
         E9ted5EXslHiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 962D6E6D4BB;
        Mon, 28 Feb 2022 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/2] Modify BPF_JIT_ALWAYS_ON and
 BPF_JIT_DEFAULT_ON
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164609160961.29256.14375573252999533886.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 23:40:09 +0000
References: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        lixuefeng@loongson.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 22 Feb 2022 17:57:04 +0800 you wrote:
> v3:
>   -- Use "return failure" instead of "return in failure".
>   -- Use "Enable BPF JIT by default" for config BPF_JIT_DEFAULT_ON.
> 
> v2:
>   -- Use the full path /proc/sys/net/core/bpf_jit_enable in the help text.
>   -- Update the commit message to make it clear in patch #2.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/2] bpf: Add some description about BPF_JIT_ALWAYS_ON in Kconfig
    https://git.kernel.org/bpf/bpf-next/c/b664e255ba3c
  - [bpf-next,v3,2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable in Kconfig
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


