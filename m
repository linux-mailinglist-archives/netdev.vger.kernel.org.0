Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B9263A6CF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiK1LKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiK1LKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:10:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993A167D4
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F36F9B80D47
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99383C433D6;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669633831;
        bh=fOjsi0iGI85AQ4DAURLcIdpNX9GY6k9KslooUp1aOuA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A/3PA51qxl7Vjo+uoqx++7r6UEKwlZIVcGlDAY2Zb6iy/3+/ZJrrNNYlcrDev/+ug
         rztYpsM5uh/Vez7+qLJsL3ujqrYG535qC+3++YpzLwcveauD8iUA5WV7jBrOVtKx2S
         hBlrZOwnyNtxIch4uiTVWld/BydsFEIEziDW2U+uHjkmT6h/9Rlhuwla3ZOrTdOpZ8
         5HHlYamqqlZmmfr4j0U3jaOI14v1KzkcgepuWdxbPYk02+oiRAlMMKQUz2qDa5B6xA
         393fsUlCyuxj/9mLSVQz1ikmJZffWch8ZrfZvrOAtKjUYrn8GeQRX9ipr8zGFdyoQh
         A+ZTdmiXgfMbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 783EFE270C8;
        Mon, 28 Nov 2022 11:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: net_netdev: Fix error handling in
 ntb_netdev_init_module()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963383148.22058.3258303081621006754.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:10:31 +0000
References: <20221124070917.38825-1-yuancan@huawei.com>
In-Reply-To: <20221124070917.38825-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     jdmason@kudzu.us, dave.jiang@intel.com, allenbh@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nab@linux-iscsi.org, gregkh@linuxfoundation.org,
        ntb@lists.linux.dev, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Nov 2022 07:09:17 +0000 you wrote:
> The ntb_netdev_init_module() returns the ntb_transport_register_client()
> directly without checking its return value, if
> ntb_transport_register_client() failed, the NTB client device is not
> unregistered.
> 
> Fix by unregister NTB client device when ntb_transport_register_client()
> failed.
> 
> [...]

Here is the summary with links:
  - net: net_netdev: Fix error handling in ntb_netdev_init_module()
    https://git.kernel.org/netdev/net/c/b8f79dccd38e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


