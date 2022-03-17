Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385144DC350
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiCQJv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiCQJv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A888F19B099
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D56661771
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE6EEC340EE;
        Thu, 17 Mar 2022 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647510610;
        bh=0JjyJ/ykY1JEPo2srSyATTFiydftt3X5M/G4NHDRbho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TwOIa42gRvMKm6A9ed1GCRPC1B0ef7+0/TVFDWchoj0sYY3NYqx2qx53VAIg9nlE7
         Tk/4plkPn6GkhR+nA/So3FFIv73gTziQnDyo9mudSQ858uW9390G1sgA5eqAvCW/MW
         qdGXeGp3FAjQPnfyimRuvUr5ltl729M5P6f5HYsreCL9VhFelc8vNmdpyNn6FKnVwN
         qP5Qbi7FsiKRVb2LhtdclNLz4Ne+jVm/LgDxk0unQ2f9steVF9Ymhe1RjF4fIO897Q
         czplQrsQIKjIYZa1Tqug2VsuALrN9tXi2n2UsAcO5CaZgGG5HKKhlx1s1w9sr8pRwQ
         Ea2o+o/uWv11w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EEC1F03841;
        Thu, 17 Mar 2022 09:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ptp: ocp: Fix PTP_PF_* verification requests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164751061058.337.5600933783600607594.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 09:50:10 +0000
References: <20220315194626.1895-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220315194626.1895-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, kernel-team@fb.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Mar 2022 12:46:26 -0700 you wrote:
> Update and check functionality for pin configuration requests:
> 
> PTP_PF_NONE: requests "IN: None", disabling the pin.
> 
>   # testptp -d /dev/ptp3 -L3,0 -i1
>   set pin function okay
>   # cat sma4
>   IN: None
> 
> [...]

Here is the summary with links:
  - [net-next] ptp: ocp: Fix PTP_PF_* verification requests
    https://git.kernel.org/netdev/net-next/c/05fc65f3f5e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


