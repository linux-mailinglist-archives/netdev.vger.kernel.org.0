Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F594FF5B8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiDMLcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiDMLcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745F52AC6F;
        Wed, 13 Apr 2022 04:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F6861DC6;
        Wed, 13 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB5E6C385B3;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649849412;
        bh=dx7OUX8/yekR+5yZ3BY30eSyyVdl4N1P7VEeD7kiFeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gNiau/O2B3bWi89MNgvZK6Pg8+zNFYhixJtWOmqHdX1uyxz06R2KoiHgumx0sjt1/
         YcnJddWnfp4FWVavEyzc1tzoXrtRKrn9mWphGDFxH2sfOdDlu6PvndSZFF4V9ET7j4
         ArARo02UOSzSN0Y3+hQzy9CqJRyzZutOJi0Tse+G0fy7NLYHmYmfRsUSy2RRBalyA2
         1AdSJcd5+Jv5QwLNjZAkYucJ/VODyDnxZQXSBnKoZw7V0wDs9rXRB+4A5aZg/sQIu+
         zAZEaDSpMQ+OA93bFLDE0hyuBv1R/ecuCW05jOZDLuL1k99kRBuwfwUusav1lgcyt2
         CumZKKx6RMhqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F4A1E8DD67;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: NULL out the dev->rfkill to prevent UAF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984941258.14313.4753120813378621079.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:30:12 +0000
References: <20220412053208.28681-1-linma@zju.edu.cn>
In-Reply-To: <20220412053208.28681-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Apr 2022 13:32:08 +0800 you wrote:
> Commit 3e3b5dfcd16a ("NFC: reorder the logic in nfc_{un,}register_device")
> assumes the device_is_registered() in function nfc_dev_up() will help
> to check when the rfkill is unregistered. However, this check only
> take effect when device_del(&dev->dev) is done in nfc_unregister_device().
> Hence, the rfkill object is still possible be dereferenced.
> 
> The crash trace in latest kernel (5.18-rc2):
> 
> [...]

Here is the summary with links:
  - NFC: NULL out the dev->rfkill to prevent UAF
    https://git.kernel.org/netdev/net-next/c/1b0e81416a24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


