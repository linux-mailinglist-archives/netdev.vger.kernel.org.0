Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906AE63EF5D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiLALXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiLALWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:22:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E5A6CE7;
        Thu,  1 Dec 2022 03:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FEA8B81F12;
        Thu,  1 Dec 2022 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 013A6C43146;
        Thu,  1 Dec 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669893616;
        bh=jzXAN5XgytwdU3x//EumIzh1xUo/7W9XJaN6OHgdMkU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hyNE0ReKiChBKVHdAMiBIDloAtQl/F9Lb83Im1BL3pOZigrBboeyROjd0wdi6Hqxj
         qAwtyHvoPhDwqwYx5STvQs5up+kKylZG4uCV26dgS3KeLkxKy5f0ciBDmXZM1jZCuP
         NYGiWu6HDoLHwCN4q33UId58s1Lv7Za1hGlb94lTYpOu9hOuR2ui6N1RTDExpHHOgC
         qdLYgYZYKM+FJ91LW57AKZVhnSmmTu0DwgU7cwB+nMsaZgaxNuKJmhav2aftWIo0De
         yQkCCpYmLXPmjtVYR82eMv6IE9Xr0QIKNOF85ipCbjld6pkpuhhLtm77sTUq7WKb6w
         LCX/YuvcM/AyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D98ACE29F38;
        Thu,  1 Dec 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: sparx5: Fix error handling in
 vcap_show_admin()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166989361588.14994.7087037126362934717.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 11:20:15 +0000
References: <Y4XUUx9kzurBN+BV@kili>
In-Reply-To: <Y4XUUx9kzurBN+BV@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 29 Nov 2022 12:43:47 +0300 you wrote:
> If vcap_dup_rule() fails that leads to an error pointer dereference
> side the call to vcap_free_rule().  Also it only returns an error if the
> very last call to vcap_read_rule() fails and it returns success for
> other errors.
> 
> I've changed it to just stop printing after the first error and return
> an error code.
> 
> [...]

Here is the summary with links:
  - [net-next] net: microchip: sparx5: Fix error handling in vcap_show_admin()
    https://git.kernel.org/netdev/net-next/c/682f560b8a87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


