Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92504517A7E
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 01:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiEBXOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 19:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiEBXNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 19:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCC7E8E;
        Mon,  2 May 2022 16:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29132B81A9A;
        Mon,  2 May 2022 23:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D54D9C385AC;
        Mon,  2 May 2022 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651533011;
        bh=5lnWzmvSk6zn2tBAVFvoa7bnbfAdpYURPgmkEcJ1Og4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gLGzRbaVMHp4HcQht5paffi+MZ1YiJCcKRbpiHx0wVuy4/Dzc1k6rUqIHEWqM4obQ
         4VWN5K0Ddt47zpFoW+2tG3m1vr7VBfaW0NZNuNKBYelco8BprLSBL+MZVTIns/DPmS
         /SPmDFzMMqIZtTvwOFuvDh3NA4IUulm/PGIr5Gi4DQ6YIc5qPUfB/RtFZvndwtGxX4
         Hg81pAxiANXJpbBASo3WH7eTEcxueFzlwPf9Qdjs8dvZQok9OKo3jso5XEAEy1Hmm2
         MKIZGkec/VSahLm8yuG9f0zO9a4xpAno7+DR8el0YZb6TpiZzxWowMwo0QRYIr3STG
         1cTesUdN4gnRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B37FCE6D402;
        Mon,  2 May 2022 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165153301172.26672.10368914431147889031.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 23:10:11 +0000
References: <20220429053802.246681-1-jianghaoran@kylinos.cn>
In-Reply-To: <20220429053802.246681-1-jianghaoran@kylinos.cn>
To:     jianghaoran <jianghaoran@kylinos.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 13:38:02 +0800 you wrote:
> ARPHRD_TUNNEL interface can't process rs packets
> and will generate TX errors
> 
> ex:
> ip tunnel add ethn mode ipip local 192.168.1.1 remote 192.168.1.2
> ifconfig ethn x.x.x.x
> 
> [...]

Here is the summary with links:
  - ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL
    https://git.kernel.org/netdev/net-next/c/b52e1cce31ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


