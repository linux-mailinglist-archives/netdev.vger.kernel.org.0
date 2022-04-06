Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDC04F68F2
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240467AbiDFSUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240430AbiDFSTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:19:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C29FFF4F;
        Wed,  6 Apr 2022 10:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 546B9617DB;
        Wed,  6 Apr 2022 17:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99845C385A5;
        Wed,  6 Apr 2022 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649264413;
        bh=Xhk5SOzpGqN61TwyKV3hSuwu45jxXYiMouo5aJDKIAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S/o/CNjCvuORSfZUrRC0Nar/WqdJ4ffZKZD/OcNTAosKm7HpRZ0s5QcPByu3LrQP5
         4LlqujxwzBXT6IxxNwtngEeQwoWvHjBJJDNzMYPRzGslwjvjKa2ctMdWienSpbBEvV
         U6T+KrL0sBlBLLW3C3w21YrUccyFsKRXoSH7dUbRv2jNnfuTDIf/ep1+Ir6palwizL
         jGmyjESSLGOeq85VfQySDor4w4y5aHrHV5pfk66vugpV4z0lFC12DMLzgF0z+EKjmS
         owh9ouX65W2QRX60EK4e2gLPDx6wj/E68MN5HhdeHK4qBSRo46prRerfRJtg0zDYw5
         7xt7FyO+K82zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 762ACE85D53;
        Wed,  6 Apr 2022 17:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v5 1/2] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164926441347.11980.16956318462962965009.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 17:00:13 +0000
References: <20220406124113.2795730-1-maximmi@nvidia.com>
In-Reply-To: <20220406124113.2795730-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com, afabre@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, hawk@kernel.org,
        tariqt@nvidia.com
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

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 6 Apr 2022 15:41:12 +0300 you wrote:
> bpf_tcp_gen_syncookie looks at the IP version in the IP header and
> validates the address family of the socket. It supports IPv4 packets in
> AF_INET6 dual-stack sockets.
> 
> On the other hand, bpf_tcp_check_syncookie looks only at the address
> family of the socket, ignoring the real IP version in headers, and
> validates only the packet size. This implementation has some drawbacks:
> 
> [...]

Here is the summary with links:
  - [bpf,v5,1/2] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
    https://git.kernel.org/bpf/bpf/c/2e8702cc0cfa
  - [bpf,v5,2/2] bpf: Adjust bpf_tcp_check_syncookie selftest to test dual-stack sockets
    https://git.kernel.org/bpf/bpf/c/53968dafc4a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


