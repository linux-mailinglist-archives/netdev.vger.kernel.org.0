Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BFF51B623
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbiEECx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239963AbiEECxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:53:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89169E46;
        Wed,  4 May 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EB2A6135D;
        Thu,  5 May 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7414DC385AA;
        Thu,  5 May 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651719014;
        bh=W7kgWBekRhjvUK4oGmuZBqzE/MvWvPC3uCOtjm5r1pw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g/b7CGMVsABkoz6tv5a8MDK5tt75YLuXhcguYpLt59MWqMBlxNHw7z06tOBv3D0IH
         ul7Epuk3cFXCaDRiLWNzictigyyemE93A1ERJq1f1jIP1EEgmXJbhhiVHcQySWzZsC
         KSSi7SqbSskXdAJI6czeyNZUZohlI4hmADbEyaWXHaZGHySKWytHnAS7jpB8kcsST3
         ij9fAjmvjebC8FTE8g8qYnEKcGR5Pdr14M+9kSD+KF6PeTx9pcn3cs1oyRtyE0RZnS
         1WK8c5S6gwfFyrcQxM6/WeyIPDXK6ybc5LkuylSH+s9r4cxcdV90+qkq5JOjDLZWre
         YxWwHzJlF1fWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5593CF03876;
        Thu,  5 May 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/7] insufficient TCP source port randomness
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165171901434.9346.11862672519464851497.git-patchwork-notify@kernel.org>
Date:   Thu, 05 May 2022 02:50:14 +0000
References: <20220502084614.24123-1-w@1wt.eu>
In-Reply-To: <20220502084614.24123-1-w@1wt.eu>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, Jason@zx2c4.com,
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 May 2022 10:46:07 +0200 you wrote:
> Hi,
> 
> In a not-yet published paper, Moshe Kol, Amit Klein, and Yossi Gilad
> report being able to accurately identify a client by forcing it to emit
> only 40 times more connections than the number of entries in the
> table_perturb[] table, which is indexed by hashing the connection tuple.
> The current 2^8 setting allows them to perform that attack with only 10k
> connections, which is not hard to achieve in a few seconds.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/7] secure_seq: use the 64 bits of the siphash for port offset calculation
    https://git.kernel.org/netdev/net/c/b2d057560b81
  - [v3,net,2/7] tcp: use different parts of the port_offset for index and offset
    https://git.kernel.org/netdev/net/c/9e9b70ae923b
  - [v3,net,3/7] tcp: resalt the secret every 10 seconds
    https://git.kernel.org/netdev/net/c/4dfa9b438ee3
  - [v3,net,4/7] tcp: add small random increments to the source port
    https://git.kernel.org/netdev/net/c/ca7af0402550
  - [v3,net,5/7] tcp: dynamically allocate the perturb table used by source ports
    https://git.kernel.org/netdev/net/c/e9261476184b
  - [v3,net,6/7] tcp: increase source port perturb table to 2^16
    https://git.kernel.org/netdev/net/c/4c2c8f03a5ab
  - [v3,net,7/7] tcp: drop the hash_32() part from the index calculation
    https://git.kernel.org/netdev/net/c/e8161345ddbb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


