Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24FD538F04
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 12:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343504AbiEaKaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 06:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245757AbiEaKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 06:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235B09A988;
        Tue, 31 May 2022 03:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7EBB810C0;
        Tue, 31 May 2022 10:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36F7EC34119;
        Tue, 31 May 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653993012;
        bh=wg2sl+isk2wcIjHnymrtFl8X78UHFOBNSUf0axjQw+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=anGJc+2cxPX+nosq2cib86B8rmiImOT6yNqZI9ynm+WEFBZFixNBfSbFcr9FSsCjC
         ovlPkbCAJUEHsDgjvaaHIOrDpIEst72MkViW6yg3RKEue1Nm0AnA9YCyfi/JHhZWaH
         xTNbIYI1OF/+DgRSx1WSQq7E4wKcSYLFzvYA8UV1ZhTE/Cq2Xcp0HIipJ+PuD2NS6T
         fVpcciGbTJsRDhXsYpZAWfuFQnd34LWQbGLZxNjneA0sal3hYWAG2ehQn6InJQXgay
         Tp11gCxYvHpZHjLUQ5qN2PJKxA+3/HRPlX44ZQd7m0/zmbRveFGNb1slnyORCCP5fk
         TvCfTwYZf9JiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19DA7F0394D;
        Tue, 31 May 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/ipv6: Expand and rename accept_unsolicited_na to
 accept_untracked_na
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165399301210.20049.4916718889396503878.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 10:30:12 +0000
References: <20220530101414.65439-1-aajith@arista.com>
In-Reply-To: <20220530101414.65439-1-aajith@arista.com>
To:     Arun Ajith S <aajith@arista.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, dsahern@kernel.org,
        bagasdotme@gmail.com, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, prestwoj@gmail.com, corbet@lwn.net,
        justin.iurman@uliege.be, edumazet@google.com, shuah@kernel.org,
        gilligan@arista.com, noureddine@arista.com, gk@arista.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 30 May 2022 10:14:14 +0000 you wrote:
> RFC 9131 changes default behaviour of handling RX of NA messages when the
> corresponding entry is absent in the neighbour cache. The current
> implementation is limited to accept just unsolicited NAs. However, the
> RFC is more generic where it also accepts solicited NAs. Both types
> should result in adding a STALE entry for this case.
> 
> Expand accept_untracked_na behaviour to also accept solicited NAs to
> be compliant with the RFC and rename the sysctl knob to
> accept_untracked_na.
> 
> [...]

Here is the summary with links:
  - [net,v3] net/ipv6: Expand and rename accept_unsolicited_na to accept_untracked_na
    https://git.kernel.org/netdev/net/c/3e0b8f529c10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


