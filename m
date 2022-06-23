Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2A557104
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 04:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377812AbiFWCUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 22:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiFWCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 22:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3678C3C71C
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 19:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4961B821B8
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A36EDC341C6;
        Thu, 23 Jun 2022 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655950814;
        bh=PKcgcr0Z8u1me4gJpcCR8oA90uqNC62/aeGWu03BcQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zc3HucFMW8Lo2Qhtyeyznoq9cRveOUuZ+VfcP2J0oRqQ1W9G8RUnIvR2ei+TwEh6L
         c0brrXyemdjzOGHUBYDTJ26Vi48a8zamAqPJJSxYMhCT9mynZXs/FTjZac/+eHXaNi
         fV162QsQiogdW+zqDjdMP1KDEYjbrN45LOJVy508kzKjJJoodCnMq4q1thsGZk0g2x
         9y9gmfhmrjhh5l1BV7SJ0F0ZMGo459aMM0YnCMN0AbpQCb/t7taBEA4FBIVRiZxRTr
         awj2myr/XvKFAEujdk2EBiFIpYD+hDzOYvwhdLHTovtwVSppXmWByv3RDshYLO88j6
         OxSAAU77yE1/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DCE3E574DA;
        Thu, 23 Jun 2022 02:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-06-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165595081457.12810.17993422036141536182.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 02:20:14 +0000
References: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Jun 2022 15:47:52 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Marcin fixes GTP filters by allowing ignoring of the inner ethertype field.
> 
> Wojciech adds VSI handle tracking in order to properly distinguish similar
> filters for removal.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: ignore protocol field in GTP offload
    https://git.kernel.org/netdev/net/c/d4ea6f6373ef
  - [net,2/4] ice: Fix switchdev rules book keeping
    https://git.kernel.org/netdev/net/c/3578dc90013b
  - [net,3/4] ice: ethtool: advertise 1000M speeds properly
    https://git.kernel.org/netdev/net/c/c3d184c83ff4
  - [net,4/4] ice: ethtool: Prohibit improper channel config for DCB
    https://git.kernel.org/netdev/net/c/a632b2a4c920

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


