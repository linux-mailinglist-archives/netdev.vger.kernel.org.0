Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611AB4EA51B
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiC2CWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiC2CV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:21:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640572E688;
        Mon, 28 Mar 2022 19:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4053B81630;
        Tue, 29 Mar 2022 02:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73DA3C340F3;
        Tue, 29 Mar 2022 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648520412;
        bh=clME269K81/L6wEotDg2ggJAq/udE+aib8Kkkw7lz1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EjprcpiyBQ9X/2bwq/UCI9NrOIlYXdmkN1gDmwgbrQn9fiJg3Y+Z+Ltc0hfEJx1Ui
         3CPWq4V9SdS0DMMl0qu0i1YoFx9o9kUD3q141T8WoiB0lc+2VfypqxeEM9BXsK7kw4
         ovfRPRUGZ8LUarVjQv/i8Fob+nlxsC/2fRd9JiHeG90Tv9zG/KGrzWpZMYXVAEqvEJ
         E9EpFjAzpXvoA5WKWNGC2CJiKqx32gqqk7A6xcWU5hCftrZgHc+tyVm3vPsmi8TDe2
         32a2luTRaQ058wc6ntEmTJ/mW4Wx2rrpa3XR06ExEMoVdYab/GgEQDaxgugvOg3BnY
         xwJQwqyqjrkag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5484EF03846;
        Tue, 29 Mar 2022 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf/bpftool: add unprivileged_bpf_disabled check
 against value of 2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164852041234.3757.60543690338055390.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Mar 2022 02:20:12 +0000
References: <20220322145012.1315376-1-milan@mdaverde.com>
In-Reply-To: <20220322145012.1315376-1-milan@mdaverde.com>
To:     Milan Landaverde <milan@mdaverde.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, paul@isovalent.com,
        niklas.soderlund@corigine.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 22 Mar 2022 10:49:45 -0400 you wrote:
> In [1], we added a kconfig knob that can set
> /proc/sys/kernel/unprivileged_bpf_disabled to 2
> 
> We now check against this value in bpftool feature probe
> 
> [1] https://lore.kernel.org/bpf/74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf/bpftool: add unprivileged_bpf_disabled check against value of 2
    https://git.kernel.org/bpf/bpf/c/8c1b21198551

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


