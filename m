Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A48C63A6CB
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiK1LKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiK1LKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:10:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C027D193DC;
        Mon, 28 Nov 2022 03:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 579376106C;
        Mon, 28 Nov 2022 11:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A12C6C433B5;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669633831;
        bh=z1o4hJOm9/9hcMA3ap+7ixzMjC/MFG4lVyFiMBfaNT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PE/SoITpvK1SoSCazHoFMoRO4gC6trGjqX7OOWxcRrAYTHlh6bhjaABCR1xO72BQr
         Xrfb2xL+JHQpSL7smoafBuzLOY77UrAOYfXaM5Ncwm0qydrl7FqL3wj37VSSDPSUNU
         +AsKGQfeCqwplKGoh7ey46L6XjDIzG17V2Jez+Wi8/Xnvw0H7y7D3N3YF9FJvf7mOh
         4mlO5Spi5J+5VD2GBPFaswF3SbagcprXi+C6Z8yxv/3+eQnq5zZ/fndS5DpdVSidl9
         QAUkIRllTL26ne54bOMxN8A1wJSVp8d5m1tAedctJrJUj7N9WjULdkvi3Rq0682q84
         Xg5qVq8LwX/UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81050C395EC;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/9p: Fix a potential socket leak in p9_socket_open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963383152.22058.5742377206245481714.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:10:31 +0000
References: <20221124081005.66579-1-wanghai38@huawei.com>
In-Reply-To: <20221124081005.66579-1-wanghai38@huawei.com>
To:     wanghai (M) <wanghai38@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, viro@zeniv.linux.org.uk,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Nov 2022 16:10:05 +0800 you wrote:
> Both p9_fd_create_tcp() and p9_fd_create_unix() will call
> p9_socket_open(). If the creation of p9_trans_fd fails,
> p9_fd_create_tcp() and p9_fd_create_unix() will return an
> error directly instead of releasing the cscoket, which will
> result in a socket leak.
> 
> This patch adds sock_release() to fix the leak issue.
> 
> [...]

Here is the summary with links:
  - [net] net/9p: Fix a potential socket leak in p9_socket_open
    https://git.kernel.org/netdev/net/c/dcc14cfd7deb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


