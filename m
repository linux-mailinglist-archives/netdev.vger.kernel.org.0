Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF83C598B32
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345534AbiHRSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345495AbiHRSaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CABB6D33
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25800B823D1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3583C43470;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660847417;
        bh=KrGn3GdocbVp7YqGh51ZvdpLjXxDkJags81UjFXyqKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JbVkiFjCXlrOF6tF0GDk5FSRbQH/rJHT3DxeAJnskYJ62RcmfUINmBkRlS669VdRA
         wtsyJnY8Zoc8d/dwdYhya4ETmGxWMGmgGNwscgVk/EOFBAyU4njjjQtxtdFVdWPyak
         q/t9s7G+6LUu/SaQVjsiEU3gTBJ9DWTovsWrN5VigI2ikWbFuTg4p3A+0K5jWYzRbF
         vu1JC+/R0e9b3wg+oUeac9ezhmXRU1RiJNU7HmM8EAJJK9InrbFHnMgzZW+fjt8Qe/
         Q057oqctn46rP8Mm7Jbut7Glb+Yd9qlbgjzRjwPv6dphk0qF5sEhFf2QOSnXt/SZfV
         ppwbgNM5AuZEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A56C4E2A057;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: moxa: MAC address reading, generating,
 validity checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084741767.25395.13157271072201424538.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 18:30:17 +0000
References: <20220818092317.529557-1-saproj@gmail.com>
In-Reply-To: <20220818092317.529557-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        olteanv@gmail.com, yangyingliang@huawei.com, paskripkin@gmail.com,
        huangguobin4@huawei.com, yang.wei9@zte.com.cn,
        christophe.jaillet@wanadoo.fr
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

On Thu, 18 Aug 2022 12:23:17 +0300 you wrote:
> This device does not remember its MAC address, so add a possibility
> to get it from the platform. If it fails, generate a random address.
> This will provide a MAC address early during boot without user space
> being involved.
> 
> Also remove extra calls to is_valid_ether_addr().
> 
> [...]

Here is the summary with links:
  - [v2] net: moxa: MAC address reading, generating, validity checking
    https://git.kernel.org/netdev/net/c/f4693b81ea38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


