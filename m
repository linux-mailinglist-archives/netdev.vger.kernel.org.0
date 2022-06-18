Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F97550264
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383980AbiFRDUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383685AbiFRDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FA649FA2
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1FF61FA1
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FAAFC341C4;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655522415;
        bh=jbI9c0xJwlDQmLgjgOBsOp5Jgbox/Nx5dhYSkwX301Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Igq/Wv3HH5FQhLrN039OQTzH71kZoZZTKszKezklKRXauHurEMwxyug2ZRTxVCoVP
         ahQ0JfFWfVFTbJxjQ9Ks/hacqVQUy/Jd+G6tuqxzMviJsLBa40kb60SCjTlysm7G/s
         RZEdeBKlm1R1qt/I32Brnzqk4bozNTOaofBwn03VuwGNaXAMvqJEHWW0fQczf55anO
         l03aZFNBQhvY36nwgD5RAu5v79Tou/dX17Ax0QSPHWlgknAcs4pOv9kFGwJFRmiGbi
         QnY4p8YZqoOrpLf2VvV3Uax1jxn6naEDmwWKWEtl2l+FmfC8sSBmlIBh0dg9TMJkx0
         3B5lQYG405Alg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6FE2E7B9A4;
        Sat, 18 Jun 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: add support for .get_pauseparam()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552241494.3144.10026066773644668642.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:20:14 +0000
References: <20220616133358.135305-1-simon.horman@corigine.com>
In-Reply-To: <20220616133358.135305-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yinjun.zhang@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 15:33:57 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Show correct pause frame parameters for nfp. These parameters cannot
> be configured, so .set_pauseparam() is not implemented. With this
> change:
> 
>  #ethtool --show-pause enp1s0np0
>  Pause parameters for enp1s0np0:
>  Autonegotiate:  off
>  RX:             on
>  TX:             on
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: add support for .get_pauseparam()
    https://git.kernel.org/netdev/net-next/c/382f99c442b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


