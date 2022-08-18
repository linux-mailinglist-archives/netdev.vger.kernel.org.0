Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A279597E00
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243510AbiHRFU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243193AbiHRFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B3D7DF5B;
        Wed, 17 Aug 2022 22:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16CE6B820CE;
        Thu, 18 Aug 2022 05:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCBA6C43143;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660800017;
        bh=fkkxdAYZBd0succSznILtmnCD0uwUvqnBriG9qNrJ3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QkL10WUcgkLyy6qQQjCHQbrhcHnACkMENrsRotGVjN9A2h4Pzya2lXVMQwWA8We4M
         oA7oCDcFU1oLbpcfE/GHdBcOx+jzxNPlGmOjzXHwko5QH+lZB/V0x1bqRu1YzHryJK
         SdfsCQlUKCpgh3UEaw8XyZFzQhMu3/O9vDK19TxP50ZdkBKrQfwXFSbRHtyrA5qSN1
         kx4MaHHdP8l5YV8Ik2ralojeFoVQ1CkwZnKIIy+ihQHlH9UabhGZ4hzp2rtbUxdnxV
         8ZFdMJuETWzb31/ErqpVnGJWRpvm0KTGoDgQEm8OysUcmjZMd4xjRGQl1PPRTxbciR
         S2a8oWPARHMSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F96EE2A059;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: sja1105: fix buffer overflow in
 sja1105_setup_devlink_regions()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166080001765.8479.12928580419183112480.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:20:17 +0000
References: <20220817003845.389644-1-subkhankulov@ispras.ru>
In-Reply-To: <20220817003845.389644-1-subkhankulov@ispras.ru>
To:     Rustam Subkhankulov <subkhankulov@ispras.ru>
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, khoroshilov@ispras.ru,
        ldv-project@linuxtesting.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 03:38:45 +0300 you wrote:
> If an error occurs in dsa_devlink_region_create(), then 'priv->regions'
> array will be accessed by negative index '-1'.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
> 
> [...]

Here is the summary with links:
  - net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()
    https://git.kernel.org/netdev/net/c/fd8e899cdb5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


