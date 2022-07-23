Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C922957EC21
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 06:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiGWEuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 00:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGWEuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 00:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61097BC9E;
        Fri, 22 Jul 2022 21:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6B3F60AFB;
        Sat, 23 Jul 2022 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3919CC341CA;
        Sat, 23 Jul 2022 04:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658551814;
        bh=2R81MEdDkrmcUH5TdYiN7+26p1LVv5E21UBdKcDEb9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p2QyugrLWntvHVACuNZcIGx/xTvbjy1BNP82xl+gjDyo+zW/fcw9lRYPZKSmrgkfn
         qSHTgJcFIPt9ZfJHidsQ/Je+Y8S/JnqkRt/kNgN677zSotRW85mO4DliVkiCFJSIgW
         B5emUb8q3Aldnjx6Utx0gZ99PPIqV+5KQSND47rq/5vR1phb+llHqkAni7dtDrHu2h
         mUwaKVRFGWwLsW8jdGVcEG+pjTcOACFedEa4O/b2D3H7LdG97+vh1NS+1LFf8tGQ1i
         prry+xKmAKc2KGQOR74Nq9HBumRBV1FOhOQoB3RG50poPoiUkWVeNyRBQ7mObxNA37
         HAOvw64jvIZ+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20BB0D9DDDD;
        Sat, 23 Jul 2022 04:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/5] net: usb: ax88179_178a: improvements and bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165855181412.32013.12318729017636886593.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jul 2022 04:50:14 +0000
References: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
In-Reply-To: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, justin.chen@broadcom.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Jul 2022 17:28:11 -0700 you wrote:
> From: Justin Chen <justinpopo6@gmail.com>
> 
> v2
> 	Remove unused variables
> 	Remove unnecessary memset
> 
> Power management was partially broken. There were two issues when dropping
> into a sleep state.
> 1. Resume was not doing a fully HW restore. Only a partial restore. This
> lead to a couple things being broken on resume. One of them being tcp rx.
> 2. wolopt was not being restored properly on resume.
> 
> [...]

Here is the summary with links:
  - [v2,1/5] net: usb: ax88179_178a: remove redundant init code
    https://git.kernel.org/netdev/net-next/c/9718f9ce5b86
  - [v2,2/5] net: usb: ax88179_178a: clean up pm calls
    https://git.kernel.org/netdev/net-next/c/843f92052da7
  - [v2,3/5] net: usb: ax88179_178a: restore state on resume
    https://git.kernel.org/netdev/net-next/c/c4bf747c6889
  - [v2,4/5] net: usb: ax88179_178a: move priv to driver_priv
    https://git.kernel.org/netdev/net-next/c/2bcbd3d8a7b4
  - [v2,5/5] net: usb: ax88179_178a: wol optimizations
    https://git.kernel.org/netdev/net-next/c/5050531610a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


