Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B8E4FF55D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbiDMLCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiDMLCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653B13F88B
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F062B61DA0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DC83C385AB;
        Wed, 13 Apr 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649847615;
        bh=K/A5s9qI6lBI2XCb+8o9edW+PEhbQFTsKaRbFDsEHGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4sMavtzcQZDEWBlIIF5pBwCVVb68OaqdMBnrBWYoyW9w8HY0bbshvkcfGuRmabCs
         fXDTGpZR4mR++bsDwX7F2cjPW/hxAGVUMfztf8WjJhrcKYuNyirBlXSEvte9M2HMmK
         /uMZOLTYRuZ9qlKfB9OLmDbdAfAkTaD3b5xuO9ZcaCEe0TXQXrQB3NbupsvM2NiAUo
         MzxR6g+McCaJPFmpGM7Ijzz+Xi0KhrXKjlaPnjmqk1ZcQbkkafRm/1ad7hFJFssth0
         XTlhZnUzyluuy5YLYOebkzFDaEQcoKSy3Qbla1PzGZec6qfIztY36xgRKwXiKrIRXG
         /VFkn2F0gP15w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 393A7E8DD5E;
        Wed, 13 Apr 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] tls: rx: random refactoring part 3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984761522.32685.5046602676205917906.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:00:15 +0000
References: <20220411191917.1240155-1-kuba@kernel.org>
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
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

On Mon, 11 Apr 2022 12:19:07 -0700 you wrote:
> TLS Rx refactoring. Part 3 of 3. This set is mostly around rx_list
> and async processing. The last two patches are minor optimizations.
> A couple of features to follow.
> 
> Jakub Kicinski (10):
>   tls: rx: consistently use unlocked accessors for rx_list
>   tls: rx: reuse leave_on_list label for psock
>   tls: rx: move counting TlsDecryptErrors for sync
>   tls: rx: don't handle TLS 1.3 in the async crypto callback
>   tls: rx: assume crypto always calls our callback
>   tls: rx: treat process_rx_list() errors as transient
>   tls: rx: return the already-copied data on crypto error
>   tls: rx: use async as an in-out argument
>   tls: rx: use MAX_IV_SIZE for allocations
>   tls: rx: only copy IV from the packet for TLS 1.2
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] tls: rx: consistently use unlocked accessors for rx_list
    https://git.kernel.org/netdev/net-next/c/a30295c45472
  - [net-next,02/10] tls: rx: reuse leave_on_list label for psock
    https://git.kernel.org/netdev/net-next/c/0775639ce1ca
  - [net-next,03/10] tls: rx: move counting TlsDecryptErrors for sync
    https://git.kernel.org/netdev/net-next/c/284b4d93daee
  - [net-next,04/10] tls: rx: don't handle TLS 1.3 in the async crypto callback
    https://git.kernel.org/netdev/net-next/c/72f3ad73bc86
  - [net-next,05/10] tls: rx: assume crypto always calls our callback
    https://git.kernel.org/netdev/net-next/c/1c699ffa48a1
  - [net-next,06/10] tls: rx: treat process_rx_list() errors as transient
    https://git.kernel.org/netdev/net-next/c/4dcdd971b9c7
  - [net-next,07/10] tls: rx: return the already-copied data on crypto error
    https://git.kernel.org/netdev/net-next/c/f314bfee81b1
  - [net-next,08/10] tls: rx: use async as an in-out argument
    https://git.kernel.org/netdev/net-next/c/3547a1f9d988
  - [net-next,09/10] tls: rx: use MAX_IV_SIZE for allocations
    https://git.kernel.org/netdev/net-next/c/f7d45f4b52fe
  - [net-next,10/10] tls: rx: only copy IV from the packet for TLS 1.2
    https://git.kernel.org/netdev/net-next/c/a4ae58cdb6e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


