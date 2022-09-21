Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CBE5BF1C0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiIUAKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiIUAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BBA481C4;
        Tue, 20 Sep 2022 17:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82475B81E64;
        Wed, 21 Sep 2022 00:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EC9CC43143;
        Wed, 21 Sep 2022 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663719015;
        bh=w5vkJLN1HmTosoecgDPhBJzrA8lMSYftqBKJV4MCgzQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dMPMaDUU+Kp4bFkjPv1set0WwX+ct9OM6AvPmYdsj9UrDrmkOgqJ7twjnPNM5Hcet
         dfiNotqRjyuJ8y3gHHaxpYcblbisbMizRanZhYoMpIuIXcjrgOK0/ywZMein2dx4u9
         XMQNLsHxc8YQzUFO1gvOplA08dW0hv7z23IhhrJZVQoFfMc2TLBaWNNqhhf27wPhSX
         ELXu8WaKE7EfhlLXcnRmGy/Cnf2ZBH8FT7vK5A+yrWqxESKwrREdDzHBgI7ieTR2AR
         uB1KSSf89NIRoCJmLLzgg6+0483FvwwMmHECHmIG4XvKX06D2bcHXQRZUYhf/SlcFC
         X9xbAdI53FYBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B9B5E21EE2;
        Wed, 21 Sep 2022 00:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] liquidio: CN23XX: delete repeated words,
 add missing words and fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371901517.22206.7947276284436995760.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 00:10:15 +0000
References: <20220919053447.5702-1-RuffaloLavoisier@gmail.com>
In-Reply-To: <20220919053447.5702-1-RuffaloLavoisier@gmail.com>
To:     Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, RuffaloLavoisier@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 19 Sep 2022 14:34:46 +0900 you wrote:
> - Delete the repeated word 'to' in the comment.
> 
> - Add the missing 'use' word within the sentence.
> 
> - Correct spelling on 'malformation', 'needs'.
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v5] liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment
    https://git.kernel.org/netdev/net-next/c/c29b06821590

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


