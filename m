Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6B957FDF9
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiGYLAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiGYLAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA882AFA
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 04:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A5C9B80DDC
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 576AEC341C8;
        Mon, 25 Jul 2022 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658746814;
        bh=ZtqdauZFphYm+wlkuHwDA5BSbzL4qpDd00qJdFQZjr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ppJ7+OR7buZjutaakH444nQmfHJYwtc5krsVFc47tY7w8B1+eYcJijjoKVKvxiQB6
         N1D3kVvzAm7bUs0wSapCvbud65OWitXqU2mSwspW8Emc/tKSs8NYLiQiyF8a5wB3wh
         kQftMLswxUUlg6u6S9Omo/r0cLEciIC2y8tNkVD7uhy8C1rRXq98lvxpEdkhx3Hzlk
         iTbpHpmSNyTvjbgKLnQQrQST3mA4CvtRpz6aKgVVWQ41TnmIlgi190wCAKuV8rAbg8
         z0DcJ/56/JG/9l595beYMoHJ9+nD9QfGpTUFvX6yGzqmPqasUJ4fV12ERuYsBkV4f+
         sKbXjSzB7hwXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38C1AE450B4;
        Mon, 25 Jul 2022 11:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] macsec: fix config issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874681421.5766.1379302890390377116.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 11:00:14 +0000
References: <cover.1656519221.git.sd@queasysnail.net>
In-Reply-To: <cover.1656519221.git.sd@queasysnail.net>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, mayflowerera@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Jul 2022 11:16:26 +0200 you wrote:
> The patch adding netlink support for XPN (commit 48ef50fa866a
> ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)"))
> introduced several issues, including a kernel panic reported at [1].
> 
> Reproducing those bugs with upstream iproute is limited, since iproute
> doesn't currently support XPN. I'm also working on this.
> 
> [...]

Here is the summary with links:
  - [net,1/4] macsec: fix NULL deref in macsec_add_rxsa
    https://git.kernel.org/netdev/net/c/f46040eeaf2e
  - [net,2/4] macsec: fix error message in macsec_add_rxsa and _txsa
    https://git.kernel.org/netdev/net/c/3240eac4ff20
  - [net,3/4] macsec: limit replay window size with XPN
    https://git.kernel.org/netdev/net/c/b07a0e204405
  - [net,4/4] macsec: always read MACSEC_SA_ATTR_PN as a u64
    https://git.kernel.org/netdev/net/c/c630d1fe6219

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


