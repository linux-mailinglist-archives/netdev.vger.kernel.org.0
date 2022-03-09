Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B446C4D28F8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiCIGbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiCIGbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:31:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E5E137758
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FB186193B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69122C340EE;
        Wed,  9 Mar 2022 06:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646807410;
        bh=ODP6HHL/bG/nIaJqc54SUFNvOTiakf/KUNV36gjBKgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q/6twDM0O0VBgJ1yWGwDPr+cGj16jSSXqXDd0HXDSNRo9MqNefZ4ENlwpvzXB1UL/
         mcSY+LkBAsqoZyL+xO5R1gzJeB5OEVs1o66z4K8Ins+CC4X50gcS9+GqFYo5OQqTWM
         l+IcUBRZ98smWImc8b3kB4CWMTJs/6pIsnbGBrBu8xTcrT6xr13wkbhP4Dwcs14/GK
         9cfOcnLPCbZSTwKgf4ZUpPifDM4rtxfjDdBZbS9QNaNv7Xu3maZ1htSxwHMk0COs93
         TOZiC8EL7Pgo4EODUTaOoMf9v7nQghZ2hEg7wetcd2alNJ0GLUFAlSZcpP0y3O0M52
         mTCjXcae/Hr3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B568E8DD5B;
        Wed,  9 Mar 2022 06:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] tipc: fix incorrect order of state message data
 sanity check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164680741030.15140.10678622839762911773.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 06:30:10 +0000
References: <20220308021200.9245-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20220308021200.9245-1-tung.q.nguyen@dektech.com.au>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, ying.xue@windriver.com,
        jmaloy@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 02:11:59 +0000 you wrote:
> When receiving a state message, function tipc_link_validate_msg()
> is called to validate its header portion. Then, its data portion
> is validated before it can be accessed correctly. However, current
> data sanity  check is done after the message header is accessed to
> update some link variables.
> 
> This commit fixes this issue by moving the data sanity check to
> the beginning of state message handling and right after the header
> sanity check.
> 
> [...]

Here is the summary with links:
  - [net,1/1] tipc: fix incorrect order of state message data sanity check
    https://git.kernel.org/netdev/net/c/c79fcc27be90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


