Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4780860E12F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbiJZMuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiJZMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76385B11E;
        Wed, 26 Oct 2022 05:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 862A861EBA;
        Wed, 26 Oct 2022 12:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6791C433D7;
        Wed, 26 Oct 2022 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666788614;
        bh=7RDWmlcQAFx3kwj1N0nkhwHAsUQrVQLqkwGOPnD2VxU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qpFj8bZeJ9DwzaCJVNpqg1tCzwG51Ouu3Ccjx2iqaBCuITNTp9AbaCtJ/MlSQ6LZI
         kDcLawyGkUoE0aILfC6c7BT+i29MfGHHXsvnJ9ys2G7zYoF8ZmwVHl2IoCHBs0aK0T
         3V509wfUFS3Pr5DG3KoJbphQ4Az8lTyXUq9TQ6BnyvFi17x7WPrstMSdfyMJRVZfSb
         oGOsHsfTl8+5jQM56Y3XghV5Y70+YqeM3zUbDXZ9aqdMEupxF0BU+iVKSo/BKYZMv9
         7yP5OtQ3pCxayhjDka2/JzcBvONSBlHwDUC9aUI5SL4/PZnYhAeoaeal7k29tMeaIH
         TtYcJl/njFmQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6F56E45192;
        Wed, 26 Oct 2022 12:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][Resend] rhashtable: make test actually random
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166678861481.24035.4960761110592518621.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 12:50:14 +0000
References: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
In-Reply-To: <5894765.lOV4Wx5bFT@eto.sf-tec.de>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     tgraf@suug.ch, herbert@gondor.apana.org.au, fw@strlen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason@zx2c4.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Oct 2022 15:47:03 +0200 you wrote:
> The "random rhlist add/delete operations" actually wasn't very random, as all
> cases tested the same bit. Since the later parts of this loop depend on the
> first case execute this unconditionally, and then test on different bits for the
> remaining tests. While at it only request as much random bits as are actually
> used.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> 
> [...]

Here is the summary with links:
  - [Resend] rhashtable: make test actually random
    https://git.kernel.org/netdev/net/c/c5f0a1728874

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


