Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008024C0627
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiBWAal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiBWAak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:30:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971F055BE4;
        Tue, 22 Feb 2022 16:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4F9ACE1990;
        Wed, 23 Feb 2022 00:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB88AC340EB;
        Wed, 23 Feb 2022 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645576210;
        bh=hLuXvhXfxzEk2dGr9uq59d1zVuMNbtQEpeGCRaPMEAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SDo/clCpGfI2Lw5OyioNU+xnmVasFb8UQ1OE/3XPn3ho5TQYRbf7cCkHlIx6r32TW
         0TH1FS/MmgAAKeACRtCre+xRXyM1QaRBsJfmRKGDcIEHn3Yi60xvkjRx23Q0FHhKL9
         rycKxgYU67M4GI6QmkKV5mLWlghF4bw6BT8hhjuSZdO7WcSZ/k/oRygviuDHpMGA20
         Ru0Bn1BJuTFE7cNp1r3TEbIHpWbUP+OIRySVUJY3LNdNtAdNJPIda51uSV4HVHfS3E
         iCS941W2DW/0BLjtnd15aMLioylcBigPBvkGZ6+YMTNE70LZceSPE5GssTJw7wgmXf
         kJA1oV1n1ljQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C089CEAC081;
        Wed, 23 Feb 2022 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] s390/net: updates 2022-02-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557621078.11578.8543243178652229719.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 00:30:10 +0000
References: <20220221145633.3869621-1-wintera@linux.ibm.com>
In-Reply-To: <20220221145633.3869621-1-wintera@linux.ibm.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        agordeev@linux.ibm.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Feb 2022 15:56:31 +0100 you wrote:
> Hello Dave & Jakub,
> 
> please apply the following patches to netdev's net-next tree.
> 
> Just cleanup. No functional changes, as currently virt=phys in s390.
> 
> Thank you
> Alexandra
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] s390/iucv: sort out physical vs virtual pointers usage
    https://git.kernel.org/netdev/net-next/c/ab847d03a5e4
  - [net-next,2/2] s390/net: sort out physical vs virtual pointers usage
    https://git.kernel.org/netdev/net-next/c/1bb7e8dff896

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


