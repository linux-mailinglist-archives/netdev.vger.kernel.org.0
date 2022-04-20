Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597B350925E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 23:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382683AbiDTVxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 17:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357179AbiDTVxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 17:53:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E312ED68;
        Wed, 20 Apr 2022 14:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D439619AB;
        Wed, 20 Apr 2022 21:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9924C385A0;
        Wed, 20 Apr 2022 21:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650491427;
        bh=iXZnTDwfhdaJIjjr9+4+vmzTdFXyaxmwHYMkh7DljPQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eh670GpMorCN+/RAEB/aWN7JmpVuLqyACIWD1m96yPOJdbtul2jTRYkglDaxRUOE9
         oD/dlkJNQUb6S+afzNmTGEI5pF6pKd/R26MYPUhV/XxXXwzcOjbarwnKkvWaf81b75
         aJ+VBQmjdNfNqEo2oUAkDpyJ4RDP5KkaOtwrsomlKB6BC6vwkUDnZ9lwVE3S9iWONV
         uzs9JjPPebypeZwZmHeybM1ThRJFX/6vpS72dhGCLmQV4fE5edM7LRdh87IkdxhV1K
         +wrxsHL/a/v0Jd6eNyaSHZ1iL1VPAMejRVovk94hw2J46C1b1H3MU+b2KROZNIzHbR
         V3/ksjQAHHQBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8BFA4E8DBD4;
        Wed, 20 Apr 2022 21:50:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4 0/3] Enlarge offset check value in
 bpf_skb_load_bytes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165049142756.27071.2282139380669338907.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 21:50:27 +0000
References: <20220416105801.88708-1-liujian56@huawei.com>
In-Reply-To: <20220416105801.88708-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, sdf@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sat, 16 Apr 2022 18:57:58 +0800 you wrote:
> The data length of skb frags + frag_list may be greater than 0xffff,
> and skb_header_pointer can not handle negative offset.
> So here INT_MAX is used to check the validity of offset.
> 
> And add the test case for the change.
> 
> Liu Jian (3):
>   net: Enlarge offset check value from 0xffff to INT_MAX in
>     bpf_skb_load_bytes
>   net: change skb_ensure_writable()'s write_len param to unsigned int
>     type
>   selftests: bpf: add test for skb_load_bytes
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4,1/3] net: Enlarge offset check value from 0xffff to INT_MAX in bpf_skb_load_bytes
    https://git.kernel.org/bpf/bpf-next/c/45969b4152c1
  - [bpf-next,v4,2/3] net: change skb_ensure_writable()'s write_len param to unsigned int type
    https://git.kernel.org/bpf/bpf-next/c/92ece28072f1
  - [bpf-next,v4,3/3] selftests: bpf: add test for skb_load_bytes
    https://git.kernel.org/bpf/bpf-next/c/127e7dca427b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


