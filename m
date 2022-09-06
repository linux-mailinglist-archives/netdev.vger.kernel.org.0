Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70535AE379
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiIFIvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239582AbiIFIvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:51:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E235852C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46A7EB81668
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E58AAC433C1;
        Tue,  6 Sep 2022 08:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662454214;
        bh=yOLZ7AcCF0cierPuu8oUdqlx3PcYEjegtTXwluZuHXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UP8yWPF4Br/bi0BCJBuPRJISwS4Yd5Ii0JZ/MTbgeeXzzriJe9YKndQ1vzTNKuR3n
         1Wft8aa8lMFnqo40+Aa0BdofrYDjvvmqJ/Swcy+wfHIhdoSRrPTbxabs9/9OgnHreo
         SYh8OCToqWER/+UPQ5KdZsaRjDrabZT0daQkf8UmgO505yb0a8qHEMfct0gMo4Us/k
         eRM+s9d/cnSCwq+f3sXoXP8v6eKh62qTJgf8CA2/7n6FlT1YMrvT0yDPWAln5LBg/f
         rNMUz2Wy4YO+hLnCiuudkps+8k6G1A4oUE1G8s1+aXYFxhbspxa8tbRGwXqVcTQNao
         5jA5WTWM9Pt9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8CB3C73FED;
        Tue,  6 Sep 2022 08:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH  net-next] net: moxa: fix endianness-related issues from
 'sparse'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166245421381.19854.17893881918556206139.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 08:50:13 +0000
References: <20220902125037.1480268-1-saproj@gmail.com>
In-Reply-To: <20220902125037.1480268-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  2 Sep 2022 15:50:37 +0300 you wrote:
> Sparse checker found two endianness-related issues:
> 
> .../moxart_ether.c:34:15: warning: incorrect type in assignment (different base types)
> .../moxart_ether.c:34:15:    expected unsigned int [usertype]
> .../moxart_ether.c:34:15:    got restricted __le32 [usertype]
> 
> .../moxart_ether.c:39:16: warning: cast to restricted __le32
> 
> [...]

Here is the summary with links:
  - [net-next] net: moxa: fix endianness-related issues from 'sparse'
    https://git.kernel.org/netdev/net-next/c/03fdb11da92f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


