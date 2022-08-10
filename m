Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEA58E6AF
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiHJFUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHJFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:20:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ECE1EAEF;
        Tue,  9 Aug 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1AD41CE192F;
        Wed, 10 Aug 2022 05:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B375C433C1;
        Wed, 10 Aug 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660108814;
        bh=hrR4wyiQIPX0LbLDc5FUFQCB19uXuacB+5ToYsAP5ZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c8/CmdQ7F2axkLFCFobdOQi1yPuz0AKb5593yKWgx+MnYnSjM+KmqGr5lExdu9sHC
         cPwFjyWL30oey94hEfoj8zOxzwtLRfaBfYZmJ8Fpc0ueu/IiJKpzKDgcW7T9DPpJ87
         OHShzEIsYgsEokcNotoXQ5h/K9our1Y1LbqdggTi4MNx9dzQseJztRhnMK10iHoZ6s
         OMymL853oK0C/uvj3APh6yYXbUgMnBRCq4EvUj2n9APJhL5MRkBRVbAnvrUwCg40rK
         uGsR38N6rBDmcFRZDi2wPc0m2VQS93CK/jPimHZzJwWIYDEo3M7a81iUa+vKmEgB2P
         VM9rQCxKJhbDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F88FC43142;
        Wed, 10 Aug 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: atlantic: fix aq_vec index out of range error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166010881432.23810.2511716085125692417.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 05:20:14 +0000
References: <20220808081845.42005-1-acelan.kao@canonical.com>
In-Reply-To: <20220808081845.42005-1-acelan.kao@canonical.com>
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Dmitrii.Tarakanov@aquantia.com,
        Alexander.Loktionov@aquantia.com, vomlehn@texas.net,
        Dmitry.Bezrukov@aquantia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skalluru@marvell.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 Aug 2022 16:18:45 +0800 you wrote:
> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
> 
> The final update statement of the for loop exceeds the array range, the
> dereference of self->aq_vec[i] is not checked and then leads to the
> index out of range error.
> Also fixed this kind of coding style in other for loop.
> 
> [...]

Here is the summary with links:
  - [v3] net: atlantic: fix aq_vec index out of range error
    https://git.kernel.org/netdev/net/c/2ba5e47fb75f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


