Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAAA50668B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243806AbiDSIM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243633AbiDSIM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22F2DED7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54A1CB811BE
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E996AC385AA;
        Tue, 19 Apr 2022 08:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650355811;
        bh=hWbm4/obit205R3vqD9FGO7Pgsb1m5/OYbhCYUjhpMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MpjJP4eP9QDDneKlIDUbB6QGCcLxYxxTTy5/p8BGGjRS+NXhqrRzCSe64uSuTY3qi
         SgMpa6zmMJ37eLb44sYdoXxkueJTP6KDEHax9nB/WGaYxvHES290gfuryU6SzoVMqD
         KMco6U6iu1qWOHTO36YVxYKI5wKBsdJVNRa3Ntlv3AeRkhhptWbnIuJFxJGgp0ZdQc
         BGwunZ6cLdl1IPz1fU4sSA6o3NmxC7XbdJDYUT2VqcembbFRwVbspHEezBIECamEu7
         cIzlSZLbCmKgCFiT6v01Jr8W8VvhqpgxR6mZmbGfmNblh3zm2y0a2egmeaIUCj41vV
         ZhjJXY/lxuzRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C124AE8DD61;
        Tue, 19 Apr 2022 08:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: hellcreek: Calculate checksums in tagger
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165035581078.3970.8684001040570635218.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Apr 2022 08:10:10 +0000
References: <20220415103320.90657-1-kurt@linutronix.de>
In-Reply-To: <20220415103320.90657-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 15 Apr 2022 12:33:20 +0200 you wrote:
> In case the checksum calculation is offloaded to the DSA master network
> interface, it will include the switch trailing tag. As soon as the switch strips
> that tag on egress, the calculated checksum is wrong.
> 
> Therefore, add the checksum calculation to the tagger (if required) before
> adding the switch tag. This way, the hellcreek code works with all DSA master
> interfaces regardless of their declared feature set.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: hellcreek: Calculate checksums in tagger
    https://git.kernel.org/netdev/net/c/0763120b0904

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


