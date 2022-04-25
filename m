Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743F550E4BE
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbiDYPxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242990AbiDYPxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:53:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD1F1A80D;
        Mon, 25 Apr 2022 08:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB9CCB817A8;
        Mon, 25 Apr 2022 15:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 942F1C385A9;
        Mon, 25 Apr 2022 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650901811;
        bh=xCiXIyB1/9rUM4Y1cYvZ+2b6PvYqWTxHDP+v2W+MwYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tz9w144WPnfJJL/IW3IrbxXbnD4HLlwKaqn5LIAOvkbryTIyBy3PjMImhZ+Alat1B
         PjtVU9VjkAUDH+3+/446jAVjOZKs4a40ww9Fk/Kybqat2NUuJ6ip+Dur4FAL4qKZU+
         GQwvqJqAJ4vfiPcTw4dS3SGxsX+fx/N57HEJ4M5BU+nVXjFgPCSADJ4JgkkCKmxKZ+
         OnApJheuylV3Vh0Pe+DksBIsB28DNA5RLtGSX/1M7c5ip+psyiYA+erhIDb10m6AfX
         eP4S4kV7YIgwgofr5pkaYf7I/wbuGtOFZVL8t7fugIYXFboBQab8ql+2ZBvDRxunon
         0NCKvEsTAeSbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7CF35E85D90;
        Mon, 25 Apr 2022 15:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: Remove unnecessary type cast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165090181150.3120.18254701364580010836.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 15:50:11 +0000
References: <20220424143420.457082-1-ytcoode@gmail.com>
In-Reply-To: <20220424143420.457082-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 24 Apr 2022 22:34:20 +0800 you wrote:
> The link variable is already of type 'struct bpf_link *', casting it to
> 'struct bpf_link *' is redundant, drop it.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] libbpf: Remove unnecessary type cast
    https://git.kernel.org/bpf/bpf-next/c/003fed595c0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


