Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7B44F8E9A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbiDHEMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiDHEMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:12:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751781EB805;
        Thu,  7 Apr 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E472DCE29FF;
        Fri,  8 Apr 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 450C4C385A3;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649391012;
        bh=/ocmwyPmcxJaE7A3jgFW3oPLW1FUfozUVp4GcoMvkoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SU50/V/1U1F4SxYfBIQWfbo0x2uJIoLXzsSxn2er9wPOXoHmtlBSuG5CIrrohjVTb
         nNg9fEtBcYEMA9yFHB33kFDTr1uKGWwVTcUqvHW38MnmsXHOBQinc6bGlar7TYBpst
         NPG8GubMiAxfSQQUoMX6MxeKQYUQHHwbzRvZz4i2NmjLG5L0IHOGxpZ98gmC743coz
         o1gV3lGBsKH1np/fryx2V6nRC3KtwEJ+yjt0DUzZciS1Nmak3kEg2r41Bc/13SIobC
         7XvUq0Ggf4JUvRSDa2EHhww0FP7BtMsq57lFBgD1C7Im3Md4qveOx/FzyzySfXmZTC
         cMpeY/dYt35kw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22C9BE85BCB;
        Fri,  8 Apr 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] qed: remove an unneed NULL check on list iterator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164939101213.29309.15840560082982456814.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 04:10:12 +0000
References: <20220406015921.29267-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220406015921.29267-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Apr 2022 09:59:21 +0800 you wrote:
> The define for_each_pci_dev(d) is:
>  while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
> 
> Thus, the list iterator 'd' is always non-NULL so it doesn't need to
> be checked. So just remove the unnecessary NULL check. Also remove the
> unnecessary initializer because the list iterator is always initialized.
> 
> [...]

Here is the summary with links:
  - [v2] qed: remove an unneed NULL check on list iterator
    https://git.kernel.org/netdev/net-next/c/4daf5f195630

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


