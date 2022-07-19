Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F6E57917A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiGSDuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiGSDuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15512CE17
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE88DB81914
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C730C341CB;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202614;
        bh=Zv2+SNScZXcXOtotDTFf8jkq2CwZb3sJPlC7t5Bxb/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RFBnC5QCQZ4CNBEcJ1E44dS9e3G78NRuxYricaqSsb3i42u3mfYr/F25ZocTTO4i5
         Lv/R42hF8HjOJmU2vDwjG8N0BVo4wxsANt14FmoE6Afo55quQNGbIY6TpBkARCvl/2
         JY5YprZ5LJT1sRW4j6Q1b9bi7EiD2JYOS9yxVpsEUnwiSGMX7aj3lSCnibwJk1pgkw
         RTOu+zx0Gq15OQC6AwZUHOhRij6rTPlT+0+i+6J2lrWIuERm1XIHbre9va/Qg2a6DC
         /ERJjry8NheeDAHcnN+m5oX8nV6fuP98MyMeQXxYqr7bwAXVLcVP4i7Aj988V9MMIi
         u13N7b2Y3Nh8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F970E451BA;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vmxnet3: Record queue number to incoming packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820261432.2183.3392083130011514670.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:50:14 +0000
References: <20220717022050.822766-2-andrey.turkin@gmail.com>
In-Reply-To: <20220717022050.822766-2-andrey.turkin@gmail.com>
To:     Andrey Turkin <andrey.turkin@gmail.com>
Cc:     netdev@vger.kernel.org, doshir@vmware.com, pv-drivers@vmware.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 17 Jul 2022 02:20:50 +0000 you wrote:
> Make generic XDP processing attribute packets to their actual
> queues instead of queue #0. This improves AF_XDP performance
> considerably since softirq threads no longer fight over single
> AF_XDP socket spinlock.
> 
> Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>
> 
> [...]

Here is the summary with links:
  - vmxnet3: Record queue number to incoming packets
    https://git.kernel.org/netdev/net-next/c/bdeed8b0958c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


