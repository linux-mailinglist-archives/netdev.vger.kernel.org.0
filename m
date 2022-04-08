Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC24F9387
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiDHLMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiDHLMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:12:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28ED1705D
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 04:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7792A61FA7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9AC1C385AE;
        Fri,  8 Apr 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416218;
        bh=XM2NY8PPgqWpesl0PFK0K95i9smbLFslCuIb2vvjmSQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vBSjgdmWn9UbiTzScF/PA+cVYV/ZlVAOAumuwdmu5UwtGjDztrs3YtSiO5S9jRa/I
         H4+mEEf+6I9z5oI5+XY5Ln4tCGTD/7M/tJCngvZKjg92r0USuuzfDbBrpNSnyHh+P2
         6iCU6UcrmJ/BMtuipWTF+b0mXJc9yXE7xkfa3h23YlfbMB3aAsimnpT7JkwKp/p/yf
         dZWORvJKNNsStIVlrg0tnbdC7/TB9zaWo+/shjBdT5Lfas4Bw3lcPbag2tAh/NTBHo
         pUTuAzjfIPjtth0rNbEc1Lfx3iLPpdfjg2v+5/aLUrbWb8bOT/YSYq/wMcl2iC+0JV
         Ld705sgFbVNOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A39EFE8DD18;
        Fri,  8 Apr 2022 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] tls: rx: random refactoring part 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941621866.19376.2276042715754218799.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:10:18 +0000
References: <20220408033823.965896-1-kuba@kernel.org>
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Apr 2022 20:38:13 -0700 you wrote:
> TLS Rx refactoring. Part 1 of 3. A couple of features to follow.
> 
> Jakub Kicinski (10):
>   tls: rx: jump to a more appropriate label
>   tls: rx: drop pointless else after goto
>   tls: rx: don't store the record type in socket context
>   tls: rx: don't store the decryption status in socket context
>   tls: rx: init decrypted status in tls_read_size()
>   tls: rx: use a define for tag length
>   tls: rx: replace 'back' with 'offset'
>   tls: rx: don't issue wake ups when data is decrypted
>   tls: rx: refactor decrypt_skb_update()
>   tls: hw: rx: use return value of tls_device_decrypted() to carry
>     status
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] tls: rx: jump to a more appropriate label
    https://git.kernel.org/netdev/net-next/c/bfc06e1aaa13
  - [net-next,02/10] tls: rx: drop pointless else after goto
    https://git.kernel.org/netdev/net-next/c/d5123edd10cf
  - [net-next,03/10] tls: rx: don't store the record type in socket context
    https://git.kernel.org/netdev/net-next/c/c3f6bb74137c
  - [net-next,04/10] tls: rx: don't store the decryption status in socket context
    https://git.kernel.org/netdev/net-next/c/7dc59c33d62c
  - [net-next,05/10] tls: rx: init decrypted status in tls_read_size()
    https://git.kernel.org/netdev/net-next/c/863533e316b2
  - [net-next,06/10] tls: rx: use a define for tag length
    https://git.kernel.org/netdev/net-next/c/a8340cc02bee
  - [net-next,07/10] tls: rx: replace 'back' with 'offset'
    https://git.kernel.org/netdev/net-next/c/5deee41b19b3
  - [net-next,08/10] tls: rx: don't issue wake ups when data is decrypted
    https://git.kernel.org/netdev/net-next/c/5dbda02d322d
  - [net-next,09/10] tls: rx: refactor decrypt_skb_update()
    https://git.kernel.org/netdev/net-next/c/3764ae5ba661
  - [net-next,10/10] tls: hw: rx: use return value of tls_device_decrypted() to carry status
    https://git.kernel.org/netdev/net-next/c/71471ca32505

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


