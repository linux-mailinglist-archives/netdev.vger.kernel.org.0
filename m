Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD3B5A6125
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiH3Kut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiH3KuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D76222A2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1EB260A39
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F5E3C433C1;
        Tue, 30 Aug 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661856615;
        bh=tUsGTsmuj7k1lj70B65ASsZCYFmc5sESj8JtU5IxKqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dw1zf3guSXa4VP46QkE9ND41fsrj8UYmIobbEoPNLjrrgTEG8c8CA3vQOxvYRAfPA
         vnzHuDNrwhwZ1YcqB/Eu1nWAGYKdxPzD1XdlmqjkQtJ9zrUsHwf0ltkj/ZW3Ii3Qwk
         nxvjGZZ6J/uw7yfkw6GsZZZaWL5sn52FPQkzvynrlzfBSdIC5Wt2UNS88xNtjnWLnk
         kyAgn2xIf59k48NBQefh/p7otcy24Z0GFtPNS6gdKHHUR7a1vshtsaK2YgVCaAa4OO
         g7dfcDOsMVjKUxI7r0nAhVGeqwZZYJKFtjZr6uYDpgHuofxHD/+G7FpF8kCpErIpPS
         /fLG4Wp2vlTvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31E6CE924D8;
        Tue, 30 Aug 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1] net: ngbe: Add build support for ngbe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166185661519.17237.12818688439540833057.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 10:50:15 +0000
References: <20220826034609.51854-1-mengyuanlou@net-swift.com>
In-Reply-To: <20220826034609.51854-1-mengyuanlou@net-swift.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com, andrew@lunn.ch
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

On Fri, 26 Aug 2022 11:46:09 +0800 you wrote:
> Add build options and guidance doc.
> Initialize pci device access for Wangxun Gigabit Ethernet devices.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
> Change log:
> v3:
> 	Andrew Lunn: https://lore.kernel.org/netdev/YwfltvdQaHUNKdAh@lunn.ch/
> v2: address comments:
> 	Jakub Kicinski: The length of the '=====' lines needs to be the same as the length of the text.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1] net: ngbe: Add build support for ngbe
    https://git.kernel.org/netdev/net-next/c/e79e40c83b9f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


