Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF16E0D11
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDMLup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjDMLun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:50:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD766183
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26F2E60F82
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 886E8C4339B;
        Thu, 13 Apr 2023 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681386618;
        bh=ybbG/2ue/xWo1erfQMxV9TP0iVPZYWOBSCqt3OmN5rY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bPQL7WopbjYntG88smsxZKqTKSwzEqfBBd+82hJwXMdHgttJItuPTha5A4rDeK7b8
         q9k2mj19xJ91IyyI3j7O0FRuu5qKDfzSheylOR0TzcG4F3lo9qqL4ZXzCTp3lkcV20
         9NQIopkSQkmZNwz3TNiTx4HQEn9PQeb/82/oCKtuBwBGTa4iLcN5jplbnqFDXF2Uso
         SvPfv0PaaefoqfI9Jnt6xiQ7ZrzkzWh5RvckE0GWMfW1/gm4XEL/g2HEOBbfngoc9o
         7eNbDKtq03l88KRiippvNtcM3dc8DJmI85Q3h19gnUfSCjl0k5c6wEepf6GusGZgtJ
         GlvtKejg19y5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 711E8E5244F;
        Thu, 13 Apr 2023 11:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: use READ_ONCE/WRITE_ONCE for ring index
 accesses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168138661845.24203.13268208846073032886.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 11:50:18 +0000
References: <20230412015038.674023-1-kuba@kernel.org>
In-Reply-To: <20230412015038.674023-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 11 Apr 2023 18:50:35 -0700 you wrote:
> Small follow up to the lockless ring stop/start macros.
> Update the doc and the drivers suggested by Eric:
> https://lore.kernel.org/all/CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=2+aStsbbwpWzKHjk51g@mail.gmail.com/
> 
> v2:
>  - convert xdp paths in bnxt as well
> v1: https://lore.kernel.org/all/20230411013323.513688-1-kuba@kernel.org/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: docs: update the sample code in driver.rst
    https://git.kernel.org/netdev/net-next/c/50762d9af307
  - [net-next,v2,2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
    https://git.kernel.org/netdev/net-next/c/36647b206c01
  - [net-next,v2,3/3] mlx4: use READ_ONCE/WRITE_ONCE for ring indexes
    https://git.kernel.org/netdev/net-next/c/9a714997386b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


