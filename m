Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB89255142F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbiFTJUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240526AbiFTJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0217665;
        Mon, 20 Jun 2022 02:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4ED9B80FC0;
        Mon, 20 Jun 2022 09:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4310FC341C8;
        Mon, 20 Jun 2022 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655716812;
        bh=DTaC6TcRZQNOfAF8QsEiWSuIJ4dECBU0F1ViA2mWEag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PwgjpcN+JKt17utD7bSwNIh5Lggi50xI36ygxwaHedkRyVgb8exv+4m7TFiGnQIB2
         akpLEj1iNSHh9NfCosM2rs6sagXHKKiGZ7+AFojpiCRcM4Lmsbt6GdqYSPE7XTt188
         ilsOxd5HnamAgoBHwoA++mvWfTV+WK9bOiRyNuxReMXOdIlSHA9X8IxqnmxW6FoByJ
         XgwGhNkDRJG5YqWYUR5Q+9pHy9RI49ckwAoNMWyZ18SR/oizHsTQMcOLKVsy206uay
         /THDBUqqyMPjJh8MGbfL/ruLrrQC/A8mcKL9CwO1Vg89lJio8ECl6vut+VelGKsqx2
         pbmOtCUPUJxSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2887AE737F0;
        Mon, 20 Jun 2022 09:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tls: fix tls_sk_proto_close executed repeatedly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165571681216.11783.14529855078803748152.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 09:20:12 +0000
References: <20220620043508.3455616-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220620043508.3455616-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 20 Jun 2022 12:35:08 +0800 you wrote:
> After setting the sock ktls, update ctx->sk_proto to sock->sk_prot by
> tls_update(), so now ctx->sk_proto->close is tls_sk_proto_close(). When
> close the sock, tls_sk_proto_close() is called for sock->sk_prot->close
> is tls_sk_proto_close(). But ctx->sk_proto->close() will be executed later
> in tls_sk_proto_close(). Thus tls_sk_proto_close() executed repeatedly
> occurred. That will trigger the following bug.
> 
> [...]

Here is the summary with links:
  - [net] net/tls: fix tls_sk_proto_close executed repeatedly
    https://git.kernel.org/netdev/net/c/69135c572d1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


