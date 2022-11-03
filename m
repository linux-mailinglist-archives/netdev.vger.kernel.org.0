Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83461617A80
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 11:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiKCKBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 06:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiKCKBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 06:01:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699791055C;
        Thu,  3 Nov 2022 03:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85587B826B6;
        Thu,  3 Nov 2022 10:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2275CC433D7;
        Thu,  3 Nov 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667469616;
        bh=uslzeRNjXStodpIV+n5UCPRPflO3UeHgtnVMkERW3ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LZMzslT/ajEoasK+Hg6U7BRSoblyCzJWewm3lPTahCr31vav77oh9WohqfeTVK/t5
         GQaOF5PrxXMqomVj5owgKWQAsxNd4QUZ80cGGcQrGcC0iDcjZM79H9XeGGlKFlzqxN
         Su2MwpwKoeeTbIbZsWffrYbT5Xv9/wytkkNdJZwqZm9emBabAgxekRghytY1P2nQfb
         QHvScGomNH8EbHU0GVSWDAnBwXNFQQoHI/o3a3vavbV1+wkNIlnXHg7LOCFB8dguZz
         XxZjG03WiRCTSQ2jHKStli7mUz1tsGk0jBe5ba/RbbAUWGGZ5nRTpynRetV6jPwzas
         1ublyVMbolO+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 041BCE29F4C;
        Thu,  3 Nov 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] vsock: remove an unused variable and fix infinite
 sleep
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166746961601.27168.16757250630446856387.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 10:00:16 +0000
References: <20221101021706.26152-1-decui@microsoft.com>
In-Reply-To: <20221101021706.26152-1-decui@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 31 Oct 2022 19:17:04 -0700 you wrote:
> Patch 1 removes the unused 'wait' variable.
> Patch 2 fixes an infinite sleep issue reported by a hv_sock user.
> 
> Made v2 to address Stefano's comments.
> Please see each patch's header for changes in v2.
> 
> Dexuan Cui (2):
>   vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
>   vsock: fix possible infinite sleep in vsock_connectible_wait_data()
> 
> [...]

Here is the summary with links:
  - [v2,1/2] vsock: remove the unused 'wait' in vsock_connectible_recvmsg()
    https://git.kernel.org/netdev/net/c/cf6ff0df0fd1
  - [v2,2/2] vsock: fix possible infinite sleep in vsock_connectible_wait_data()
    https://git.kernel.org/netdev/net/c/466a85336fee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


