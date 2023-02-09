Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0741B68FFA5
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBIFKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBIFKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F221ABE1;
        Wed,  8 Feb 2023 21:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392D761910;
        Thu,  9 Feb 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BD4BC4339C;
        Thu,  9 Feb 2023 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675919418;
        bh=SSOMeyVd4NA7ZgP7ISYtRk3lwqy/HPA34kHr4JFJPIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fVStH8JOzrlLfPh9aZ956cmqZBjhpF9IXTUzmuqi+gM5P3IDTynoEUMZBRzLAgLxB
         j3CPCCT9lPk72h6Nkp9/kX+Yc3h4PTey7ukilXrs7wr0ysrY9lw+QX/QwVUd+TC3us
         aMTpugvfGcMzYrrqfEHwgfuq04xb55XAtU6ZlxER8hCqj6qj3xm3TzDnt+DaxUn0oB
         plax91Wrb4u3N3+tee6kKSlgv1UNvtIGfeh9p9AwaqhD2Oauo9vo0FJJYw3nyGWvkj
         4h6hXybcAOpz4yNbFym6pTlJlq0dbDT4v25kHobMiPKQ9O7TPGa2qu83NvEdl78b4l
         +E7Kp/4T9e3mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71CB0E4D02F;
        Thu,  9 Feb 2023 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: libwx: clean up one inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167591941846.2876.7383521489488340202.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:10:18 +0000
References: <20230208013227.111605-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230208013227.111605-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiawenwu@trustnetic.com,
        mengyuanlou@net-swift.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 09:32:27 +0800 you wrote:
> drivers/net/ethernet/wangxun/libwx/wx_lib.c:1835 wx_setup_all_rx_resources() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3981
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: libwx: clean up one inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/f978fa41f66d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


