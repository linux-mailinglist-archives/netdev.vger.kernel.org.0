Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D98552B962
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiERMAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbiERMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2299B17CC87
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C042BB81F99
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70A5DC34115;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875214;
        bh=LXYO3ijWUbMDQT7jZuyAQJ6wH5IIM5skEanqqksZxCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fhKm1prqxZ1fxMGs/iu85lkS3JI5DA6vyifGMzAVajlBD9xDwH1I6CSFwPytZ+SWt
         t8+ecerzvIFMqRDD5GNNT4pIWqE0rKRKkVLhZcor/6SKflLkbV4qUruTmH8Dg3Y1Dr
         VeTnGQN0+1PtVo/Bg/b3gK9STRnFT9tC0CeF7+5Ho/Es6On8TRgaoq/9pvmekIcB0z
         W3RKLKYx+a2FR+rPSP4BHzudcq5QcCra5XMd5wNs9eBshqXiSq20dEdrQzK1RNARGx
         siHi0dVA7Mm70zNT1FJKCR9+Jwoykgd8b7UlFhEPTjEVUNcSPUgla5dxB5ifRwh6xM
         hGsiUYl+GNokA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5196FF0392C;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] xfrm: fix "disable_policy" flag use when arriving from
 different devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287521432.18230.9855368297389701588.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:00:14 +0000
References: <20220518081938.2075278-2-steffen.klassert@secunet.com>
In-Reply-To: <20220518081938.2075278-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 18 May 2022 10:19:36 +0200 you wrote:
> From: Eyal Birger <eyal.birger@gmail.com>
> 
> In IPv4 setting the "disable_policy" flag on a device means no policy
> should be enforced for traffic originating from the device. This was
> implemented by seting the DST_NOPOLICY flag in the dst based on the
> originating device.
> 
> [...]

Here is the summary with links:
  - [1/3] xfrm: fix "disable_policy" flag use when arriving from different devices
    https://git.kernel.org/netdev/net/c/e6175a2ed1f1
  - [2/3] net: af_key: add check for pfkey_broadcast in function pfkey_process
    https://git.kernel.org/netdev/net/c/4dc2a5a8f675
  - [3/3] net: af_key: check encryption module availability consistency
    https://git.kernel.org/netdev/net/c/015c44d7bff3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


