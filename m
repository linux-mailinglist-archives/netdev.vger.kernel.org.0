Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D224EEC0F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiDALML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbiDALMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:12:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D882742A4
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D7A6B824B2
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B80A6C34111;
        Fri,  1 Apr 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648811412;
        bh=Q6PuRNouFZI04zhF2mJvJ9sLjIVceBPhb47b4Xto9vY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B33b3NcCY/RAt5rMD4U35GUdbqG6ZFVb9zd2yFJVxUt7FcUijJ770XSt78a3LaP/G
         g9UwX3/K9kg6b3OE5uYxzs48GBZ6q1sQ6jTt6P5PjjurnvDkOlTEBaZENxMuyoZzTG
         w35zAAvOFk0Vouvtuq5/HROEVxUz3MLwhJTge0BDAQQPPgvSSzS2UNPjGR+GETXlxD
         /uLZpirZDjPacFTJW5drKkfSU37/e6q1ac5Znok2OyikWbpQfGu/PHmeOg4TYZuLFe
         lXYKnOvpCb2KZQ/pldEXgzy9KJPVfE42tWCAX/GNTTw+lJAZXrgf/Vfuxbz7t7lmkr
         A5pwFPVm3PDUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 954EBF0384B;
        Fri,  1 Apr 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ice-fixups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881141260.17879.17263495494061310943.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:10:12 +0000
References: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 31 Mar 2022 09:20:05 -0700 you wrote:
> This series handles a handful of cleanups for the ice
> driver.  Ivan fixed a problem on the VSI during a release,
> fixing a MAC address setting, and a broken IFF_ALLMULTI
> handling.
> 
> Ivan Vecera:
>   ice: Clear default forwarding VSI during VSI release
>   ice: Fix MAC address setting
>   ice: Fix broken IFF_ALLMULTI handling
> 
> [...]

Here is the summary with links:
  - [net,1/3] ice: Clear default forwarding VSI during VSI release
    https://git.kernel.org/netdev/net/c/bd8c624c0cd5
  - [net,2/3] ice: Fix MAC address setting
    https://git.kernel.org/netdev/net/c/2c0069f3f91f
  - [net,3/3] ice: Fix broken IFF_ALLMULTI handling
    https://git.kernel.org/netdev/net/c/1273f89578f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


