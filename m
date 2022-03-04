Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA364CD4E3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiCDNLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiCDNLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:11:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9621C1B8BF7
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 05:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB22B82976
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F178EC340F0;
        Fri,  4 Mar 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646399413;
        bh=Iquwvg6lDQ1Sde0n3UfOb5tsduUpIVrjawIeXPeRQMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NzlQmyuPSlbgb1I4aD2+LN0pfXTkr1/RJZIFVZ4uhzSxlH0UclzAoOpQPX2CcYBtk
         0ZRsYdWro5QqLXOVzqbobSTSgVZrkxONv3ziR9SywVEMdZr4quenXmRVlsk6jGxLSf
         +g/QNswZu2jUD5qRiUDeW9svGHUpa7kf6jMyhDMR9kB/f039KDKfpZ2pkOw9mj12Jg
         RMqh0NBEvtRXbDR8pW4z2AweAVe8OntPXr1OdgF0Kr7Kc58R7FpL4lknv29oBT0oOj
         iFLBgE1aOFw+j+Y6qWxbEXB3XLWhVgOqYDQ6HIbkeYawG/9HGn+ojFZs36dva2ZJKB
         jYfMgksIKkBcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5DD6EAC09D;
        Fri,  4 Mar 2022 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] nfp: expose common functions to be used for
 AF_XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639941287.4305.5589228197370788458.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 13:10:12 +0000
References: <20220304102214.25903-2-simon.horman@corigine.com>
In-Reply-To: <20220304102214.25903-2-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        niklas.soderlund@corigine.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Mar 2022 11:22:10 +0100 you wrote:
> From: Niklas Söderlund <niklas.soderlund@corigine.com>
> 
> There are some common functionality that can be reused in the upcoming
> AF_XDP support. Expose those functions in the header. While at it mark
> some arguments of nfp_net_rx_csum() as const.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] nfp: expose common functions to be used for AF_XDP
    https://git.kernel.org/netdev/net-next/c/3cdb35fb9cd5
  - [net-next,2/5] nfp: wrap napi add/del logic
    https://git.kernel.org/netdev/net-next/c/58eb43635344
  - [net-next,3/5] nfp: xsk: add an array of xsk buffer pools to each data path
    https://git.kernel.org/netdev/net-next/c/543bd14fc8f6
  - [net-next,4/5] nfp: xsk: add configuration check for XSK socket chunk size
    https://git.kernel.org/netdev/net-next/c/9c91a3653fbb
  - [net-next,5/5] nfp: xsk: add AF_XDP zero-copy Rx and Tx support
    https://git.kernel.org/netdev/net-next/c/6402528b7a0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


