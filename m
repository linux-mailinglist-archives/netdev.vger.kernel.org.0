Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DC64B9036
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiBPSa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:30:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiBPSa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD6C295FE3;
        Wed, 16 Feb 2022 10:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 061B2B81FBD;
        Wed, 16 Feb 2022 18:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FC0DC340E8;
        Wed, 16 Feb 2022 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645036211;
        bh=HKP2sjCo/+dYMVn6TO84SRarfIIxItfie5mXnxxrH3c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=urh2qKW8VN6cBhBZ3C5KFifcsARMoNqnmY+Z9Kauu6pDYBYz1DI/0ceJgoIuj9kyM
         SYi8+c666/PISSSq76BSG1w1CSrkaWB/n8kWjrjZAFprN9XGkg3itWMqk5BNgqAkHx
         N1JGDwjrYZe/SzXo6V0E5jCasQOL+Sm3+/5PSLAkv0zm6EjkvG93C2xjmIhmHYI40A
         Qz3w80QlE7oa5TIflZBKIyZJw5YnlXp5McT4yc3Soy8DT/aMXYhjxr4+MCPfH5KUVS
         z/BarFbit1l57gsFGowTJKu2W7DHrHW6CraqlpiQ107WGEdVSOWfTb06gpQ5sKlL7l
         9viaZ2G6rXgGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BCFFE6D447;
        Wed, 16 Feb 2022 18:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v7 0/7] libbpf: Implement BTFGen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164503621150.2935.6634904664671748900.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Feb 2022 18:30:11 +0000
References: <20220215225856.671072-1-mauricio@kinvolk.io>
In-Reply-To: <20220215225856.671072-1-mauricio@kinvolk.io>
To:     =?utf-8?q?Mauricio_V=C3=A1squez_=3Cmauricio=40kinvolk=2Eio=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, quentin@isovalent.com,
        rafaeldtinoco@gmail.com, lorenzo.fontana@elastic.co,
        leonardo.didonato@elastic.co
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 15 Feb 2022 17:58:49 -0500 you wrote:
> CO-RE requires to have BTF information describing the kernel types in
> order to perform the relocations. This is usually provided by the kernel
> itself when it's configured with CONFIG_DEBUG_INFO_BTF. However, this
> configuration is not enabled in all the distributions and it's not
> available on kernels before 5.12.
> 
> It's possible to use CO-RE in kernels without CONFIG_DEBUG_INFO_BTF
> support by providing the BTF information from an external source.
> BTFHub[0] contains BTF files to each released kernel not supporting BTF,
> for the most popular distributions.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v7,1/7] libbpf: split bpf_core_apply_relo()
    https://git.kernel.org/bpf/bpf-next/c/adb8fa195efd
  - [bpf-next,v7,2/7] libbpf: Expose bpf_core_{add,free}_cands() to bpftool
    https://git.kernel.org/bpf/bpf-next/c/8de6cae40bce
  - [bpf-next,v7,3/7] bpftool: Add gen min_core_btf command
    https://git.kernel.org/bpf/bpf-next/c/0a9f4a20c615
  - [bpf-next,v7,4/7] bpftool: Implement "gen min_core_btf" logic
    https://git.kernel.org/bpf/bpf-next/c/a9caaba399f9
  - [bpf-next,v7,5/7] bpftool: Implement btfgen_get_btf()
    https://git.kernel.org/bpf/bpf-next/c/dc695516b6f5
  - [bpf-next,v7,6/7] bpftool: gen min_core_btf explanation and examples
    https://git.kernel.org/bpf/bpf-next/c/1d1ffbf7f0b2
  - [bpf-next,v7,7/7] selftests/bpf: Test "bpftool gen min_core_btf"
    https://git.kernel.org/bpf/bpf-next/c/704c91e59fe0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


