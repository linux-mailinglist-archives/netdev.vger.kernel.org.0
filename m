Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53734E277D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347827AbiCUNb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiCUNbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFAD393FC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AE6C611E1
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C776BC340F3;
        Mon, 21 Mar 2022 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647869413;
        bh=X+HGPNJTHmrMfXplmom+nJLsjy/xdeIpMStae8VB3gU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=auRpHljtFp8Yc9NaLai1bCKJ+++kLz15fHiIyHzBo/ssfeezhozlYWJYLyasbNBgs
         +MgQKvm60vFZLTjXI6QznkONIig6V9BjQF3U9ghx3XRIbxncsH/a+5xgBawllxF2qO
         EqEdAxPleKldvuvd52SZYv2not/X3h8lsiqysVz2a5zRCfNhWAWHpouw4wIqLjGj+V
         vUrvdFt2uuM029Qx5nBgEfv8p/giQOUhRWgWKwTlSwWk6ZmXML8O5T13JRvQ0X2hW8
         uuTffzlfmMyIlq+VvWCqtpXWa0UyRR0AizrnlDpVKylWuTyNHbuFwGTMzwySJGlk6U
         nZqjOka/p78Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A86C4EAC09C;
        Mon, 21 Mar 2022 13:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: sparx5: Add multicast support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786941368.23699.3039977702070639823.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 13:30:13 +0000
References: <20220321101446.2372093-1-casper.casan@gmail.com>
In-Reply-To: <20220321101446.2372093-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 11:14:44 +0100 you wrote:
> Add multicast support to Sparx5.
> 
> --
> I apologies, I accidentally forgot to add the netdev
> mailing list the first time I sent this. Here it comes
> to netdev as well.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sparx5: Add arbiter for managing PGID table
    https://git.kernel.org/netdev/net-next/c/af9b45d08eb4
  - [net-next,2/2] net: sparx5: Add mdb handlers
    https://git.kernel.org/netdev/net-next/c/3bacfccdcb2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


