Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856816671CA
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjALMNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjALMMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:12:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E108193CC;
        Thu, 12 Jan 2023 04:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F7462024;
        Thu, 12 Jan 2023 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69313C433F0;
        Thu, 12 Jan 2023 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673525417;
        bh=gsYxWlK8kWlorZYzaBHVqGpjIUocYT7YECmAzzCC7F8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rHJGh3uN7c7b1hvo7Po5cnqwzMItfKwmX74MVknrbD7H0nV8E95uBX5n8UI1YZmxJ
         +Vl+pQH+O4muGHd9X7sR3CGCYBy+Tav99iChhAXsllu/DzyLLVdhKweZx83KGkyg6b
         ouSppi1Etf7TQDR9P/X/rv0dIkMNgWEQT7dDHfA0B4s0cwTkdSm+gaH5p50ENv2yWW
         Pp4Er92/PUK8AzTfRaHbxqHtSH7K/Rf/E3rEk8oKp5WhdczLbW8HdEA8LoXeijI8+b
         /spY/UpVKvgtcP1Ybj3xO172y61JBu5S3/hJL3MciQXXO1CvztpIG2SYfNcghnhYIX
         2b3xi5XlXRWiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48F92C395C8;
        Thu, 12 Jan 2023 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/4] vsock: update tools and error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167352541729.1184.6673076269583073603.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 12:10:17 +0000
References: <67cd2d0a-1c58-baac-7b39-b8d4ea44f719@sberdevices.ru>
In-Reply-To: <67cd2d0a-1c58-baac-7b39-b8d4ea44f719@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     sgarzare@redhat.com, edumazet@google.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bobby.eshleman@bytedance.com, oxffffaa@gmail.com,
        kernel@sberdevices.ru
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 10 Jan 2023 10:11:14 +0000 you wrote:
> Patchset consists of two parts:
> 
> 1) Kernel patch
> One patch from Bobby Eshleman. I took single patch from Bobby:
> https://lore.kernel.org/lkml/d81818b868216c774613dd03641fcfe63cc55a45
> .1660362668.git.bobby.eshleman@bytedance.com/ and use only part for
> af_vsock.c, as VMCI and Hyper-V parts were rejected.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/4] vsock: return errors other than -ENOMEM to socket
    https://git.kernel.org/netdev/net-next/c/c43170b7e157
  - [net-next,v7,2/4] test/vsock: rework message bounds test
    https://git.kernel.org/netdev/net-next/c/5c338112e48a
  - [net-next,v7,3/4] test/vsock: add big message test
    https://git.kernel.org/netdev/net-next/c/685a21c314a8
  - [net-next,v7,4/4] test/vsock: vsock_perf utility
    https://git.kernel.org/netdev/net-next/c/8abbffd27ced

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


