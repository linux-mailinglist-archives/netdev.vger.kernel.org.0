Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38F68FF94
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBIFAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBIFAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:00:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8156D16AEC
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D276B81FEF
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EA84C4339C;
        Thu,  9 Feb 2023 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675918819;
        bh=tpMzaKnRbdTUFW/3oeWNrTpr4LqFSgj8c4NlzAl0ahE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IqZWmFDdGYDMh8i9P6eIjv3a1Aw4PbMsGN/wqmpjzwdo1orosxFQpI7BHMcD/3jTb
         HxRVgkHVDkiwzaQxTdNZFrKjkXaEClmH8uktP7oH2hzQyRqx4ApNB/OvWtjnvra86E
         KaojgMt7KgWbPqIkt5QJ/F8A2O4+eWuaG0/taIdnrqlMtO7UHotnaCNsJsY/QGREq8
         G1h5kmi1PpSL4ej+vZ7y16TNUliSsY8yE6nXdwKphjRX5P841JN2+uQaxSdWJVQjnO
         SR8+aBv1TkmMD5JPeRP5/tH30Mg9za05+WGAa+91FaLvmgChRRawsc6LTNUWlap4uE
         u9jN5bEKhA0lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63176E21ECB;
        Thu,  9 Feb 2023 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: txgbe: Update support email address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167591881940.30038.11730552713623976412.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:00:19 +0000
References: <20230208023035.3371250-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230208023035.3371250-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 10:30:35 +0800 you wrote:
> Update new email address for Wangxun 10Gb NIC support team.
> 
> Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  .../networking/device_drivers/ethernet/wangxun/txgbe.rst        | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net,v2] net: txgbe: Update support email address
    https://git.kernel.org/netdev/net/c/363d7c2298e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


