Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2224F678FD8
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjAXFaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXFaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBECF7D92
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A192CB81014
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 487B7C4339C;
        Tue, 24 Jan 2023 05:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674538216;
        bh=NdSOxAxcDO88cpITOIgbbYwMbjf+8146U9/yJ4OIkeU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h+zRrK0HPo68UeG6CIwDQTHSr446vAJdiUQoBn4mJ3a5fi4pT8Fvm5Svl0WIEkTga
         8PchCbc/TVTH7MusfA2V54uX+GjIGhitr3Mn1C5ZM+II9rByNRsli6tkP1EQbUk2zU
         zzlZZTco2UBb8uXKL1vaiKn6tsEgb2lxfspFTTdnqQvHC6ns5NHCMg8ODQ/i3XNXrQ
         P94W/gxm3LlMDWhH3EMt3wL9wDy/dFQj1HJXhkvCC/Gw9m/QqZFEAtdmYZ8oy/bV13
         IIPll9FN6oF4p9ImOE3EuiPxAgryexCsPRXDMxt/72XccgvscN083KKzIWfAuwbXuE
         MUk0+YXCcsqJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29EB1C04E33;
        Tue, 24 Jan 2023 05:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: net: tcp_mmap: populate pages in send
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453821616.25349.8635360536960121410.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:30:16 +0000
References: <20230120181136.3764521-1-edumazet@google.com>
In-Reply-To: <20230120181136.3764521-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 18:11:36 +0000 you wrote:
> In commit 72653ae5303c ("selftests: net: tcp_mmap:
> Use huge pages in send path") I made a change to use hugepages
> for the buffer used by the client (tx path)
> 
> Today, I understood that the cause for poor zerocopy
> performance was that after a mmap() for a 512KB memory
> zone, kernel uses a single zeropage, mapped 128 times.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: net: tcp_mmap: populate pages in send path
    https://git.kernel.org/netdev/net-next/c/057fb03160a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


