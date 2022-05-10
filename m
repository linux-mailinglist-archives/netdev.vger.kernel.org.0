Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2436A520A83
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiEJBOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiEJBOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996092BA9B4
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35001615AC
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E679C385C2;
        Tue, 10 May 2022 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652145012;
        bh=Pf53W+P3KTtIrm/dUH8KynPpBQf0uaicEUFWlfqxmuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NlurrFvpoFeucgJtff7dVSJ6Q9nlrB+OkFLEB0+peSEuUAxBji2zSJcuVM/677WOj
         NS4IQVs2wjO3ey+31DH9GWfyScdMKtvODi80ht/+a5TZ0O0179w+LNYs4zGqDRpaLV
         IS3nRHIDWve0iyxoTJau4X6ZNhGCTcjKBo4Jzm+eFgupkZ0wZliRQGz1sn/5FdPuDl
         MzZifkdHtQwJMkEjoCuTmPUcm2j6zXATMQPoHPQU7lJU+T1PICFkYVw6Y9ZdPNZ1zl
         iZT7Fg15aCFNSrk7IzNkZU9ouS3X3f6JxxkjYZ+DXEs9pLpii5PCecXtnSo/wVOoVv
         ALV8jy60Qs6Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A798F03876;
        Tue, 10 May 2022 01:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates
 2022-05-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214501242.9968.13113084735980958108.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 01:10:12 +0000
References: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        richardcochran@gmail.com
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

On Fri,  6 May 2022 10:41:26 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Ivan Vecera fixes a race with aux plug/unplug by delaying setting adev
> until initialization is complete and adding locking.
> 
> Anatolii ensures VF queues are completely disabled before attempting to
> reconfigure them.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] ice: Fix race during aux device (un)plugging
    https://git.kernel.org/netdev/net/c/486b9eee57dd
  - [net,v2,2/3] ice: clear stale Tx queue settings before configuring
    https://git.kernel.org/netdev/net/c/6096dae926a2
  - [net,v2,3/3] ice: fix PTP stale Tx timestamps cleanup
    https://git.kernel.org/netdev/net/c/a11b6c1a383f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


