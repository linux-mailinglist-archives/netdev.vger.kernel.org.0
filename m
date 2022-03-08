Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEABC4D100E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239193AbiCHGVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiCHGVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1533C48C;
        Mon,  7 Mar 2022 22:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E8D4B817A9;
        Tue,  8 Mar 2022 06:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23EEAC340EC;
        Tue,  8 Mar 2022 06:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646720410;
        bh=z0mLQtgL8Ab0y/D5Cd6mptslL8k/wPL5UV0pklakAPo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZE3oS5LxVv4qMDMTFyb1alPDmthaTJopgdzB14hNXHpvM2l1u2nxoIeuEnyTCkZdw
         vPMXjrkho2TevJmAKsHill66zDA1LjJ4IlrPv2Bl/HMy8aR/Bh2nzYA7dsl6fUoqS4
         nITml4CeBWAflfQxtEWi//Jpbr4j91gw9AyaD/+aPQ+XobnKFP3f/KQ4iHOLGjUAbC
         KB0gfWbvmgEoLlLWD6zMdbcrAK7YYlkwW4wCN2Ot+fqKyVDSP58FSAndfJ4jZLh2gz
         zJQqLWbWblviy6QLG4X9ykA8/G+7G03FmvuKJvrIQAA6lioMuZAoIzftE/r2j8meVw
         qGdOnzR4LM7sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08DB6E6D3DD;
        Tue,  8 Mar 2022 06:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: fix array_size.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164672041003.11801.726335828921133595.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 06:20:10 +0000
References: <20220306023426.19324-1-guozhengkui@vivo.com>
In-Reply-To: <20220306023426.19324-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  6 Mar 2022 10:34:26 +0800 you wrote:
> Fix the following coccicheck warning:
> tools/lib/bpf/bpf.c:114:31-32: WARNING: Use ARRAY_SIZE
> tools/lib/bpf/xsk.c:484:34-35: WARNING: Use ARRAY_SIZE
> tools/lib/bpf/xsk.c:485:35-36: WARNING: Use ARRAY_SIZE
> 
> It has been tested with gcc (Debian 8.3.0-6) 8.3.0 on x86_64.
> 
> [...]

Here is the summary with links:
  - libbpf: fix array_size.cocci warning
    https://git.kernel.org/bpf/bpf-next/c/04b6de649e12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


