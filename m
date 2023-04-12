Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954FB6DECBF
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjDLHkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDLHkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:40:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D0340CA;
        Wed, 12 Apr 2023 00:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B852562EE3;
        Wed, 12 Apr 2023 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2014BC4339C;
        Wed, 12 Apr 2023 07:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681285219;
        bh=kzbDUOkw/dCJanRJR/vJc3tdbCAyGrnanls2wsewees=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bUjbDw3gsOoMlNByjE9KcEonqeqjc0fWDu4O1AXlIXWLmg9mRz8/ZKnd69AEhyxTY
         EWY3GZmMqCJligefYyrNnAABL6MmztbYnyPnMNmfKFRv3ldTV2kW4T/9PNrbAfT9jx
         fe0FA/1RimgBmY2EvrdLGT9uG/RW1XrdTSUflCAtSVkCIGw7v6t2w9M3Q/HmEpAswB
         DiYfMytRkqJz82qKQHjukErS5/EhzALZAnf9FVZP1l/bjc48l4fTXgoisBJWPIPHbC
         9N0b1qYmmXkCx8Imrb7FVDRZkNnOb3DKriD5y+iRnDna4SdggoVm6Y5RkklS1h91dD
         zJ6XunbxPtS5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05968E5244E;
        Wed, 12 Apr 2023 07:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] qlcnic: check pci_reset_function result
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168128521901.2410.5881347463116720583.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 07:40:19 +0000
References: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
In-Reply-To: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anirban.chakraborty@qlogic.com, sony.chacko@qlogic.com,
        GR-Linux-NIC-Dev@marvell.com, helgaas@kernel.org,
        simon.horman@corigine.com, manishc@marvell.com,
        shshaikh@marvell.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  7 Apr 2023 10:18:49 +0300 you wrote:
> Static code analyzer complains to unchecked return value.
> The result of pci_reset_function() is unchecked.
> Despite, the issue is on the FLR supported code path and in that
> case reset can be done with pcie_flr(), the patch uses less invasive
> approach by adding the result check of pci_reset_function().
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] qlcnic: check pci_reset_function result
    https://git.kernel.org/netdev/net/c/7573099e10ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


