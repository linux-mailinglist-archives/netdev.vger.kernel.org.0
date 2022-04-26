Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF70510789
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243457AbiDZSx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbiDZSxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A4C1FA60;
        Tue, 26 Apr 2022 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35F55B82108;
        Tue, 26 Apr 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6FC8C385A4;
        Tue, 26 Apr 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999010;
        bh=tU7Oo948QoJpRpeA2LgDIjOFCo0BkIHWMWHmhizqTpQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=owZmcVuKK1jkCLVHj99mz/7HIHxQ0f3kIgFBIpl7vqYqfc4GXuPXarZQhGPp5wNxP
         YL1493V8W8hCGD7jH3yFR6PaIQq2+Z7EhM/jdPRcVUiathE5TbJyyH9n5tqSX6T2EN
         asK6sk+tTrWo8d5fSC4pg7VlH+jm1qRJQlCvbUf9A7Wh2u6GfAqQCnQMikRCUFAA9L
         UTiDX1CIW9GQehmpY+GrJnV9SKfkYsG1JLU2tIrcg3K7w6lc/YthsfqaEh5FDFDCjr
         GLC8JzC+akwASCAaqRmcTUbTIIKrigPr7uOjCvVM7qhkGXcBQgt4u5Fl2ikgtJHgTS
         pAi2e2Qe+z8dg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAB25E8DD85;
        Tue, 26 Apr 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf: compute map_btf_id during build time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165099901069.12299.13361393417050366325.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 18:50:10 +0000
References: <20220425133247.180893-1-imagedong@tencent.com>
In-Reply-To: <20220425133247.180893-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     ast@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, benbjiang@tencent.com,
        flyingpeng@tencent.com, imagedong@tencent.com, edumazet@google.com,
        kafai@fb.com, talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, lkp@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 25 Apr 2022 21:32:47 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> For now, the field 'map_btf_id' in 'struct bpf_map_ops' for all map
> types are computed during vmlinux-btf init:
> 
>   btf_parse_vmlinux() -> btf_vmlinux_map_ids_init()
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf: compute map_btf_id during build time
    https://git.kernel.org/bpf/bpf-next/c/c317ab71facc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


