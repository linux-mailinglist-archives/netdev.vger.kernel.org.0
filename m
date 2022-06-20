Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD51551282
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiFTIUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiFTIUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 04:20:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4547411C27;
        Mon, 20 Jun 2022 01:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB444CE0FAE;
        Mon, 20 Jun 2022 08:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15E6CC341C5;
        Mon, 20 Jun 2022 08:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655713228;
        bh=sl02kj1le83JRF8ZjTmxwGvQGdhdKftJfwKyd9YstX0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JHT8DTrqoFDchMMGuyXJ8IPN7PdNwHP5WBOWrI8C5n+4ZGU4YXPs/84Hk4jgGbNj3
         I6NsmbaNbPQ0K0adiDGif7k0nHySVcWF0YMdvRyUKxz2Yu9ioLwPxAkhZNd2bSdA7O
         lwq5W+UqTSfTdHhKW24SLtFHQfMkUuQ9nuhHIrHBpLN8tkFxERN2bl9AYftEWmAFih
         aayb39/H/FpxjSnvbK+E2QTBQg63PAhb0n7x1rv56MKmw0PqZaNpeHMc9G6xhQp3Lt
         MS9eUM/JEKcHw7O1PhuYRTEQ+XDVvy3dyyzopTkqvjm6VC5hA3qVDbGl9/SA1JCfdY
         g5f6RRIO3XpyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE119E737F0;
        Mon, 20 Jun 2022 08:20:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] vmxnet3: disable overlay offloads if UPT device does
 not support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165571322796.28545.7365793721968727456.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Jun 2022 08:20:27 +0000
References: <20220620001014.27048-1-doshir@vmware.com>
In-Reply-To: <20220620001014.27048-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gyang@vmware.com, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Jun 2022 17:10:13 -0700 you wrote:
> 'Commit 6f91f4ba046e ("vmxnet3: add support for capability registers")'
> added support for capability registers. These registers are used
> to advertize capabilities of the device.
> 
> The patch updated the dev_caps to disable outer checksum offload if
> PTCR register does not support it. However, it missed to update
> other overlay offloads. This patch fixes this issue.
> 
> [...]

Here is the summary with links:
  - [net-next] vmxnet3: disable overlay offloads if UPT device does not support
    https://git.kernel.org/netdev/net-next/c/a56b158a5078

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


