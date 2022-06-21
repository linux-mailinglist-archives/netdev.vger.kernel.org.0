Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2465552EA8
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349493AbiFUJlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349491AbiFUJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE704275F8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747076160E
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 09:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA0BEC3411D;
        Tue, 21 Jun 2022 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655804412;
        bh=xmwgItfaK/ss2nt8MovBwasCoZSVfrPS8jIUMXIIcvU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mPjnwRH+z5Y3v78Yxccl1QfIsX3PY6arrzI9Moi5n/ACwuNamJ+Qd8ErnmwPPKvfm
         eGeBpAwiWCEfMSfQSi72zRrHtMYJQgpVc2PCoCLv2O1SG5ou19VS/raPC17Zcsv40R
         MKYZge/0Z0x5ptbDaPvXablpzO2JftB6qn0GC5Jgwu1mg+BCMdXZhN+J/Z8IPxdOBQ
         YywZosUf27knGdjtUm0VMmU0coJDBWxfwBl9gwCRTYtmvcvHNNAbHLY1Cb0eNhR/KU
         0aY8apv0wtY4NUwXutCbssAd6yFNDgw352DuxjvRbJyQ6DOcWtzdareUTOTOezviyp
         p7vpmmavJiRoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B350EE73875;
        Tue, 21 Jun 2022 09:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: warn if mac header was not set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165580441273.24378.3355290627404947949.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Jun 2022 09:40:12 +0000
References: <20220620093017.3366713-1-eric.dumazet@gmail.com>
In-Reply-To: <20220620093017.3366713-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 20 Jun 2022 02:30:17 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Make sure skb_mac_header(), skb_mac_offset() and skb_mac_header_len() uses
> are not fooled if the mac header has not been set.
> 
> These checks are enabled if CONFIG_DEBUG_NET=y
> 
> [...]

Here is the summary with links:
  - [net-next] net: warn if mac header was not set
    https://git.kernel.org/netdev/net-next/c/f9aefd6b2aa3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


