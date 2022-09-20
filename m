Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5215BEEA5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiITUk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiITUkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:40:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C35A4D14E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6656CCE1B77
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F447C433D7;
        Tue, 20 Sep 2022 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663706419;
        bh=QLqPFwx9A9HudgsacQgkZi0c5ydnYhF7VAuF11yvHWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N+NtMB3GV3AY3WP4sLxwejZ/N7jt8m5YZ5cBJv70jf37d7Y797MT2gyvk9FexXU2G
         6BF+WumwDa5H2EUQpJLWuN7xY9hgx+T4bfZmE3Qz0zplAcTAOjTFO9P8gfQ87W0ONx
         TxEFddfVMVB6AuxBmcyHTHfROaxiVaZlCPh4mt6OlFidFFbm2QgWEXLqGTMyqVIIk4
         hh0HUs3V9WjK8n/F6L2OQEemgxkbpYHrqIv6u/FNf6eUDWG4e/T2gTNrN8OHyMiVaD
         81KSqsW8gCpo2zdD8P1U4gba+0ECq2p1eYluFfJA/t4QC+ANjDzp/zz9PdJGydW5Sq
         /43jv8d1bomJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E22BFE21EE0;
        Tue, 20 Sep 2022 20:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] nfp: flower: police validation and ct
 enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370641892.8632.8260909998214462880.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 20:40:18 +0000
References: <20220914160604.1740282-1-simon.horman@corigine.com>
In-Reply-To: <20220914160604.1740282-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        hui.zhou@corigine.com, ziyang.chen@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 14 Sep 2022 17:06:01 +0100 you wrote:
> Hi,
> 
> this series enhances the flower hardware offload
> facility provided by the nfp driver.
> 
> 1. Add validation of police actions created independently of flows
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] nfp: flower: add validation of for police actions which are independent of flows
    https://git.kernel.org/netdev/net-next/c/9f1a948fd6ef
  - [net-next,2/3] nfp: flower: support hw offload for ct nat action
    https://git.kernel.org/netdev/net-next/c/5cee92c6f57a
  - [net-next,3/3] nfp: flower: support vlan action in pre_ct
    https://git.kernel.org/netdev/net-next/c/742b7072764a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


