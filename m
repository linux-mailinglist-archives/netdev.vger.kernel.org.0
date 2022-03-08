Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE094D155F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346076AbiCHLBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346100AbiCHLBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:01:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E94242A25;
        Tue,  8 Mar 2022 03:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1BCF6158E;
        Tue,  8 Mar 2022 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2168BC340EE;
        Tue,  8 Mar 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646737211;
        bh=CnQvcYlfy6NQS5oYY42esLggoTKh01fuvzqknQEQlsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M0b56vP8IrfA9Vnvrt7WDu0C9NuJ+y7ZvAtusB3NLO7uyAM/JXjCXsSvb51gh9vLV
         u7ERUrICtE5HXD5NRi1xBX6SPv5Q2YL/yJRdwiBf4Kz4e+jhSC94cPtl2i9AEi8qEw
         rsy4eaYBAt7X9JtHqaUb9K2Wdr85oTBf8nZSlbeO1REd22F8JtUbasNf8OhhTbEAdA
         Ha53pqRxKsMXARBtXE1MF/iAzwxjI2j9/uRY/Nyjgnjv/sbbM0UTyqc09e6kcmaCOp
         ehS3SKEsju6ot+mVqfHmbf+fjVNHZxWZQowiq1nc2cX+cnHjulhQ0kzogc+nnbVb7c
         Lvvo7fG96uJBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03185E6D3DD;
        Tue,  8 Mar 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: tag_dsa: Fix tx from VLAN uppers on
 non-filtering bridges
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164673721100.15678.16907307845571927216.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 11:00:11 +0000
References: <20220307110548.812455-1-tobias@waldekranz.com>
In-Reply-To: <20220307110548.812455-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  7 Mar 2022 12:05:48 +0100 you wrote:
> In this situation (VLAN filtering disabled on br0):
> 
>     br0.10
>      /
>    br0
>    / \
> swp0 swp1
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: tag_dsa: Fix tx from VLAN uppers on non-filtering bridges
    https://git.kernel.org/netdev/net-next/c/6c43a920a5cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


