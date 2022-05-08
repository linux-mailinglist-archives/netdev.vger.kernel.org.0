Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034AD51F1B0
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 22:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiEHUyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 16:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiEHUyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 16:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DF1559E
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 13:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F206660C70
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 20:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E2F1C385B0;
        Sun,  8 May 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652043012;
        bh=kx8McznUoc8cUpDOcHoAnxPp2JUZzdIKYXu+KKgm4aY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ananhtyd7qlnfQLYBuSI2AZ9n7Z81H6wC2ft32IOxSe6nycm0FkbDaplzPNqyzDRl
         go5YQ6o5BLgBlSYI5QKnJgEzPUJWlurLK9S6S12X4Ns+dD/eABR2p8Ui0/iht1OV9x
         Z7EsN4KqKijYfyyUHan8M/uj5deRSJjanp01jAqsk5kmII4go0HOSc5BI9Sv4pIalz
         i9YkD5WwNInTdqxFLoZY/K/5ndKPWFep50tLkutpNDxiYN/4Vob4cN7AVkGo4VPDYR
         KsAnw4rM9NU1tMDFgOyZaXLFckHcALzuQGQA54Hhro2CAzGJvM26ZJQxEN5iIGvjpY
         R7vEpkFwzKUEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45427F03876;
        Sun,  8 May 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] ethtool.8: Fix typo in man page
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165204301227.30767.14561626833551351457.git-patchwork-notify@kernel.org>
Date:   Sun, 08 May 2022 20:50:12 +0000
References: <20220404224005.1012651-1-vinicius.gomes@intel.com>
In-Reply-To: <20220404224005.1012651-1-vinicius.gomes@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz
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

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon,  4 Apr 2022 15:40:05 -0700 you wrote:
> Remove an extra 'q' in the cable-test section of the documentation.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  ethtool.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [ethtool] ethtool.8: Fix typo in man page
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=e1d0a19b6a29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


