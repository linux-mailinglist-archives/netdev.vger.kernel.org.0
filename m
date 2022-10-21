Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09624606F30
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJUFKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJUFKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF2118194E
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 22:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E282461DD4
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C63EAC43148;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=QHf7xMmpmbRoXZ6NfOljiydz4b8UJPqfj4UG6RRnask=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lvYVTPqm12Rve/3D/KPJgtGDv+NOhaPnIQRzHF0d/UQ5ws4eQtFjur4Hc4km79/Fw
         2zuwB8lW1TsOIoYvgVmOAeMSisFyRgtPxn2VI2qIOh7L737XA/A8/6Xf/R6mEYSxeh
         QqiWDaK2mxoh/+joW72kB8FfLWBQjtAB2uIuhSsReYSOT+RWOgiPkg0ZloqwKOp0J2
         8tBk8Dsnixh+nl3txstmamFRlykCbNBUXTOhnxWZtKt1IokoPpPQiuJHwsvwBco4Sd
         XG8hfdLN32swKZKn0f35hjD6KwR+EhI19okoiWeHyZ8mMIEsnQwuGP2FHEQYK5uqDM
         mG4Cl51XsCczg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE2BFE270DF;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902070.25874.7855284216211199816.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <20221020030505.15572-1-shangxiaojing@huawei.com>
In-Reply-To: <20221020030505.15572-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 20 Oct 2022 11:05:05 +0800 you wrote:
> skb should be free in virtual_nci_send(), otherwise kmemleak will report
> memleak.
> 
> Steps for reproduction (simulated in qemu):
> 	cd tools/testing/selftests/nci
> 	make
> 	./nci_dev
> 
> [...]

Here is the summary with links:
  - [v3] nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
    https://git.kernel.org/netdev/net/c/e840d8f4a1b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


