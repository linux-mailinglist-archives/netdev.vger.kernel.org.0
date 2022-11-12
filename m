Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD20626714
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiKLFKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKLFKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC2232B9F
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3123560B07
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F3B7C4347C;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=w7P/SAinDEAgDPPwQy8+Do0gpe24YBgetfOBLdS4vjE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NHUbio8IL2URZe6Y0RG7Q4Af0GJJXf9U64SFbf5/pb/AHaNqcmjDAPjedq0p3d9XY
         ySzV4e3hp0o+1Eb48i74J/uvf+5f0Ybg0Kv6r6GhO6qPyZVylRUkfA5CY3q99knfDN
         u8Tnoqn7jZRS/Q62uPjQZVBajRMZFXhL7nyV9ZdPcxrwHd3St/YwSvrIZJ3FlxKd8N
         ArmXOsTdtthkSjKGv8E3+kdBO4gmTZavu9eMHrPsuPe9PAAQi105ETNYhWhJZ5Nz8t
         DIC0EdhCbp6DdFud3y/AGe+/ypvcwykyjL+iepmTqbnKEGlhUMaz68LUFVKFML4q9r
         rX+W3wOBDMVLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 530AFE270EF;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mISDN: fix possible memory leak in
 mISDN_dsp_element_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981733.20406.7244212929939531395.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221109132832.3270119-1-yangyingliang@huawei.com>
In-Reply-To: <20221109132832.3270119-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 9 Nov 2022 21:28:32 +0800 you wrote:
> Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
> bus_id string array"), the name of device is allocated dynamically,
> use put_device() to give up the reference, so that the name can be
> freed in kobject_cleanup() when the refcount is 0.
> 
> The 'entry' is going to be freed in mISDN_dsp_dev_release(), so the
> kfree() is removed. list_del() is called in mISDN_dsp_dev_release(),
> so it need be intialized.
> 
> [...]

Here is the summary with links:
  - [net] mISDN: fix possible memory leak in mISDN_dsp_element_register()
    https://git.kernel.org/netdev/net/c/98a2ac1ca8fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


